import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../../components/sheet_parts.dart';

/// テーマを選ぶシートを開く。[labels] の順に並べ、[selected] に印を付ける。
/// 選んだらすぐ閉じてそのテーマを返す。選ばずに閉じたら null。
Future<ThemeMode?> showThemeModeSheet(
  BuildContext context, {
  required ThemeMode selected,
  required Map<ThemeMode, String> labels,
}) {
  return showModalBottomSheet<ThemeMode>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final colors = context.appColors;

      return SheetBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetTitle('テーマ'),
            const SizedBox(height: 12),
            for (final MapEntry(key: mode, value: label) in labels.entries)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                selected: mode == selected,
                selectedColor: colors.textPrimary,
                title: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: mode == selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                trailing: mode == selected
                    ? Icon(Icons.check, color: colors.textPrimary)
                    : null,
                onTap: () => Navigator.of(context).pop(mode),
              ),
          ],
        ),
      );
    },
  );
}
