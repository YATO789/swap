import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// 共有先日記帳の選択ボタン。選択中は塗りつぶし、未選択は枠線だけ。
class DiaryBookChip extends StatelessWidget {
  const DiaryBookChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = selected ? colors.surface : colors.textPrimary;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? colors.textPrimary : colors.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? colors.textPrimary : colors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            // 文字を大きくしても切れないように、高さは最小値だけ決める。
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
