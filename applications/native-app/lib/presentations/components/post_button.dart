import 'package:flutter/material.dart';

import '../../domains/diary/diary.dart';
import '../../domains/diary_book/diary_book.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../pages/router/router.dart';
import 'post_sheet/post_sheet.dart';

/// 画面の下に置く書き込みバー。左は「今なにしてる？」の入力欄風の欄で、
/// 押すと投稿シートを開く。右のペンは日記を書くページを開く。
/// 浮かぶボタンだと一覧に重なるので、画面の一部として置く。
/// [diaryBook] を渡すと、記録も日記もその日記帳に入れる前提で開く。
/// 渡さなければ、日記は参加している日記帳すべてに書く（書くページで選び直せる）。
class PostButton extends StatelessWidget {
  const PostButton({
    super.key,
    this.diaryBook,
    this.diaryDate,
    this.onPosted,
    this.onDiaryClosed,
  });

  final DiaryBook? diaryBook;

  /// ペンで書く日記の日付。null なら今日。
  final DateTime? diaryDate;

  /// 記録したときに呼ぶ。表示している記録を読み直すのに使う。
  final VoidCallback? onPosted;

  /// 日記を書くページを閉じたときに呼ぶ。表示している日記を読み直すのに使う。
  final VoidCallback? onDiaryClosed;

  Future<void> _openPostSheet(BuildContext context) async {
    final posted = await showPostSheet(context, diaryBook: diaryBook);
    if (posted) onPosted?.call();
  }

  Future<void> _openDiaryEditor(BuildContext context, DateTime date) async {
    await DiaryEditorRoute(
      date: date,
      diaryBook: diaryBook?.id,
    ).push<void>(context);
    onDiaryClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final today = diaryDateOf(DateTime.now());
    final date = diaryDate ?? today;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: l10n.commonPost,
                excludeSemantics: true,
                // 角丸の四角に薄いグレーを敷いただけの、枠もアイコンもない入力欄の見た目。
                child: Material(
                  color: colors.placeholder,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openPostSheet(context),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.commonWhatAreYouDoing,
                        style: TextStyle(
                          fontSize: 17,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _openDiaryEditor(context, date),
              tooltip: date == today
                  ? l10n.postButtonWriteToday
                  : l10n.postButtonWriteYesterday,
              style: IconButton.styleFrom(
                fixedSize: const Size(48, 48),
                backgroundColor: colors.textPrimary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
