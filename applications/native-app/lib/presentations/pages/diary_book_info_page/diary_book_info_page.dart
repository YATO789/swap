import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/diary_book.dart';
import '../../../domains/diary_book/diary_book_member.dart';
import '../../providers/diary_book_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/confirm_sheet.dart';
import '../../components/cover_color_picker.dart';
import '../../components/diary_book_icon.dart';
import '../../components/invite_sheet.dart';
import '../../components/user_avatar.dart';
import '../router/router.dart';
import 'components/member_limit_sheet.dart';
import 'components/rename_sheet.dart';
import 'controller/diary_book_info_page_controller.dart';

/// 罫線1本ぶんの高さ。どの行もこの高さで並べる。
const _lineHeight = 56.0;

/// 日記帳の情報。日記帳を開いた最初のページのように、題名・書く人を
/// 罫線の上にまとめて記す。名前や表紙の色、人数の上限はここで書き換えられ、
/// 友達の招待・招待コードの作り直し・メンバーを外すこと・日記帳からの退出もここから行う。
class DiaryBookInfoPage extends ConsumerWidget {
  const DiaryBookInfoPage({super.key, required this.diaryBookId});

  final String diaryBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final diaryBooksState = ref.watch(diaryBookProvider);
    final diaryBook = diaryBooksState.value
        ?.where((diaryBook) => diaryBook.id == diaryBookId)
        .firstOrNull;
    final myId = ref.watch(profileProvider).value?.id;

    // 退出した直後はホームに戻る途中なので何も出さない。
    if (diaryBook == null) return const Scaffold();

    // メンバーを外したり人数の上限を変えたりできるのは日記帳を作った人だけ。
    // 作った人が抜けていれば誰もできない。
    final isCreator = myId != null && diaryBook.createdBy == myId;

    final provider = diaryBookInfoPageControllerProvider(diaryBookId);
    final pageState = ref.watch(provider);
    DiaryBookInfoPageController controller() => ref.read(provider.notifier);

    final messenger = ScaffoldMessenger.of(context);
    void showMessage(String message) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    Future<void> rename() async {
      final name = await showRenameSheet(
        context,
        diaryBook.name,
        coverColor: diaryBook.coverColor,
      );
      if (name == null || name == diaryBook.name) return;
      if (!await controller().rename(name)) {
        showMessage(l10n.infoRenameFailed);
      }
    }

    Future<void> setCoverColor(Color? color) async {
      if (!await controller().setCoverColor(color?.toARGB32())) {
        showMessage(l10n.infoCoverColorFailed);
      }
    }

    Future<void> setMemberLimit() async {
      final memberLimit = await showMemberLimitSheet(
        context,
        memberLimit: diaryBook.memberLimit,
        // 一覧の人数より、このページで読んだメンバーのほうが新しい。
        memberCount: pageState.value?.members.length ?? diaryBook.memberCount,
      );
      if (memberLimit == null || memberLimit == diaryBook.memberLimit) return;
      if (!await controller().setMemberLimit(memberLimit)) {
        showMessage(l10n.infoMemberLimitFailed);
      }
    }

    Future<void> regenerateInviteCode() async {
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.infoRegenerateInviteCodeTitle,
        message: l10n.infoRegenerateInviteCodeMessage(diaryBook.inviteCode),
        confirmLabel: l10n.infoRegenerateInviteCodeConfirm,
      );
      if (!confirmed) return;

      if (!await controller().regenerateInviteCode()) {
        showMessage(l10n.infoRegenerateInviteCodeFailed);
        return;
      }
      showMessage(l10n.infoInviteCodeRegenerated);
    }

    Future<void> removeMember(DiaryBookMember member) async {
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.infoRemoveMemberTitle(member.displayName),
        message: l10n.infoRemoveMemberMessage,
        confirmLabel: l10n.infoRemoveMemberConfirm,
        destructive: true,
      );
      if (!confirmed) return;

      if (!await controller().removeMember(member.userId)) {
        showMessage(l10n.infoRemoveMemberFailed);
        return;
      }
      showMessage(l10n.infoMemberRemoved(member.displayName));
    }

    Future<void> leave() async {
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.infoLeaveTitle(diaryBook.name),
        message: l10n.infoLeaveMessage,
        confirmLabel: l10n.infoLeaveConfirm,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;

      final router = GoRouter.of(context);
      if (!await controller().leave()) {
        showMessage(l10n.infoLeaveFailed);
        return;
      }
      // 日記帳のページも開けなくなるので、ホームまで戻る。
      router.go(const HomeRoute().location);
      showMessage(l10n.infoLeft(diaryBook.name));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.commonDiaryBookInfo)),
      body: switch (pageState) {
        AsyncValue(:final value?, hasError: false) => RefreshIndicator(
          onRefresh: () => controller().refresh(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              24,
              32,
              24,
              MediaQuery.paddingOf(context).bottom + 8,
            ),
            children: [
              _Header(diaryBook: diaryBook, onRename: rename),
              _SectionLabel(l10n.infoCoverSection),
              _TapLine(
                label: l10n.commonName,
                semanticsLabel: l10n.infoRename,
                onTap: rename,
                trailing: Text(diaryBook.name),
              ),
              _RuledLine(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: CoverColorPicker(
                    alignment: WrapAlignment.start,
                    selected: diaryBook.coverColor == null
                        ? null
                        : Color(diaryBook.coverColor!),
                    onSelected: setCoverColor,
                  ),
                ),
              ),
              _SectionLabel(l10n.infoMembersSection),
              _TapLine(
                label: l10n.infoMemberLimit,
                semanticsLabel: l10n.infoChangeMemberLimit,
                onTap: isCreator ? setMemberLimit : null,
                trailing: Text(
                  l10n.infoMemberLimitValue(diaryBook.memberLimit),
                ),
              ),
              // 自分を先頭に、あとは参加した順に並べる。
              for (final (index, member) in [
                ...value.members.where((member) => member.userId == myId),
                ...value.members.where((member) => member.userId != myId),
              ].indexed)
                _MemberLine(
                  number: index + 1,
                  member: member,
                  isMe: member.userId == myId,
                  onRemove: isCreator ? () => removeMember(member) : null,
                ),
              _InviteLine(
                inviteCode: diaryBook.inviteCode,
                onTap: () => showInviteSheet(context, diaryBook),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: regenerateInviteCode,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textSecondary,
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: Text(l10n.infoRegenerateInviteCode),
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: leave,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(l10n.infoLeaveDiaryBook),
              ),
            ],
          ),
        ),
        AsyncError() => _LoadError(onRetry: () => controller().refresh()),
        _ => Center(
          child: CircularProgressIndicator(color: colors.textSecondary),
        ),
      },
    );
  }
}

