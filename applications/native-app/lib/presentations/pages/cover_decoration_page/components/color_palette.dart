import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/sheet_parts.dart';

/// 色を選ぶパレットのシートを開く。押した色（0xAARRGGBB）を返す。
///
/// [title] はシートの題名。[current] がパレットの色なら、その色を囲んで見せる。
Future<int?> showColorPaletteSheet(
  BuildContext context, {
  required String title,
  int? current,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _ColorPaletteSheet(title: title, current: current),
  );
}

/// パレットの列の数。色相を 30 度ずつに分ける。
const _columns = 12;

/// 色相ごとの明るさ。上の段ほど明るい。
const _lightnesses = [0.86, 0.74, 0.62, 0.5, 0.38, 0.26];

/// パレットの色。1段目は白から黒までの灰色、その下は色相ごとの明るさの段。
final List<int> paletteColors = [
  for (var i = 0; i < _columns; i++)
    HSLColor.fromAHSL(1, 0, 0, 1 - i / (_columns - 1)).toColor().toARGB32(),
  for (final lightness in _lightnesses)
    for (var i = 0; i < _columns; i++)
      HSLColor.fromAHSL(
        1,
        i * 360 / _columns,
        0.8,
        lightness,
      ).toColor().toARGB32(),
];

/// 読み上げに使う #RRGGBB。
String paletteColorName(int color) {
  final rgb = (color & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
  return '#${rgb.toUpperCase()}';
}

class _ColorPaletteSheet extends StatelessWidget {
  const _ColorPaletteSheet({required this.title, required this.current});

  final String title;
  final int? current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return SheetBody(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetTitle(title),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: _columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (final color in paletteColors)
                Semantics(
                  button: true,
                  selected: color == current,
                  label: l10n.colorPaletteSemantics(paletteColorName(color)),
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(color),
                        borderRadius: BorderRadius.circular(6),
                        // 白に近い色が地の色に溶けないよう、細い線で縁取る。
                        // 選んでいる色は文字の色で太く囲む。
                        border: Border.all(
                          color: color == current
                              ? colors.textPrimary
                              : colors.border,
                          width: color == current ? 2.5 : 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SheetPillButton(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// パレットを開く虹色の丸。押すとパレットのシートを開き、選んだ色を [onSelected] に渡す。
///
/// [custom] はパレットで選んでいる色。並んでいる決まった色のどれでもないときに渡す。
/// あれば虹色の輪の中にその色を出し、選んでいる形にする。
class PaletteDot extends StatelessWidget {
  const PaletteDot({
    super.key,
    required this.title,
    required this.custom,
    required this.onSelected,
    this.size = 26,
  });

  /// 開くシートの題名。
  final String title;

  final int? custom;
  final ValueChanged<int> onSelected;

  /// 丸の直径。
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final custom = this.custom;
    final selected = custom != null;

    return Semantics(
      button: true,
      selected: selected,
      label: context.l10n.colorPaletteOpen,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () async {
          final color = await showColorPaletteSheet(
            context,
            title: title,
            current: custom,
          );
          if (color != null) {
            onSelected(color);
          }
        },
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(selected ? size * 0.2 : 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const SweepGradient(
              colors: [
                Color(0xFFFF3B30),
                Color(0xFFFF9500),
                Color(0xFFFFCC00),
                Color(0xFF34C759),
                Color(0xFF00C7BE),
                Color(0xFF007AFF),
                Color(0xFFAF52DE),
                Color(0xFFFF3B30),
              ],
            ),
            boxShadow: [
              if (selected)
                BoxShadow(color: colors.textPrimary, spreadRadius: 2),
            ],
          ),
          child: selected
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(custom),
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surface, width: 1.5),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
