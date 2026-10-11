import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 名前の1文字目を丸の中に表示するアバター。
/// 名前はいつも横に並べて出すので、読み上げでは飾りとして扱う。
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    required this.filled,
    this.size = 34,
  });

  final String name;
  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // 入力途中などで名前が空のときは、人のアイコンを出す。
    final initial = name.trim().characters.firstOrNull;
    final foreground = filled ? colors.surface : colors.textPrimary;

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? colors.textPrimary : colors.surface,
          border: Border.all(color: colors.textPrimary),
        ),
        child: initial == null
            ? Icon(Icons.person, size: size * 0.6, color: foreground)
            : Text(
                initial,
                // 文字サイズ設定で丸からはみ出さないようにする。
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: size * 0.41,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
      ),
    );
  }
}