/// 一番上の題名。題名を押すと名前を変えられる。
class _Header extends StatelessWidget {
  const _Header({required this.diaryBook, required this.onRename});

  final DiaryBook diaryBook;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final coverColor = diaryBook.coverColor;

    return Column(
      children: [
        Semantics(
          button: true,
          label: context.l10n.infoRenameSemantics(diaryBook.name),
          excludeSemantics: true,
          child: InkWell(
            onTap: onRename,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 鉛筆のぶんだけ左も空けて、題名を真ん中に置く。
                  const SizedBox(width: 22),
                  Flexible(
                    child: Text(
                      diaryBook.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 2,
          color: coverColor == null
              ? defaultCoverColor(context)
              : Color(coverColor),
        ),
      ],
    );
  }
}

/// 罫線の束の見出し。
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 2,
          color: context.appColors.textSecondary,
        ),
      ),
    );
  }
}

/// 罫線の引かれた1行。下に線を引いて、ノートの行に見せる。
class _RuledLine extends StatelessWidget {
  const _RuledLine({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _lineHeight),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.appColors.border)),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

/// 押すと書き換えられる1行。左に項目名、右に今の値を出す。
/// [onTap] が null なら書き換えられないので、値だけを出す。
class _TapLine extends StatelessWidget {
  const _TapLine({
    required this.label,
    required this.semanticsLabel,
    required this.onTap,
    required this.trailing,
  });

  final String label;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final onTap = this.onTap;

    final line = _RuledLine(
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 16),
          Expanded(
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: colors.textSecondary),
              child: trailing,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: colors.textSecondary),
          ],
        ],
      ),
    );
    if (onTap == null) return line;

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: InkWell(onTap: onTap, child: line),
    );
  }
}

/// メンバーの行のメニューでできること。
enum _MemberAction { remove }

/// メンバー1人の行。番号と名前を、署名のように罫線の上に記す。
/// [onRemove] があれば、自分以外の行に日記帳から外すメニューを添える。
class _MemberLine extends StatelessWidget {
  const _MemberLine({
    required this.number,
    required this.member,
    required this.isMe,
    required this.onRemove,
  });

  final int number;
  final DiaryBookMember member;
  final bool isMe;

  /// この人を日記帳から外す。外せないなら null。
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return _RuledLine(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          UserAvatar(imageUrl: member.avatarUrl, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              member.displayName,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          if (isMe)
            Text(
              context.l10n.infoYou,
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            )
          else if (onRemove case final onRemove?)
            PopupMenuButton<_MemberAction>(
              tooltip: context.l10n.infoMemberMenu(member.displayName),
              icon: Icon(
                Icons.more_horiz,
                size: 20,
                color: colors.textSecondary,
              ),
              onSelected: (action) => switch (action) {
                _MemberAction.remove => onRemove(),
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _MemberAction.remove,
                  child: Text(
                    context.l10n.infoRemoveFromDiaryBook,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// 名前がまだ書かれていない空の行。押すと友達を招待する。右に招待コードを添える。
class _InviteLine extends StatelessWidget {
  const _InviteLine({required this.inviteCode, required this.onTap});

  final String inviteCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: context.l10n.infoInviteSemantics(inviteCode.split('').join(' ')),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: _RuledLine(
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(Icons.add, size: 20, color: colors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.infoInviteFriends,
                  style: TextStyle(fontSize: 15, color: colors.textSecondary),
                ),
              ),
              Text(
                inviteCode,
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 2,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.infoLoadFailed,
            style: TextStyle(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    );
  }
}
