import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/diary_book.dart';
import '../../../domains/diary_book/diary_book_member.dart';
import '../../providers/diary_book_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/confirm_sheet.dart';
import '../../components/cover_decoration_layer.dart';
import '../../components/diary_cover.dart';
import '../../components/discard_guard.dart';
import '../../components/invite_sheet.dart';
import '../../components/user_avatar.dart';
import '../router/router.dart';
import 'components/member_limit_sheet.dart';
import 'controller/diary_book_info_page_controller.dart';

/// 罫線1本ぶんの高さ。どの行もこの高さで並べる。
const _lineHeight = 56.0;

/// 日記帳の情報。日記帳を開いた最初のページのように、表紙と書く人を
/// 罫線の上にまとめて記す。名前は表紙の下の入力欄で、表紙の色・飾りは表紙の編集ページを開いて書き換える。
/// 人数の上限はここで書き換えられ、友達の招待・招待コードの作り直し・メンバーを外すこと・
/// 日記帳からの退出もここから行う。
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

    /// 名前を [name] にする。表紙に貼った名前は、文字の大きさが変わらないよう名前の長さに合わせて幅を変える。
    /// 変えられたら true。
    Future<bool> rename(String name) async {
      final decoration = diaryBook.coverDecoration;
      final edited = diaryBook.copyWith(
        name: name,
        // 新しいアプリで飾った表紙は、知らない飾りを消さないよう飾りには触らない。
        coverDecoration: decoration == null || !decoration.isEditable
            ? decoration
            : renamedCoverDecoration(decoration, diaryBook.name, name),
      );
      if (!await controller().rename(diaryBook, edited)) {
        showMessage(l10n.infoRenameFailed);
        return false;
      }
      showMessage(l10n.infoRenamed);
      return true;
    }

    // 表紙の色・飾りは、表紙の編集ページで変える。
    void editCover() {
      // 新しいアプリで飾った表紙は、知らない飾りを消さないよう編集させない。
      if (!(diaryBook.coverDecoration?.isEditable ?? true)) {
        showMessage(l10n.coverEditNeedsUpdate);
        return;
      }
      CoverDecorationRoute(id: diaryBook.id).push<void>(context);
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
              _CoverHero(
                diaryBook: diaryBook,
                onEdit: editCover,
                onRename: rename,
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

/// 一番上に今の表紙を大きく置き、その下で日記帳の名前を書き換えられるようにする。
/// 名前を変えられるのはここだけ。表紙か「表紙を編集」を押すと、表紙の編集ページで色・飾りを変えられる。
class _CoverHero extends HookWidget {
  const _CoverHero({
    required this.diaryBook,
    required this.onEdit,
    required this.onRename,
  });

  static const _coverWidth = 160.0;

  final DiaryBook diaryBook;
  final VoidCallback onEdit;

  /// 名前を変える。変えられたら true。
  final Future<bool> Function(String name) onRename;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final name = diaryBook.name;
    final controller = useTextEditingController(text: name);
    final focusNode = useFocusNode();
    final focused = useListenableSelector(focusNode, () => focusNode.hasFocus);
    final typed = useValueListenable(controller).text.trim();
    final saving = useState(false);
    // 書き換えていて、保存できる名前か。
    final changed = typed.isNotEmpty && typed != name;

    // ほかのメンバーが名前を変えたら、書き換えている途中でなければ入力欄も合わせる。
    final previousName = usePrevious(name);
    useEffect(() {
      if (controller.text.trim() == (previousName ?? name)) {
        controller.text = name;
      }
      return null;
    }, [name]);

    /// 書いた名前を保存する。「保存」か「完了」を押したときだけ呼ぶ。
    /// 前後の空白は除き、空なら今の名前に戻す。変えられなかったら書いた名前を残す。
    Future<void> submit() async {
      final text = controller.text.trim();
      if (text.isEmpty || text == name) {
        controller.text = name;
        focusNode.unfocus();
        return;
      }
      controller.text = text;
      focusNode.unfocus();
      saving.value = true;
      await onRename(text);
      if (!context.mounted) return;
      saving.value = false;
    }

    // 保存していない名前があれば、戻るときに捨ててよいか確かめる。
    return DiscardGuard(
      dirty: changed,
      child: Column(
        children: [
          Semantics(
            button: true,
            label: l10n.infoEditCoverSemantics(name),
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onEdit,
              child: DiaryCover(
                name: name,
                color: diaryBook.coverColor == null
                    ? null
                    : Color(diaryBook.coverColor!),
                width: _coverWidth,
                decoration: diaryBook.coverDecoration,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: !saving.value,
              maxLength: maxDiaryBookNameLength,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(),
              onTapOutside: (_) => focusNode.unfocus(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: l10n.infoNameHint,
                // 書いているか書き換えたままのあいだは、保存のしかたを下に出す。
                helperText: focused || changed ? l10n.infoNameSaveHelper : null,
                helperMaxLines: 2,
                helperStyle: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                ),
                // 左にも同じ幅を空けて、名前を真ん中に保つ。
                prefixIcon: const SizedBox(width: 56),
                prefixIconConstraints: const BoxConstraints(minWidth: 56),
                suffixIcon: _NameSaveButton(
                  saving: saving.value,
                  visible: changed,
                  onPressed: submit,
                ),
                suffixIconConstraints: const BoxConstraints(minWidth: 56),
                // 文字数は出さない。上限に届いたらそれ以上入らない。
                counterText: '',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.border),
                ),
                // 保存しているあいだは書けないが、線の見た目は変えない。
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.textPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: Text(l10n.coverEditTitle),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(color: colors.border),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 名前の入力欄の右の、保存するボタン。保存しているあいだは回る印を出す。
class _NameSaveButton extends StatelessWidget {
  const _NameSaveButton({
    required this.saving,
    required this.visible,
    required this.onPressed,
  });

  final bool saving;

  /// 書き換えていて保存できるときだけ出す。
  final bool visible;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (saving) {
      return Center(
        widthFactor: 1,
        child: SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colors.textSecondary,
          ),
        ),
      );
    }
    if (!visible) {
      return const SizedBox(width: 56);
    }
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.textPrimary,
        minimumSize: const Size(56, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      child: Text(context.l10n.infoNameSave),
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
