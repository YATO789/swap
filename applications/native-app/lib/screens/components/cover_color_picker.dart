import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import 'diary_book_icon.dart';

/// 新しく日記帳を作るときに最初から選んでおく表紙の色（ミント）。
const initialCoverColor = Color(0xFF9EE6C4);

/// 表紙の色の黒。
const coverBlackColor = Color(0xFF2A2A2E);

/// 選べる表紙の色。先頭の null は決まったグレーで、黒のあとは色相の順。
/// 黒のほかは明るいパステルにしてあり、表紙の文字は [coverInkColor] で黒になる。
const coverColors = <Color?>[
  null,
  coverBlackColor,
  Color(0xFFFFB4A8),
  Color(0xFFFFC98A),
  Color(0xFFFFE07A),
  Color(0xFFC8E68C),
  initialCoverColor,
  Color(0xFF9EDCF0),
  Color(0xFFA8C8FF),
  Color(0xFFD9C2FF),
  Color(0xFFFFB3D9),
];
/// 表紙の色を選ぶ丸の並び。選んでいる色は外側に輪を付ける。
/// アイコンの色のように表紙以外の色を選ぶときは、[choices]・[defaultColor]・[label] を変える。
class CoverColorPicker extends StatelessWidget {
  const CoverColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.alignment = WrapAlignment.center,
    this.choices = coverColors,
    this.defaultColor,
    this.label,
  });

  final Color? selected;
  final ValueChanged<Color?> onSelected;
  final WrapAlignment alignment;

  /// 並べる色。null は [defaultColor] の丸。
  final List<Color?> choices;

  /// 先頭の null の丸に塗る色。なければ [defaultCoverColor]。
  final Color? defaultColor;

  /// 読み上げで丸に付ける名前。なければ「表紙の色」。
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      alignment: alignment,
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final color in choices)
          Semantics(
            button: true,
            selected: color == selected,
            label: label ?? context.l10n.coverColorLabel,
            child: GestureDetector(
              onTap: () => onSelected(color),
              behavior: HitTestBehavior.opaque,
              // 指で押しやすいよう、見た目の丸より広く当たりを取る。
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: color == selected
                          ? colors.textPrimary
                          : Colors.transparent,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          color ?? defaultColor ?? defaultCoverColor(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
