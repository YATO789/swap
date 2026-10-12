import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../domains/diary_book/diary_book.dart';
import '../../../../../domains/diary_book/invited_diary_book.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../components/diary_book_icon.dart';
import '../../../../components/user_avatar.dart';
import 'controller/join_diary_book_dialog_controller.dart';

/// 招待コードを入れて日記帳に参加するダイアログを開く。
/// コードに合う日記帳を見せてから参加し、参加した日記帳を返す。閉じたら null。
Future<DiaryBook?> showJoinDiaryBookDialog(BuildContext context) {
  return showDialog<DiaryBook>(
    context: context,
    builder: (_) => const _JoinDiaryBookDialog(),
  );
}

class _JoinDiaryBookDialog extends HookConsumerWidget {
  const _JoinDiaryBookDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
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

    final busy = ref.watch(joinDiaryBookDialogControllerProvider).isLoading;
    final controller = ref.read(joinDiaryBookDialogControllerProvider.notifier);

    Future<void> check() async {
      if (!isComplete || busy) return;
      final diaryBook = await controller.check(code);
      if (!context.mounted) return;
      if (ref.read(joinDiaryBookDialogControllerProvider).hasError) {
        failure.value = (code: code, message: '確認できませんでした。もう一度お試しください');
        return;
      }
      checked.value = (code: code, found: diaryBook);
      if (diaryBook == null) {
        failure.value = (code: code, message: '招待コードが見つかりません');
      }
    }

    // もう参加していれば何もせずに、その日記帳を返す。
    Future<void> join() async {
      if (busy) return;
      final diaryBook = await controller.join(code);
      if (!context.mounted) return;
      if (diaryBook == null) {
        failure.value = (code: code, message: '参加できませんでした。もう一度お試しください');
        return;
      }
      Navigator.of(context).pop(diaryBook);
    }

    final (label, onPressed) = switch (found) {
      null => ('確認する', isComplete ? check : null),
      InvitedDiaryBook(alreadyJoined: true) => ('日記帳を開く', join),
      InvitedDiaryBook(isFull: true) => ('参加する', null),
      _ => ('参加する', join),
    };

    return AlertDialog(
      title: const Text('招待コードで参加'),
      // 確認したあとに日記帳を見せても、画面からはみ出さないようにする。
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: codeController,
            maxLength: inviteCodeLength,
            autofocus: true,
            // 大文字と小文字を区別するので、自動修正や大文字への変換で書き換えさせない。
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            inputFormatters: [_InviteCodeFormatter()],
            onSubmitted: (_) {
              if (found == null) check();
            },
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
            decoration: InputDecoration(
              hintText: 'PINコード',
              hintStyle: const TextStyle(letterSpacing: 0),
              errorText: errorText,
              counterText: '',
            ),
          ),
          if (found != null) ...[
            const SizedBox(height: 16),
            _DiaryBookPreview(diaryBook: found),
            if (found.alreadyJoined) ...[
              const SizedBox(height: 12),
              Text(
                'この日記帳にはもう参加しています',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
            ] else if (found.isFull) ...[
              const SizedBox(height: 12),
              Text(
                'この日記帳は満員です（$maxDiaryBookMembers人まで）',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
            ],
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: busy ? null : onPressed,
          child: busy
              ? SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.textSecondary,
                  ),
                )
              : Text(label),
        ),
      ],
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

/// 参加する前に、どんな日記帳かを見せる。
class _DiaryBookPreview extends StatelessWidget {
  const _DiaryBookPreview({required this.diaryBook});

  final InvitedDiaryBook diaryBook;

  /// アバターを並べる最大人数。残りは「+n」にする。
  static const _maxAvatars = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final members = diaryBook.memberNames;
    final rest = members.length - _maxAvatars;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          DiaryBookIcon(
            label: diaryBook.icon,
            coverColor: diaryBook.coverColor,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            diaryBook.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            '${members.length}人のメンバー',
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final member in members.take(_maxAvatars))
                UserAvatar(name: member, filled: false, size: 28),
              if (rest > 0)
                Text(
                  '+$rest',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
