import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domains/diary_book/diary_book.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';

/// 友達に送る招待メッセージ。
/// 参加するシートは最後に見つかったコードを使うので、どの言語でもコードを最後に置く。
String inviteMessage(AppLocalizations l10n, DiaryBook diaryBook) {
  return l10n.inviteSheetMessage(diaryBook.name, diaryBook.inviteCode);
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
    final l10n = context.l10n;
    await Clipboard.setData(
      ClipboardData(text: inviteMessage(l10n, diaryBook)),
    );
    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.inviteSheetCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

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
                  ? l10n.inviteSheetCreatedTitle(diaryBook.name)
                  : l10n.inviteSheetTitle(diaryBook.name),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              justCreated
                  ? l10n.inviteSheetCreatedDescription
                  : l10n.inviteSheetDescription,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: l10n.inviteSheetCodeSemantics(
                diaryBook.inviteCode.split('').join(' '),
              ),
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
                      l10n.commonInviteCode,
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
              label: Text(l10n.inviteSheetCopy),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                justCreated ? l10n.inviteSheetLater : l10n.commonClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
