import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'diary_book_icon.dart';

/// 新しく日記帳を作るときに最初から選んでおく表紙の色（黒）。
const initialCoverColor = Color(0xFF2B2B2B);

/// 選べる表紙の色。先頭の null は決まったグレー。
/// どれも白い文字が読めるくらいの濃さにしてある。
const coverColors = <Color?>[
  null,
  initialCoverColor,
  Color(0xFF2F3E5C),
  Color(0xFF3F5E4A),
  Color(0xFFA9533F),
  Color(0xFFB98A2E),
  Color(0xFFB9707C),
];

/// 表紙の色を選ぶ丸の並び。選んでいる色は外側に輪を付ける。
class CoverColorPicker extends StatelessWidget {
  const CoverColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.alignment = WrapAlignment.center,
  });

  final Color? selected;
  final ValueChanged<Color?> onSelected;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      alignment: alignment,
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final color in coverColors)
          Semantics(
            button: true,
            selected: color == selected,
            label: '表紙の色',
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
                      color: color ?? defaultCoverColor(context),
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
