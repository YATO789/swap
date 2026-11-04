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

/// 「表紙を飾る」の横に出す見本の飾り。作ったばかりの日記帳の色の表紙に重ねて、
/// 飾るとどうなるかを見せる。名前は貼らず、どの日記帳でも「Diary」と出す。
const _sampleDecoration = CoverDecoration(
  stickers: [
    CoverSticker(emoji: '😎', x: 0.298, y: 0.242, size: 0.22, rotation: -0.13),
    CoverSticker(emoji: '❤️', x: 0.802, y: 0.301, size: 0.22, rotation: 0.169),
    CoverSticker(emoji: '🐰', x: 0.3, y: 1.096, size: 0.277, rotation: -0.182),
    CoverSticker(emoji: '🎀', x: 0.651, y: 1.144, size: 0.217, rotation: -0.12),
    CoverSticker(
      emoji: '💌',
      x: 0.836,
      y: 0.788,
      size: 0.213,
      rotation: -0.185,
    ),
    CoverSticker(emoji: '🍓', x: 0.185, y: 0.719, size: 0.181, rotation: 0.465),
    CoverSticker(
      text: '2026',
      x: 0.53,
      y: 0.791,
      size: 0.171,
      rotation: -0.033,
    ),
    CoverSticker(
      text: 'Diary',
      x: 0.512,
      y: 0.588,
      size: 0.419,
      rotation: 0.013,
      color: 0xFF111111,
    ),
  ],
  // 「😎」と「🐰」のまわりの、きらっとした白い線。
  strokes: [
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.119, 0.102), Offset(0.152, 0.162)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.145, 0.073), Offset(0.196, 0.141)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.197, 0.041), Offset(0.212, 0.093), Offset(0.222, 0.11)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.43, 0.085), Offset(0.384, 0.109), Offset(0.368, 0.122)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.448, 0.119), Offset(0.376, 0.158)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.463, 0.16), Offset(0.407, 0.177), Offset(0.402, 0.182)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.142, 0.908), Offset(0.199, 0.974)],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [
        Offset(0.213, 0.846),
        Offset(0.233, 0.902),
        Offset(0.248, 0.932),
      ],
    ),
    CoverStroke(
      color: 0xFFFFFFFF,
      width: 0.012,
      points: [Offset(0.332, 0.864), Offset(0.297, 0.92)],
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
              width: 96,
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
