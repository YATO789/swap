import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domains/diary_book/cover_decoration.dart';
import '../../domains/diary_book/diary_book.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../utils/store_pages.dart';
import 'diary_cover.dart';

/// 友達に送る招待メッセージ。アプリを入れていない友達のために、App Store のページも添える。
/// 参加するシートは最後に見つかったコードを使うので、どの言語でもコードを最後に置く。
String inviteMessage(AppLocalizations l10n, DiaryBook diaryBook) {
  return l10n.inviteSheetMessage(
    diaryBook.name,
    appStoreUrl.toString(),
    diaryBook.inviteCode,
  );
}

/// 「表紙を飾る」の横に出す見本の飾り。作ったばかりの日記帳の名前と色の表紙に重ねて、
/// 飾るとどうなるかを見せる。名前はどの長さでも収まるよう、v1 の決まった形で出す。
const _sampleDecoration = CoverDecoration(
  version: 1,
  stickers: [
    CoverSticker(emoji: '🌷', x: 0.74, y: 0.98, size: 0.38, rotation: 0.2),
    CoverSticker(emoji: '⭐️', x: 0.34, y: 1.14, size: 0.28, rotation: -0.25),
  ],
  strokes: [
    CoverStroke(
      color: 0xFF3E63DD,
      width: 0.03,
      points: [
        Offset(0.26, 0.66),
        Offset(0.37, 0.61),
        Offset(0.48, 0.66),
        Offset(0.59, 0.61),
        Offset(0.7, 0.66),
        Offset(0.81, 0.61),
      ],
    ),
  ],
);

/// [diaryBook] に友達を招待するシートを開く。招待コードと、それを送るためのコピーボタンを出す。
/// [justCreated] なら日記帳を作った直後として見出しを変える。
/// [onDecorateCover] を渡すと、飾った表紙の見本と「表紙を飾る」を出し、押したらシートを閉じて呼ぶ。
Future<void> showInviteSheet(
  BuildContext context,
  DiaryBook diaryBook, {
  bool justCreated = false,
  VoidCallback? onDecorateCover,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _InviteSheet(
      diaryBook: diaryBook,
      justCreated: justCreated,
      onDecorateCover: onDecorateCover,
    ),
  );
}

class _InviteSheet extends StatelessWidget {
  const _InviteSheet({
    required this.diaryBook,
    required this.justCreated,
    required this.onDecorateCover,
  });

  final DiaryBook diaryBook;
  final bool justCreated;
  final VoidCallback? onDecorateCover;

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
            if (onDecorateCover case final onDecorateCover?) ...[
              const SizedBox(height: 16),
              _DecorateCoverCard(
                diaryBook: diaryBook,
                onPressed: () {
                  Navigator.of(context).pop();
                  onDecorateCover();
                },
              ),
            ],
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

/// 表紙を飾れることを伝える欄。作ったばかりの日記帳の表紙に見本の飾りを重ねて見せ、
/// 「表紙を飾る」で表紙の編集ページへ進ませる。
class _DecorateCoverCard extends StatelessWidget {
  const _DecorateCoverCard({required this.diaryBook, required this.onPressed});

  final DiaryBook diaryBook;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final coverColor = diaryBook.coverColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // 見本の絵なので読み上げない。何ができるかは横の文で伝える。
          ExcludeSemantics(
            child: DiaryCover(
              name: diaryBook.name,
              color: coverColor == null ? null : Color(coverColor),
              width: 72,
              decoration: _sampleDecoration,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.inviteSheetDecorateMessage,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.palette_outlined, size: 20),
                  label: Text(l10n.inviteSheetDecorate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
