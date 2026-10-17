import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../domains/diary_book/diary_book.dart';
import '../../../../../domains/diary_book/invited_diary_book.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../components/diary_cover.dart';
import '../../../../components/user_avatar.dart';
import 'controller/join_diary_book_sheet_controller.dart';

/// 招待コードを入れて日記帳に参加するシートを開く。
/// コードに合う日記帳を見せてから参加し、参加した日記帳を返す。閉じたら null。
Future<DiaryBook?> showJoinDiaryBookSheet(BuildContext context) {
  return showModalBottomSheet<DiaryBook>(
    context: context,
    // キーボードの上まで持ち上げるので、高さを中身に合わせる。
    isScrollControlled: true,
    builder: (_) => const _JoinDiaryBookSheet(),
  );
}

/// 招待コードの文字。大文字と小文字は区別するので、l と I などを見分けやすい等幅にする。
const _codeFont = TextStyle(
  fontFamily: 'Menlo',
  fontFamilyFallback: ['monospace'],
);

class _JoinDiaryBookSheet extends HookConsumerWidget {
  const _JoinDiaryBookSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final codeController = useTextEditingController();
    useListenable(codeController);
    final code = codeController.text;
    final isComplete = code.length == inviteCodeLength;

    /// 「確認する」で確かめたコードと、その結果。コードを書き換えたら確認し直す。
    final checked = useState<({String code, InvitedDiaryBook? found})?>(null);
    final result = checked.value?.code == code ? checked.value : null;
    final found = result?.found;

    /// 確認や参加に失敗したときのメッセージ。コードを書き換えたら消す。
    final failure = useState<({String code, String message})?>(null);
    final errorText = failure.value?.code == code
        ? failure.value?.message
        : null;

    final busy = ref.watch(joinDiaryBookSheetControllerProvider).isLoading;
    final controller = ref.read(joinDiaryBookSheetControllerProvider.notifier);

    Future<void> check() async {
      if (!isComplete || busy) return;
      final diaryBook = await controller.check(code);
      if (!context.mounted) return;
      if (ref.read(joinDiaryBookSheetControllerProvider).hasError) {
        failure.value = (code: code, message: l10n.joinSheetCheckFailed);
        return;
      }
      checked.value = (code: code, found: diaryBook);
      if (diaryBook == null) {
        failure.value = (code: code, message: l10n.joinSheetCodeNotFound);
      }
    }

    // もう参加していれば何もせずに、その日記帳を返す。
    Future<void> join() async {
      if (busy) return;
      final diaryBook = await controller.join(code);
      if (!context.mounted) return;
      if (diaryBook == null) {
        failure.value = (code: code, message: l10n.joinSheetJoinFailed);
        return;
      }
      Navigator.of(context).pop(diaryBook);
    }

    Future<void> paste() async {
      final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
      if (text == null || text.isEmpty) return;
      final pasted = _InviteCodeFormatter()
          .formatEditUpdate(codeController.value, TextEditingValue(text: text))
          .text;
      final next = pasted.substring(0, min(pasted.length, inviteCodeLength));
      codeController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          // 上はドラッグハンドルがあるので詰める。
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: found == null
                ? _CodeInput(
                    controller: codeController,
                    errorText: errorText,
                    busy: busy,
                    onCheck: isComplete ? check : null,
                    onPaste: paste,
                  )
                : _FoundDiaryBook(
                    diaryBook: found,
                    errorText: errorText,
                    busy: busy,
                    onJoin: join,
                  ),
          ),
        ),
      ),
    );
  }
}

/// コードを入れる側。1文字ずつのマスと、貼り付けと確認のボタンを並べる。
class _CodeInput extends StatelessWidget {
  const _CodeInput({
    required this.controller,
    required this.errorText,
    required this.busy,
    required this.onCheck,
    required this.onPaste,
  });

  final TextEditingController controller;
  final String? errorText;
  final bool busy;

  /// コードがそろうまでは null。
  final VoidCallback? onCheck;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.commonJoinWithInviteCode,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.joinSheetDescription(inviteCodeLength),
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 22),
        _CodeBoxes(
          controller: controller,
          hasError: errorText != null,
          onSubmitted: onCheck,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                errorText ?? '',
                style: TextStyle(fontSize: 12, color: errorColor),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onPaste,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                side: BorderSide(color: colors.border, width: 1.5),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: const Icon(Icons.content_paste, size: 16),
              label: Text(l10n.joinSheetPaste),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _PillButton(label: l10n.joinSheetCheck, busy: busy, onPressed: onCheck),
      ],
    );
  }
}

