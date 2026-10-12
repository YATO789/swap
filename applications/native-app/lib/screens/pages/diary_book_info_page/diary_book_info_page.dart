import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/diary_book.dart';
import '../../../domains/diary_book/diary_book_member.dart';
import '../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../theme/app_theme.dart';
import '../../components/cover_color_picker.dart';
import '../../components/diary_book_icon.dart';
import '../../components/invite_sheet.dart';
import '../../components/user_avatar.dart';
import '../router/router.dart';
import 'components/rename_dialog.dart';
import 'controller/diary_book_info_page_controller.dart';

/// 罫線1本ぶんの高さ。どの行もこの高さで並べる。
const _lineHeight = 56.0;

/// 日記帳の情報。日記帳を開いた最初のページのように、題名・書く人を
/// 罫線の上にまとめて記す。名前や表紙の色はここで書き換えられ、
/// 友達の招待・招待コードの作り直し・メンバーを外すこと・日記帳からの退出もここから行う。
class DiaryBookInfoPage extends ConsumerWidget {
  const DiaryBookInfoPage({super.key, required this.diaryBookId});

  final String diaryBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final diaryBooksState = ref.watch(diaryBookRepositoryProvider);
    final diaryBook = diaryBooksState.value
        ?.where((diaryBook) => diaryBook.id == diaryBookId)
        .firstOrNull;
    final myId = ref.watch(profileRepositoryProvider).value?.id;

    // 退出した直後はホームに戻る途中なので何も出さない。
    if (diaryBook == null) return const Scaffold();

    // メンバーを外せるのは日記帳を作った人だけ。作った人が抜けていれば誰も外せない。
    final canRemoveMembers = myId != null && diaryBook.createdBy == myId;

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
      final name = await showRenameDialog(context, diaryBook.name);
      if (name == null || name == diaryBook.name) return;
      if (!await controller().rename(name)) {
        showMessage('名前を変えられませんでした。もう一度お試しください');
      }
    }

    Future<void> setCoverColor(Color? color) async {
      if (!await controller().setCoverColor(color?.toARGB32())) {
        showMessage('表紙の色を変えられませんでした。もう一度お試しください');
      }
    }

    Future<void> regenerateInviteCode() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('招待コードを作り直しますか？'),
          content: Text(
            '今のコード（${diaryBook.inviteCode}）では参加できなくなります。参加しているメンバーはそのままです。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('作り直す'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      if (!await controller().regenerateInviteCode()) {
        showMessage('招待コードを作り直せませんでした。もう一度お試しください');
        return;
      }
      showMessage('招待コードを作り直しました');
    }

    Future<void> removeMember(DiaryBookMember member) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${member.displayName}さんを外しますか？'),
          content: const Text(
            'この日記帳の記録や日記が見られなくなります。また参加できないように、招待コードも作り直します。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('外す'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      if (!await controller().removeMember(member.userId)) {
        showMessage('メンバーを外せませんでした。もう一度お試しください');
        return;
      }
      showMessage('${member.displayName}さんを外しました');
    }

    Future<void> leave() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('「${diaryBook.name}」から退出しますか？'),
          content: const Text('この日記帳の記録や日記が見られなくなります。招待コードがあればまた参加できます。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('退出'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;

      final router = GoRouter.of(context);
      if (!await controller().leave()) {
        showMessage('日記帳から退出できませんでした。もう一度お試しください');
        return;
      }
      // 日記帳のページも開けなくなるので、ホームまで戻る。
      router.go(const HomeRoute().location);
      showMessage('「${diaryBook.name}」から退出しました');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('日記帳の情報')),
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
              const _SectionLabel('表紙'),
              _TapLine(
                label: '名前',
                semanticsLabel: '名前を変える',
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
              const _SectionLabel('この日記を書く人'),
              // 自分を先頭に、あとは参加した順に並べる。
              for (final (index, member) in [
                ...value.members.where((member) => member.userId == myId),
                ...value.members.where((member) => member.userId != myId),
              ].indexed)
                _MemberLine(
                  number: index + 1,
                  member: member,
                  isMe: member.userId == myId,
                  onRemove: canRemoveMembers
                      ? () => removeMember(member)
                      : null,
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
                  child: const Text('招待コードを作り直す'),
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
                child: const Text('日記帳を退出'),
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
          label: '${diaryBook.name}、名前を変える',
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
class _TapLine extends StatelessWidget {
  const _TapLine({
    required this.label,
    required this.semanticsLabel,
    required this.onTap,
    required this.trailing,
  });

  final String label;
  final String semanticsLabel;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        child: _RuledLine(
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
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 20, color: colors.textSecondary),
            ],
          ),
        ),
      ),
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
          UserAvatar(name: member.displayName, filled: isMe, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              member.displayName,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          if (isMe)
            Text(
              'あなた',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            )
          else if (onRemove case final onRemove?)
            PopupMenuButton<_MemberAction>(
              tooltip: '${member.displayName}さんのメニュー',
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
                    'この日記帳から外す',
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
      label: '友達を招待、招待コード ${inviteCode.split('').join(' ')}',
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
                  '友達を招待する',
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
            '日記帳の情報を読み込めませんでした',
            style: TextStyle(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('もう一度試す')),
        ],
      ),
    );
  }
}
