import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/diary_book_icon.dart';

/// [diaryBooks] から日記帳を何冊でも選ぶシートを開く。
/// [confirmLabel] のボタンを押すと選んだ日記帳の id を返し、閉じたら null を返す。
/// [initialIds] の日記帳は最初から選んでおく。[statusOf] を渡すと、名前の下に添える。
Future<List<String>?> showDiaryBookPicker(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required List<DiaryBook> diaryBooks,
  Set<String> initialIds = const {},
  String Function(DiaryBook diaryBook)? statusOf,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _DiaryBookPickerSheet(
      title: title,
      confirmLabel: confirmLabel,
      diaryBooks: diaryBooks,
      initialIds: initialIds,
      statusOf: statusOf,
    ),
  );
}

class _DiaryBookPickerSheet extends HookWidget {
  const _DiaryBookPickerSheet({
    required this.title,
    required this.confirmLabel,
    required this.diaryBooks,
    required this.initialIds,
    required this.statusOf,
  });

  final String title;
  final String confirmLabel;
  final List<DiaryBook> diaryBooks;
  final Set<String> initialIds;
  final String Function(DiaryBook diaryBook)? statusOf;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusOf = this.statusOf;
    final selectedIds = useState({...initialIds});

    void toggle(String id) {
      final ids = {...selectedIds.value};
      if (!ids.remove(id)) ids.add(id);
      selectedIds.value = ids;
    }

    void confirm() {
      // 日記帳の並び順のまま返す。
      Navigator.of(context).pop([
        for (final diaryBook in diaryBooks)
          if (selectedIds.value.contains(diaryBook.id)) diaryBook.id,
      ]);
    }

    return SafeArea(
      child: Padding(
        // 上はドラッグハンドルがあるので詰める。
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  for (final diaryBook in diaryBooks)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.trailing,
                      secondary: DiaryBookIcon(
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
                      value: selectedIds.value.contains(diaryBook.id),
                      onChanged: (_) => toggle(diaryBook.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: selectedIds.value.isEmpty ? null : confirm,
              child: Text(confirmLabel),
            ),
          ],
        ),
      ),
    );
  }
}