/// 招待コードを1文字ずつマスに出す。
/// 入力は見えない TextField が受け持ち、マスのどこをタップしてもキーボードが開く。
class _CodeBoxes extends HookWidget {
  const _CodeBoxes({
    required this.controller,
    required this.hasError,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool hasError;
  final VoidCallback? onSubmitted;

  static const _gap = 6.0;
  static const _height = 54.0;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    useListenable(focusNode);
    final code = controller.text;

    return GestureDetector(
      onTap: focusNode.requestFocus,
      child: SizedBox(
        height: _height,
        child: Stack(
          children: [
            ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < inviteCodeLength; i++) ...[
                    if (i > 0) const SizedBox(width: _gap),
                    Expanded(
                      child: _CodeBox(
                        char: i < code.length ? code[i] : null,
                        active: focusNode.hasFocus && i == code.length,
                        hasError: hasError,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned.fill(
              child: Semantics(
                label: context.l10n.commonInviteCode,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  maxLength: inviteCodeLength,
                  autofocus: true,
                  // 大文字と小文字を区別するので、自動修正や大文字への変換で書き換えさせない。
                  autocorrect: false,
                  enableSuggestions: false,
                  // 文字はマスに出すので、入力欄そのものは見せない。
                  // 貼り付けは横のボタンからできる。
                  showCursor: false,
                  enableInteractiveSelection: false,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [_InviteCodeFormatter()],
                  onSubmitted: (_) => onSubmitted?.call(),
                  style: const TextStyle(color: Colors.transparent),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    isCollapsed: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({
    required this.char,
    required this.active,
    required this.hasError,
  });

  /// 入っている文字。まだなら null。
  final String? char;

  /// 次に入る位置。
  final bool active;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final filled = char != null;

    final borderColor = hasError
        ? Theme.of(context).colorScheme.error
        : (active || filled ? colors.textPrimary : colors.border);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled || active ? colors.surface : colors.placeholder,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: active ? 2.5 : 1.5),
      ),
      child: filled
          ? Text(
              char!,
              // マスの大きさは変わらないので、文字サイズ設定は効かせない。
              textScaler: TextScaler.noScaling,
              style: _codeFont.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            )
          : active
          ? Container(width: 2, height: 24, color: colors.textPrimary)
          : null,
    );
  }
}

/// コードに合う日記帳を見せて、参加するか決めてもらう側。
class _FoundDiaryBook extends StatelessWidget {
  const _FoundDiaryBook({
    required this.diaryBook,
    required this.errorText,
    required this.busy,
    required this.onJoin,
  });

  final InvitedDiaryBook diaryBook;
  final String? errorText;
  final bool busy;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final memberCount = diaryBook.memberNames.length;

    final (label, onPressed) = switch (diaryBook) {
      InvitedDiaryBook(alreadyJoined: true) => (l10n.joinSheetOpen, onJoin),
      InvitedDiaryBook(isFull: true) => (l10n.joinSheetJoin, null),
      _ => (l10n.joinSheetJoin, onJoin),
    };
    final note = switch (diaryBook) {
      InvitedDiaryBook(alreadyJoined: true) => l10n.joinSheetAlreadyJoined,
      InvitedDiaryBook(isFull: true) => l10n.joinSheetFull(
        diaryBook.memberLimit,
      ),
      _ => l10n.joinSheetSpotsLeft(diaryBook.memberLimit - memberCount),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Center(
          child: DiaryCover(
            name: diaryBook.name,
            color: diaryBook.coverColor == null
                ? null
                : Color(diaryBook.coverColor!),
            width: 120,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          diaryBook.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        _Members(
          names: diaryBook.memberNames,
          avatarColors: diaryBook.memberAvatarColors,
        ),
        const SizedBox(height: 28),
        _PillButton(label: label, busy: busy, onPressed: onPressed),
        const SizedBox(height: 10),
        Text(
          errorText ?? note,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: errorText == null
                ? colors.textSecondary
                : Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}

/// メンバーのアバターと人数。
class _Members extends StatelessWidget {
  const _Members({required this.names, required this.avatarColors});

  final List<String> names;

  /// [names] と同じ順のアイコンの色。
  final List<int?> avatarColors;

  /// アバターを並べる最大人数。残りは「+n」にする。
  static const _maxAvatars = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final rest = names.length - _maxAvatars;
    final secondary = TextStyle(fontSize: 13, color: colors.textSecondary);

    return Wrap(
      spacing: 4,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (index, name) in names.take(_maxAvatars).indexed)
          UserAvatar(
            name: name,
            filled: false,
            color: avatarColors.elementAtOrNull(index),
            size: 30,
          ),
        if (rest > 0) Text('+$rest', style: secondary),
        const SizedBox(width: 6),
        Text(context.l10n.joinSheetMemberCount(names.length), style: secondary),
      ],
    );
  }
}

/// シートの一番下に置く、黒く塗りつぶした丸いボタン。処理中はくるくるを出す。
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: const StadiumBorder(),
      ),
      child: busy
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.surface,
              ),
            )
          : Text(label),
    );
  }
}

/// 英数字だけを入れる。招待メッセージを丸ごと貼り付けたときは、その中の招待コードだけを取り出す。
class _InviteCodeFormatter extends TextInputFormatter {
  static final _notCode = RegExp('[^a-zA-Z0-9]');

  /// 前後が英数字でない、招待コードの文字数ちょうどの英数字。
  static final _code = RegExp(
    '(?<![a-zA-Z0-9])[a-zA-Z0-9]{$inviteCodeLength}(?![a-zA-Z0-9])',
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (!_notCode.hasMatch(text)) return newValue;
    // 招待メッセージは最後にコードがあるので、最後に見つかったものを使う。
    final code =
        _code.allMatches(text).lastOrNull?.group(0) ??
        text.replaceAll(_notCode, '');
    return TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );
  }
}
