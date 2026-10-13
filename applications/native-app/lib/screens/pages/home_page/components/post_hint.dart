import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// ホームの書き込みバー（PostButton）に重ねる、鉛筆で書き込んだような説明。
/// ペンを丸で囲んで「日記はここ！」、入力欄の上に括弧をかけて「いまをひとことシェア」と書く。
/// バーと同じ大きさに置き、はみ出してバーの上の余白に描く。タップは下に通す。
/// 文字は Yomogi を使う文字だけに絞って入れているので、文言を変えたら
/// assets/fonts/Yomogi-Hint.ttf も作り直す。
class PostHint extends StatelessWidget {
  const PostHint({super.key, required this.showPost, required this.showDiary});

  /// 入力欄の説明を出すか。
  final bool showPost;

  /// ペンの説明を出すか。
  final bool showDiary;

  static const _duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.textPrimary;

    return IgnorePointer(
      child: ExcludeSemantics(
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            AnimatedOpacity(
              opacity: showPost ? 1 : 0,
              duration: _duration,
              child: CustomPaint(painter: _PostHintPainter(color)),
            ),
            AnimatedOpacity(
              opacity: showDiary ? 1 : 0,
              duration: _duration,
              child: CustomPaint(painter: _DiaryHintPainter(color)),
            ),
          ],
        ),
      ),
    );
  }
}

// PostButton の並びに合わせた位置。左右 20、上 8 の余白に、高さ 48 の入力欄と
// 48 角のペンを 8 あけて並べている。
const _barPadding = 20.0;
const _barTop = 8.0;
const _buttonSize = 48.0;
const _buttonGap = 8.0;

Rect _penRect(Size size) => Rect.fromLTWH(
  size.width - _barPadding - _buttonSize,
  _barTop,
  _buttonSize,
  _buttonSize,
);

Rect _inputRect(Size size) => Rect.fromLTRB(
  _barPadding,
  _barTop,
  size.width - _barPadding - _buttonSize - _buttonGap,
  _barTop + _buttonSize,
);

/// 鉛筆で引いた線。少しずらして2回なぞり、濃さにむらを出す。
void _drawPencilLine(Canvas canvas, Path path, Color color) {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  canvas.drawPath(
    path,
    paint
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1.7,
  );
  canvas.drawPath(
    path.shift(const Offset(0.6, 0.4)),
    paint
      ..color = color.withValues(alpha: 0.4)
      ..strokeWidth = 1.1,
  );
}

/// 鉛筆で書いた文字。[baseline] の位置を左下にして、[angle] だけ傾けて書く。
void _drawPencilText(
  Canvas canvas,
  String text,
  Offset baseline,
  Color color, {
  required double fontSize,
  double angle = 0,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'YomogiHint',
        fontSize: fontSize,
        color: color.withValues(alpha: 0.72),
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final ascent = painter.computeDistanceToActualBaseline(
    TextBaseline.alphabetic,
  );
  canvas
    ..save()
    ..translate(baseline.dx, baseline.dy)
    ..rotate(angle);
  painter.paint(canvas, Offset(0, -ascent));
  canvas.restore();
  painter.dispose();
}

/// 入力欄の上に括弧をかけ、その上に「いまをひとことシェア」と書く。
class _PostHintPainter extends CustomPainter {
  const _PostHintPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final input = _inputRect(size);
    final top = input.top - 8;
    final bracket = Path()
      ..moveTo(input.left + 2, top)
      ..cubicTo(
        input.left + 2,
        top - 6,
        input.left + 6,
        top - 8,
        input.left + 14,
        top - 8,
      )
      ..lineTo(input.right - 14, top - 9)
      ..cubicTo(
        input.right - 6,
        top - 9,
        input.right - 4,
        top - 6,
        input.right - 4,
        top,
      );
    _drawPencilLine(canvas, bracket, color);
    _drawPencilText(
      canvas,
      'いまをひとことシェア',
      Offset(input.left + 18, top - 18),
      color,
      fontSize: 16,
    );
  }

  @override
  bool shouldRepaint(_PostHintPainter oldDelegate) => color != oldDelegate.color;
}

/// ペンをぐるっと丸で囲み、左上に「日記はここ！」と書いて線でつなぐ。
class _DiaryHintPainter extends CustomPainter {
  const _DiaryHintPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = _penRect(size).center;
    // ペンの中心からの位置。一筆で囲み、書き終わりを少し重ねる。
    Offset p(double dx, double dy) => c + Offset(dx, dy) * 1.05;
    Path curve(List<Offset> points) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i += 3) {
        path.cubicTo(
          points[i].dx,
          points[i].dy,
          points[i + 1].dx,
          points[i + 1].dy,
          points[i + 2].dx,
          points[i + 2].dy,
        );
      }
      return path;
    }

    final circle = curve([
      p(29, -11),
      p(39, 14), p(20, 39), p(-1, 37),
      p(-26, 35), p(-32, 6), p(-22, -13),
      p(-11, -33), p(22, -33), p(34, -14),
      p(37, -7), p(36, -2), p(33, 3),
    ]);
    _drawPencilLine(canvas, circle, color);

    final line = curve([p(-16, -51), p(-10, -45), p(-6, -40), p(-4, -34)]);
    _drawPencilLine(canvas, line, color);

    _drawPencilText(
      canvas,
      '日記はここ！',
      p(-80, -60),
      color,
      fontSize: 18,
      angle: -5 * math.pi / 180,
    );
  }

  @override
  bool shouldRepaint(_DiaryHintPainter oldDelegate) =>
      color != oldDelegate.color;
}
