import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';

/// ホームの日記帳の並べ方を、1冊ずつと横2列のグリッドの見本を並べて選ばせる。
class DiaryBookLayoutPicker extends StatelessWidget {
  const DiaryBookLayoutPicker({
    super.key,
    required this.paged,
    required this.onChanged,
  });

  /// 1冊ずつを選んでいるか。false ならグリッド。
  final bool paged;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          // 最初に選ばれている1冊ずつを左に置く。
          Expanded(
            child: _Option(
              label: context.l10n.layoutPaged,
              selected: paged,
              onTap: () => onChanged(true),
              preview: const _PagedPreview(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Option(
              label: context.l10n.layoutGrid,
              selected: !paged,
              onTap: () => onChanged(false),
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
              width: double.infinity,
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
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected
                          ? colors.textPrimary
                          : colors.textSecondary,
                    ),
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

/// 表紙が横に2冊並ぶ見本。
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

/// 大きな表紙が1冊だけあり、下に次の表紙が少しのぞく見本。
class _PagedPreview extends StatelessWidget {
  const _PagedPreview();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: _Block(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: 4),
        _Block(width: 40, height: 4, color: colors.placeholder),
      ],
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
