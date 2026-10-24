import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// [text] を [width] の幅に [style] で書いたときの行数（折り返しも含む、空なら 0）と、
/// 実際の1行の高さ。罫線はこの高さごとに引くこと。
/// 文字の大きさ×行の高さの指定どおりにはならず（フォントによって少し高くなる）、
/// 指定の値で引くと下の行ほど文字と線がずれていく。
/// [style] と [strutStyle] は表示するウィジェットに実際にかかるものを渡すこと。
/// 表示側では [StrutStyle.forceStrutHeight] で行の高さを固定しておくとずれない
/// （日本語と英数字でフォントが混ざると、行ごとに高さが変わるため）。
({int count, double lineHeight}) measureTextLines(
  BuildContext context, {
  required String text,
  required TextStyle style,
  StrutStyle? strutStyle,
  required double width,
}) {
  final painter = TextPainter(
    // 空でも1行の高さは測りたいので、空白1文字で測る。
    text: TextSpan(text: text.isEmpty ? ' ' : text, style: style),
    strutStyle: strutStyle,
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout(maxWidth: width);
  final lines = painter.computeLineMetrics().length;
  final lineHeight = painter.height / lines;
  painter.dispose();
  return (count: text.isEmpty ? 0 : lines, lineHeight: lineHeight);
}

/// [child]（複数行の入力欄）の下に、行に合わせた罫線を敷く。
/// 線は [lineHeight] ごとに引く。書いた [filledLines] 行ぶんは濃いまま引き、
/// その下に [lineCount] 本、下へいくほど薄くして足す。
/// 文字は行の真ん中あたりに来て線から浮いて見えるので、[textOffset] だけ下げて線に寄せる。
class RuledLines extends StatelessWidget {
  const RuledLines({
    super.key,
    required this.lineHeight,
    required this.lineCount,
    this.filledLines = 0,
    this.textOffset = 6,
    required this.child,
  });

  final double lineHeight;
  final int lineCount;
  final int filledLines;
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
                filledLines: filledLines,
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
    required this.filledLines,
  });

  final Color color;
  final double lineHeight;
  final int lineCount;
  final int filledLines;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;
    for (var i = 0; i < filledLines + lineCount; i++) {
      final y = lineHeight * (i + 1);
      if (y > size.height) break;
      final fade = i < filledLines ? 0 : (i - filledLines) / lineCount;
      paint.color = color.withValues(alpha: color.a * (1 - fade));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_FadingLinesPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.lineHeight != lineHeight ||
      oldDelegate.lineCount != lineCount ||
      oldDelegate.filledLines != filledLines;
}
