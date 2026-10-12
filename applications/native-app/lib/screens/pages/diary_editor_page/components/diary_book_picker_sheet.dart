import 'package:flutter/material.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/diary_book_icon.dart';

/// 「すべての日記帳」を選んだときに [showDiaryBookPicker] が返す値。
const allDiaryBooks = '*';

const allDiaryBooksLabel = 'すべての日記帳';

/// [diaryBooks] から1冊選ぶシートを開く。選んだ日記帳の id を返し、閉じたら null を返す。
/// [selectedId] の日記帳には印を付ける。[statusOf] を渡すと、名前の下に添える。
/// [allStatus] を渡すと、先頭に「すべての日記帳」を出し、その下に添える。
/// 選ばれたら [allDiaryBooks] を返す。
Future<String?> showDiaryBookPicker(
  BuildContext context, {
  required String title,
  required List<DiaryBook> diaryBooks,
  String? selectedId,
  String Function(DiaryBook diaryBook)? statusOf,
  String? allStatus,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _DiaryBookPickerSheet(
      title: title,
      diaryBooks: diaryBooks,
      selectedId: selectedId,
      statusOf: statusOf,
      allStatus: allStatus,
    ),
  );
}

class _DiaryBookPickerSheet extends StatelessWidget {
  const _DiaryBookPickerSheet({
    required this.title,
    required this.diaryBooks,
    required this.selectedId,
    required this.statusOf,
    required this.allStatus,
  });

  final String title;
  final List<DiaryBook> diaryBooks;
  final String? selectedId;
  final String Function(DiaryBook diaryBook)? statusOf;
  final String? allStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusOf = this.statusOf;
    final allStatus = this.allStatus;

    return SafeArea(
      child: Padding(
        // 上はドラッグハンドルがあるので詰める。
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            // 冊数が多いときは、シートの中でスクロールさせる。
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (allStatus != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      // 日記帳のアイコン（36）と幅を揃える。
                      leading: const SizedBox(
                        width: 36,
                        child: Icon(Icons.library_books_outlined, size: 28),
                      ),
                      title: const Text(allDiaryBooksLabel),
                      subtitle: Text(
                        allStatus,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                      trailing: selectedId == allDiaryBooks
                          ? const Icon(Icons.check)
                          : null,
                      selected: selectedId == allDiaryBooks,
                      onTap: () => Navigator.of(context).pop(allDiaryBooks),
                    ),
                  for (final diaryBook in diaryBooks)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: DiaryBookIcon(
                        name: diaryBook.name,
                        coverColor: diaryBook.coverColor,
                        size: 36,
                      ),
                      title: Text(
                        diaryBook.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: statusOf == null
                          ? null
                          : Text(
                              statusOf(diaryBook),
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                              ),
                            ),
                      trailing: diaryBook.id == selectedId
                          ? const Icon(Icons.check)
                          : null,
                      selected: diaryBook.id == selectedId,
                      onTap: () => Navigator.of(context).pop(diaryBook.id),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
