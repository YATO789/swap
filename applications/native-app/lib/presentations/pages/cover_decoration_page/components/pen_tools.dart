import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import 'bar_button.dart';
import 'color_palette.dart';

/// らくがきのペンの色（0xAARRGGBB）。
const penColors = [
  0xFF111111,
  0xFFFFFFFF,
  0xFFE5484D,
  0xFFF5A524,
  0xFF30A46C,
  0xFF3E63DD,
  0xFFD6409F,
];

/// らくがきのペンの太さ（表紙の幅との割合）。極細・細い・ふつう・太い。
/// 極細は、表紙を拡大して細かく描くためのもの。
const penWidths = [0.006, 0.012, 0.024, 0.045];

/// はじめに選んでいるペンの太さ（ふつう）。
const defaultPenWidth = 0.024;

/// [penColors] と同じ順の、読み上げる色の名前。
List<String> penColorNames(AppLocalizations l10n) {
  return [
    l10n.coverEditPenBlack,
    l10n.coverEditPenWhite,
    l10n.coverEditPenRed,
    l10n.coverEditPenOrange,
    l10n.coverEditPenGreen,
    l10n.coverEditPenBlue,
    l10n.coverEditPenPink,
  ];
}

/// [penWidths] と同じ順の、読み上げるペンの名前。
List<String> _penWidthNames(AppLocalizations l10n) {
  return [
    l10n.coverEditPenExtraThin,
    l10n.coverEditPenThin,
    l10n.coverEditPenMedium,
    l10n.coverEditPenThick,
  ];
}

/// らくがきのあいだの、ペンの色を選ぶ帯。先頭の虹色の丸でパレットから選べる。
/// 消しゴムのときは [color] が null。
class PenColorBar extends StatelessWidget {
  const PenColorBar({
    super.key,
    required this.color,
    required this.custom,
    required this.onSelected,
  });

  final int? color;

  /// パレットで選んだ色。ほかの色に変えても、虹色の丸の中に出しておく。
  final int? custom;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final names = penColorNames(l10n);
    final color = this.color;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          PaletteDot(
            title: l10n.colorPalettePenTitle,
            size: 30,
            custom: custom,
            selected: custom != null && custom == color,
            onSelected: onSelected,
          ),
          for (final (index, penColor) in penColors.indexed) ...[
            const SizedBox(width: 10),
            Semantics(
              button: true,
              selected: penColor == color,
              label: names[index],
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => onSelected(penColor),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(penColor),
                    shape: BoxShape.circle,
                    // 白いペンも地の上で見えるよう、どの色にも細い線を引く。
                    // 選んでいる色は地の色の隙間を空けて、文字の色で囲む。
                    border: Border.all(
                      color: penColor == color ? colors.surface : colors.border,
                      width: penColor == color ? 3 : 1,
                    ),
                    boxShadow: [
                      if (penColor == color)
                        BoxShadow(color: colors.textPrimary, spreadRadius: 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// らくがきのあいだの、太さ・消しゴム・終わるボタン。
class PenTools extends StatelessWidget {
  const PenTools({
    super.key,
    required this.width,
    required this.erasing,
    required this.onWidthSelected,
    required this.onEraserToggled,
    required this.onDone,
  });

  /// 選んでいるペンの太さ。
  final double width;
  final bool erasing;
  final ValueChanged<double> onWidthSelected;
  final VoidCallback onEraserToggled;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final names = _penWidthNames(l10n);

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          for (final (index, penWidth) in penWidths.indexed) ...[
            if (index > 0) const SizedBox(width: 6),
            _PenWidthButton(
              width: penWidth,
              label: names[index],
              selected: !erasing && width == penWidth,
              onPressed: () => onWidthSelected(penWidth),
            ),
          ],
          const SizedBox(width: 10),
          BarButton(
            label: l10n.coverEditEraser,
            toggled: erasing,
            onPressed: onEraserToggled,
          ),
          const Spacer(),
          DoneButton(label: l10n.coverEditDone, onPressed: onDone),
        ],
      ),
    );
  }
}

/// らくがきのペンの太さを選ぶボタン。太さを丸の大きさで見せる。
class _PenWidthButton extends StatelessWidget {
  const _PenWidthButton({
    required this.width,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  /// ペンの太さ（表紙の幅との割合）。
  final double width;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dot = 4 + width * 200;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 40,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? colors.textPrimary : colors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: dot,
            height: dot,
            decoration: BoxDecoration(
              color: colors.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
