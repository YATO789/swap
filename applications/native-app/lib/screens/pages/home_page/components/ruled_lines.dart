import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// [child]（複数行の入力欄）の下に、行に合わせた罫線を敷く。
/// 線は [lineHeight] ごとに [lineCount] 本、下へいくほど薄くして引く。
/// 文字は行の真ん中あたりに来て線から浮いて見えるので、[textOffset] だけ下げて線に寄せる。
class RuledLines extends StatelessWidget {
  const RuledLines({
    super.key,
    required this.lineHeight,
    required this.lineCount,
    this.textOffset = 6,
    required this.child,
  });

  final double lineHeight;
  final int lineCount;
  final double textOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _FadingLinesPainter(
                color: context.appColors.border,
                lineHeight: lineHeight,
                lineCount: lineCount,
              ),
            ),
          ),
        ),
        // 線の位置は変えず、文字だけを下げる。
        Padding(
          padding: EdgeInsets.only(top: textOffset),
          child: child,
        ),
      ],
    );
  }
}

class _FadingLinesPainter extends CustomPainter {
  const _FadingLinesPainter({
    required this.color,
    required this.lineHeight,
    required this.lineCount,
  });

  final Color color;
  final double lineHeight;
  final int lineCount;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;
    for (var i = 0; i < lineCount; i++) {
      final y = lineHeight * (i + 1);
      if (y > size.height) break;
      final fade = i / lineCount;
      paint.color = color.withValues(alpha: color.a * (1 - fade));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_FadingLinesPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.lineHeight != lineHeight ||
      oldDelegate.lineCount != lineCount;
}
