import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domains/diary_book/diary_book.dart';
import '../../theme/app_theme.dart';

/// 友達に送る招待メッセージ。
String inviteMessage(DiaryBook diaryBook) {
  return 'Swap!で「${diaryBook.name}」に参加しよう！\n'
      'アプリの「招待コードで参加」から、このコードを入力してね。\n'
      '招待コード: ${diaryBook.inviteCode}';
}

/// [diaryBook] に友達を招待するシートを開く。招待コードと、それを送るためのコピーボタンを出す。
/// [justCreated] なら日記帳を作った直後として見出しを変える。
Future<void> showInviteSheet(
  BuildContext context,
  DiaryBook diaryBook, {
  bool justCreated = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _InviteSheet(diaryBook: diaryBook, justCreated: justCreated),
  );
}

class _InviteSheet extends StatelessWidget {
  const _InviteSheet({required this.diaryBook, required this.justCreated});

  final DiaryBook diaryBook;
  final bool justCreated;

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await Clipboard.setData(ClipboardData(text: inviteMessage(diaryBook)));
    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('招待メッセージをコピーしました')));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Padding(
        // 上はドラッグハンドルがあるので詰める。
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              justCreated
                  ? '「${diaryBook.name}」を作りました'
                  : '「${diaryBook.name}」に招待',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              justCreated
                  ? '友達を招待して、記録や日記を共有しましょう。招待コードを送ると、受け取った人がコードを入れて参加できます'
                  : '招待コードを送ると、受け取った人がコードを入れて参加できます',
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: '招待コード ${diaryBook.inviteCode.split('').join(' ')}',
              excludeSemantics: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      '招待コード',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      diaryBook.inviteCode,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _copy(context),
              icon: const Icon(Icons.copy_outlined, size: 20),
              label: const Text('招待メッセージをコピー'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(justCreated ? 'あとで招待する' : '閉じる'),
            ),
          ],
        ),
      ),
    );
  }
}
