import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// ホームの書き込みバー（PostButton）に重ねる、鉛筆で書き込んだような説明。
/// ペンを丸で囲んで「日記はここ！」、入力欄の上に「いまをひとことシェア」と書いて矢印で指す。
/// バーと同じ大きさに置き、はみ出してバーの上の余白に描く。タップは下に通す。
/// 文字は Yomogi を使う文字だけに絞って入れているので、文言を変えたら
/// assets/fonts/Yomogi-Hint.ttf も作り直す。
class PostHint extends StatelessWidget {
  const PostHint({super.key, required this.visible});

  /// 説明を出すか。
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.textPrimary;

    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              CustomPaint(painter: _PostHintPainter(color)),
              CustomPaint(painter: _DiaryHintPainter(color)),
            ],
          ),
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
/// 文字より目立たないよう、文字より薄く引く。
void _drawPencilLine(Canvas canvas, Path path, Color color) {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  canvas.drawPath(
    path,
    paint
      ..color = color.withValues(alpha: 0.33)
      ..strokeWidth = 1.7,
  );
  canvas.drawPath(
    path.shift(const Offset(0.6, 0.4)),
    paint
      ..color = color.withValues(alpha: 0.24)
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

/// 入力欄の上に「いまをひとことシェア」と書き、その右端から入力欄へ矢印を下ろす。
class _PostHintPainter extends CustomPainter {
  const _PostHintPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final input = _inputRect(size);
    Offset p(double dx, double dy) => input.topLeft + Offset(dx, dy);

    _drawPencilText(canvas, 'いまをひとことシェア', p(18, -26), color, fontSize: 16);

    // 文字の右から少しふくらませて、入力欄の上の縁へ下ろす。
    final control = p(213, -20);
    final tip = p(208, -3);
    final shaft = Path()
      ..moveTo(p(184, -33).dx, p(184, -33).dy)
      ..cubicTo(
        p(204, -37).dx,
        p(204, -37).dy,
        control.dx,
        control.dy,
        tip.dx,
        tip.dy,
      );
    _drawPencilLine(canvas, shaft, color);

    // 矢じり。線の向きから左右に開いた短い線を引く。
    final direction = (tip - control).direction;
    final head = Path();
    for (final spread in const [-0.5, 0.5]) {
      final back = Offset.fromDirection(direction + math.pi + spread, 8);
      head
        ..moveTo(tip.dx + back.dx, tip.dy + back.dy)
        ..lineTo(tip.dx, tip.dy);
    }
    _drawPencilLine(canvas, head, color);
  }

  @override
  bool shouldRepaint(_PostHintPainter oldDelegate) =>
      color != oldDelegate.color;
}

/// ペンをぐるっと丸で囲み、左上に「日記はここ！」と書いて線でつなぐ。
class _DiaryHintPainter extends CustomPainter {
  const _DiaryHintPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = _penRect(size).center;
    // ペンの中心からの位置。一筆で囲み、書き終わりを少し重ねる。
    Offset p(double dx, double dy) => c + Offset(dx, dy) * 0.95;
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
      p(39, 14),
      p(20, 39),
      p(-1, 37),
      // 左上はボタンの角に近いので、角にかからないよう外へふくらませる。
      p(-30, 33),
      p(-36, 6),
      p(-29, -17),
      p(-24, -38),
      p(22, -36),
      p(34, -14),
      p(37, -7),
      p(36, -2),
      p(33, 3),
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
