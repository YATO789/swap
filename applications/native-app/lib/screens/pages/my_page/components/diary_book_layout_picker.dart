import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// ホームの日記帳の並べ方を、リストと表紙のグリッドの見本を並べて選ばせる。
class DiaryBookLayoutPicker extends StatelessWidget {
  const DiaryBookLayoutPicker({
    super.key,
    required this.grid,
    required this.onChanged,
  });

  /// 表紙のグリッドを選んでいるか。false ならリスト。
  final bool grid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          Expanded(
            child: _Option(
              label: 'リスト',
              selected: !grid,
              onTap: () => onChanged(false),
              preview: const _ListPreview(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Option(
              label: '表紙',
              selected: grid,
              onTap: () => onChanged(true),
              preview: const _GridPreview(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.preview,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 96,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? colors.textPrimary : colors.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: preview,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: selected ? colors.textPrimary : colors.disabled,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: selected ? colors.textPrimary : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 小さな表紙のアイコンと名前の行が縦に並ぶ見本。
class _ListPreview extends StatelessWidget {
  const _ListPreview();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            children: [
              // 日記帳のアイコンと同じく 3:4。
              _Block(width: 12, height: 16, color: colors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: _Block(height: 6, color: colors.placeholder),
              ),
            ],
          ),
      ],
    );
  }
}

/// 大きな表紙が横に2冊並ぶ見本。
class _GridPreview extends StatelessWidget {
  const _GridPreview();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // 表紙と同じく、幅:高さを 3:4 にする。
    final cover = AspectRatio(
      aspectRatio: 3 / 4,
      child: _Block(color: colors.textSecondary),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [cover, const SizedBox(width: 10), cover],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({this.width, this.height, required this.color});

  final double? width;
  final double? height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
