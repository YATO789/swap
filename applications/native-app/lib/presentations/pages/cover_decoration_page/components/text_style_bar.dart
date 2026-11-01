import 'package:flutter/material.dart';

import '../../../../domains/diary_book/cover_decoration.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import 'bar_button.dart';
import 'color_palette.dart';
import 'pen_tools.dart';

/// 名前か文字を選んでいるときの帯。文字なら書き換えるボタンを、どちらも色を選ぶ丸を出す。
/// 色は表紙の色に合わせる「自動」、パレットを開く虹色の丸、ペンと同じ 7 色。横にスクロールできる。
class TextStyleBar extends StatelessWidget {
  const TextStyleBar({
    super.key,
    required this.sticker,
    required this.onEdit,
    required this.onColor,
  });

  final CoverSticker sticker;

  /// 文字を書き換える。名前はここでは変えないので null。
  final VoidCallback? onEdit;

  /// null なら表紙の色に合わせる。
  final ValueChanged<int?> onColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final names = penColorNames(l10n);
    final onEdit = this.onEdit;

    Widget colorDot(int? color, String label) {
      final selected = sticker.color == color;
      return Semantics(
        button: true,
        selected: selected,
        label: l10n.coverEditTextColorSemantics(label),
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () => onColor(color),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color == null ? colors.surface : Color(color),
              shape: BoxShape.circle,
              // 選んでいる色は地の色の隙間を空けて、文字の色で囲む（ペンの色と同じ）。
              border: Border.all(
                color: selected ? colors.surface : colors.border,
                width: selected ? 3 : 1,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(color: colors.textPrimary, spreadRadius: 2),
              ],
            ),
            alignment: Alignment.center,
            // 表紙に合わせる色は、決まった色がないので「自動」の字で見せる。
            child: color == null
                ? Text(
                    l10n.coverEditTextColorAuto,
                    maxLines: 1,
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  )
                : null,
          ),
        ),
      );
    }

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          if (onEdit != null) ...[
            BarButton(label: l10n.coverEditRewrite, onPressed: onEdit),
            const SizedBox(width: 22),
          ],
          Center(child: colorDot(null, l10n.coverEditTextColorAutoName)),
          const SizedBox(width: 10),
          Center(
            child: PaletteDot(
              title: l10n.colorPaletteTextTitle,
              custom: penColors.contains(sticker.color) ? null : sticker.color,
              onSelected: onColor,
            ),
          ),
          for (final (index, penColor) in penColors.indexed) ...[
            const SizedBox(width: 10),
            Center(child: colorDot(penColor, names[index])),
          ],
        ],
      ),
    );
  }
}
