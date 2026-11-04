import 'package:flutter/material.dart';

import '../../../../domains/diary_book/cover_decoration.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';

/// 日記帳の一覧の最後に置く、日記帳の形をした追加ボタン。
///
/// 表紙と同じ大きさと形にし、点線のふちで「まだない1冊」に見せる。
class AddDiaryBookCover extends StatelessWidget {
  const AddDiaryBookCover({
    super.key,
    required this.width,
    required this.onPressed,
  });

  /// 表紙の幅。高さはその 4/3 にし、中の印や文字もこれに合わせて大きくする。
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final label = context.l10n.homeAddDiaryBook;
    // 表紙（DiaryCover）と同じく、幅 168 のときの大きさを基準に伸ばす。
    final k = width / 168;
    final radius = BorderRadius.horizontal(
      left: const Radius.circular(2),
      right: Radius.circular(6 * k),
    );

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: CustomPaint(
          foregroundPainter: _DashedBookPainter(
            color: colors.border,
            radius: radius,
            strokeWidth: 1.5,
          ),
          child: Container(
            width: width,
            height: width * coverHeightRatio,
            decoration: BoxDecoration(
              color: colors.placeholder.withValues(alpha: 0.5),
              borderRadius: radius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 36 * k, color: colors.textSecondary),
                SizedBox(height: 8 * k),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14 * k,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 本の形の点線のふちを描く。
class _DashedBookPainter extends CustomPainter {
  const _DashedBookPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  final Color color;
  final BorderRadius radius;
  final double strokeWidth;

  static const _dash = 6.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final inset = strokeWidth / 2;
    final outline = Path()
      ..addRRect(
        radius.toRRect(
          Rect.fromLTWH(
            inset,
            inset,
            size.width - strokeWidth,
            size.height - strokeWidth,
          ),
        ),
      );
    canvas.drawPath(_dashed(outline), paint);
  }

  Path _dashed(Path source) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        dashed.addPath(
          metric.extractPath(distance, distance + _dash),
          Offset.zero,
        );
        distance += _dash + _gap;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(_DashedBookPainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
