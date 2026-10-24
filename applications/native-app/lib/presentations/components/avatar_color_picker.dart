import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import 'cover_color_picker.dart';

/// 選べるアイコンの色。表紙の色から、決まった塗りと見分けにくい黒を除いたもの。
final _avatarColors = [
  for (final color in coverColors)
    if (color != coverBlackColor) color,
];

/// 自分のアイコンの色を選ぶ丸の並び。[selected] は 0xAARRGGBB で、null なら決まった塗り。
class AvatarColorPicker extends StatelessWidget {
  const AvatarColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int? selected;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = this.selected;

    return CoverColorPicker(
      alignment: WrapAlignment.start,
      choices: _avatarColors,
      // 色を選ばなければ、自分のアイコンはいつもの塗りつぶしになる。
      defaultColor: context.appColors.textPrimary,
      label: context.l10n.commonAvatarColor,
      selected: selected == null ? null : Color(selected),
      onSelected: (color) => onSelected(color?.toARGB32()),
    );
  }
}
