import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../components/sheet_parts.dart';

/// 自分の日記を長押ししたときに選べること。
enum DiaryAction { edit, delete }

/// 自分の日記を長押ししたときのメニューを下から出す。選んだものを返し、閉じたら null。
/// [canEdit] が false なら、もう書き直せない日なので「編集」を出さない。
Future<DiaryAction?> showDiaryActionsSheet(
  BuildContext context, {
  required bool canEdit,
}) {
  return showModalBottomSheet<DiaryAction>(
    context: context,
    builder: (context) {
      final error = Theme.of(context).colorScheme.error;

      return SheetBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canEdit)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.edit_outlined),
                title: Text(context.l10n.diaryDetailEdit),
                onTap: () => Navigator.of(context).pop(DiaryAction.edit),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_outline, color: error),
              title: Text(
                context.l10n.diaryDetailDelete,
                style: TextStyle(color: error),
              ),
              onTap: () => Navigator.of(context).pop(DiaryAction.delete),
            ),
          ],
        ),
      );
    },
  );
}
