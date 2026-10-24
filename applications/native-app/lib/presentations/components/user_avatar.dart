import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'diary_book_icon.dart';

/// 名前の1文字目を丸の中に表示するアバター。
/// [color] があればその色で塗る。なければ自分（[filled]）は黒、ほかの人は白にする。
/// 名前はいつも横に並べて出すので、読み上げでは飾りとして扱う。
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    required this.filled,
    this.color,
    this.size = 34,
  });

  final String name;
  final bool filled;

  /// アイコンの色（0xAARRGGBB）。
  final int? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // 入力途中などで名前が空のときは、人のアイコンを出す。
    final initial = name.trim().characters.firstOrNull;
    final color = this.color;
    final background = color != null
        ? Color(color)
        : filled
        ? colors.textPrimary
        : colors.surface;
    final foreground = color != null
        ? coverInkColor(background)
        : filled
        ? colors.surface
        : colors.textPrimary;

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          // 色で塗るときは枠を付けない。
          border: color == null ? Border.all(color: colors.textPrimary) : null,
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
