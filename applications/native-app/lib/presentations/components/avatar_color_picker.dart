import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import 'cover_color_picker.dart';

/// 選べるアイコンの色。表紙の色から、決まったグレーの null と、決まった塗りと見分けにくい黒を除いたもの。
final _avatarColors = [
  for (final color in coverColors)
    if (color != null && color != coverBlackColor) color,
];

/// 初めて名前を決めるときに最初から選んでおくアイコンの色（0xAARRGGBB）。選べる色の先頭。
final initialAvatarColor = _avatarColors.first.toARGB32();

/// 自分のアイコンの色を選ぶ丸の並び。[selected] は 0xAARRGGBB で、null ならどれも選んでいない。
class AvatarColorPicker extends StatelessWidget {
  const AvatarColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = this.selected;

    return CoverColorPicker(
      alignment: WrapAlignment.start,
      choices: _avatarColors,
      label: context.l10n.commonAvatarColor,
      selected: selected == null ? null : Color(selected),
      // 並べる色に null はないので、押された色はいつもある。
      onSelected: (color) => onSelected(color!.toARGB32()),
    );
  }
}
