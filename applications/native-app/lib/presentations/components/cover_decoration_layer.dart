import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domains/diary_book/cover_decoration.dart';

/// 文字の貼ったものを組むときの文字の大きさ。出すときは [CoverSticker.size] の幅に伸び縮みさせる。
const coverTextBaseSize = 40.0;

/// 文字の貼ったものの行の高さ。飾りのない表紙の名前と同じ。
const coverTextHeight = 1.3;

/// 表紙の文字の形。飾りのない表紙の名前と同じ太字で、[coverTextBaseSize] の大きさで組む。
const coverTextStyle = TextStyle(
  fontSize: coverTextBaseSize,
  fontWeight: FontWeight.w700,
  height: coverTextHeight,
);

/// [coverTextStyle] で組んだときの [text] の幅。
double coverTextWidth(String text) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: coverTextStyle),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.noScaling,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return max(width, 1);
}

/// 文字を [from] から [to] に変えても、文字の大きさが変わらないよう幅を変えた [sticker]。
CoverSticker resizedCoverText(CoverSticker sticker, String from, String to) {
  final ratio = coverTextWidth(to) / coverTextWidth(from);
  return sticker.copyWith(size: sticker.size * ratio).clamped();
}

/// 名前を [from] から [to] に変えても、表紙の名前の文字の大きさが変わらないよう幅を変えた飾り。
/// 名前を貼っていなければ [decoration] のまま。
CoverDecoration? renamedCoverDecoration(
  CoverDecoration? decoration,
  String from,
  String to,
) {
  if (decoration == null || !decoration.hasName) return decoration;
  return decoration.copyWith(
    stickers: [
      for (final sticker in decoration.stickers)
        sticker.isName ? resizedCoverText(sticker, from, to) : sticker,
    ],
  );
}

/// 色を決めていない表紙の文字の色。ふちがあれば地が白なので黒にし、なければ表紙に合わせた [inkColor]。
Color coverTextInk(Color inkColor, {required bool frame}) {
  return frame ? const Color(0xFF1D1D1F) : inkColor;
}

/// 表紙の飾りをすべて出す。貼ったものを貼った順に重ね、その上にらくがきを描く。
/// 触っても何もしない。
class CoverDecorationLayer extends StatelessWidget {
  const CoverDecorationLayer({
    super.key,
    required this.decoration,
    required this.coverWidth,
    required this.name,
    required this.inkColor,
  });

  final CoverDecoration decoration;
  final double coverWidth;

  /// 日記帳の名前。名前の貼ったものに出す。
  final String name;

  /// 色を決めていない文字の色。表紙の色に合わせた黒か白。
  final Color inkColor;

  @override
  Widget build(BuildContext context) {
    // 飾りは変わらないことが多いので、表紙のほかの部分と別に描いておく。
    return RepaintBoundary(
      child: IgnorePointer(
        child: Stack(
          children: [
            for (final sticker in decoration.stickers)
              PlacedCoverSticker(
                sticker: sticker,
                coverWidth: coverWidth,
                child: CoverStickerView(
                  sticker: sticker,
                  coverWidth: coverWidth,
                  name: name,
                  inkColor: inkColor,
                ),
              ),
            if (decoration.strokes.isNotEmpty)
              Positioned.fill(
                child: CustomPaint(
                  painter: CoverStrokePainter(
                    strokes: decoration.strokes,
                    coverWidth: coverWidth,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// らくがきの線を描く。点の間は2次ベジェでなめらかにつなぐ。
class CoverStrokePainter extends CustomPainter {
  const CoverStrokePainter({required this.strokes, required this.coverWidth});

  final List<CoverStroke> strokes;
  final double coverWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // 点も太さも表紙の幅を 1 として持っているので、そのまま描けるよう伸ばす。
    canvas.scale(coverWidth);
    for (final stroke in strokes) {
      final points = stroke.points;
      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      if (points.length == 1) {
        canvas.drawCircle(points.first, stroke.width / 2, paint);
        continue;
      }
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length - 1; i++) {
        final middle = (points[i] + points[i + 1]) / 2;
        path.quadraticBezierTo(
          points[i].dx,
          points[i].dy,
          middle.dx,
          middle.dy,
        );
      }
      path.lineTo(points.last.dx, points.last.dy);
      canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    }
    canvas.restore();
  }

  // 飾りは変えるたびに新しいリストになるので、リストが替わったときだけ描き直す。
  @override
  bool shouldRepaint(CoverStrokePainter oldDelegate) {
    return !identical(strokes, oldDelegate.strokes) ||
        coverWidth != oldDelegate.coverWidth;
  }

  // 描いた線が、下にある絵文字を触る邪魔をしないようにする。
  @override
  bool hitTest(Offset position) {
    return false;
  }
}

/// [child] の中心を [sticker] の位置に合わせ、傾けて置く。[Stack] の中で使う。
class PlacedCoverSticker extends StatelessWidget {
  const PlacedCoverSticker({
    super.key,
    required this.sticker,
    required this.coverWidth,
    required this.child,
  });

  final CoverSticker sticker;
  final double coverWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: sticker.x * coverWidth,
      top: sticker.y * coverWidth,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Transform.rotate(angle: sticker.rotation, child: child),
      ),
    );
  }
}

/// 貼った絵文字・文字・名前の1つ。幅を [CoverSticker.size] にする。
class CoverStickerView extends StatelessWidget {
  const CoverStickerView({
    super.key,
    required this.sticker,
    required this.coverWidth,
    required this.name,
    required this.inkColor,
  });

  final CoverSticker sticker;
  final double coverWidth;

  /// 日記帳の名前。名前の貼ったものに出す。
  final String name;

  /// 色を決めていない文字の色。
  final Color inkColor;

  @override
  Widget build(BuildContext context) {
    return switch (sticker) {
      CoverSticker(:final emoji?) => _EmojiSticker(
        sticker: sticker,
        emoji: emoji,
        coverWidth: coverWidth,
      ),
      CoverSticker(:final text?) => _TextSticker(
        sticker: sticker,
        text: text,
        coverWidth: coverWidth,
        inkColor: inkColor,
      ),
      CoverSticker(isName: true) => _TextSticker(
        sticker: sticker,
        text: name,
        coverWidth: coverWidth,
        inkColor: inkColor,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// 貼った絵文字。
///
/// 絵文字は色の付いた画像の文字なので、線で縁取れない。白いふちは、
/// 絵文字を白一色に塗ったものを太らせて後ろに敷いて作る。影も同じように黒で作ってぼかす。
class _EmojiSticker extends StatelessWidget {
  const _EmojiSticker({
    required this.sticker,
    required this.emoji,
    required this.coverWidth,
  });

  final CoverSticker sticker;
  final String emoji;
  final double coverWidth;

  @override
  Widget build(BuildContext context) {
    final width = sticker.size * coverWidth;
    // ふちや影の太さは表紙の大きさに合わせる。
    final unit = coverWidth / 100;
    final frameWidth = max(1.0, unit * 0.9);
    final text = Text(
      emoji,
      textAlign: TextAlign.center,
      // 表紙の大きさは変わらないので、文字サイズ設定は効かせない。
      textScaler: TextScaler.noScaling,
      style: TextStyle(fontSize: width * 0.82, height: 1),
    );

    if (!sticker.frame) {
      return SizedBox(width: width, child: text);
    }

    final dilate = ui.ImageFilter.dilate(
      radiusX: frameWidth,
      radiusY: frameWidth,
    );
    return SizedBox(
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, unit * 0.5),
            child: _Silhouette(
              color: Colors.black.withValues(alpha: 0.3),
              filter: ui.ImageFilter.compose(
                outer: ui.ImageFilter.blur(sigmaX: unit, sigmaY: unit),
                inner: dilate,
              ),
              child: text,
            ),
          ),
          _Silhouette(color: Colors.white, filter: dilate, child: text),
          text,
        ],
      ),
    );
  }
}

/// 置いた文字か名前。[coverTextBaseSize] で組んだ文字を、幅が [CoverSticker.size] になるよう伸び縮みさせる。
class _TextSticker extends StatelessWidget {
  const _TextSticker({
    required this.sticker,
    required this.text,
    required this.coverWidth,
    required this.inkColor,
  });

  final CoverSticker sticker;
  final String text;
  final double coverWidth;
  final Color inkColor;

  @override
  Widget build(BuildContext context) {
    final color = sticker.color;

    return SizedBox(
      width: sticker.size * coverWidth,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: FramedCoverText(
          text,
          style: coverTextStyle.copyWith(
            color: color == null
                ? coverTextInk(inkColor, frame: sticker.frame)
                : Color(color),
          ),
          frame: sticker.frame,
        ),
      ),
    );
  }
}

/// 表紙の文字。[frame] なら、同じ文字を白い太い線でなぞったものを後ろに敷いて白いふちにする。
/// ふちの太さは文字の大きさに合わせる。
class FramedCoverText extends StatelessWidget {
  const FramedCoverText(
    this.text, {
    super.key,
    required this.style,
    required this.frame,
    this.maxLines,
  });

  final String text;

  /// 文字の形。大きさ（fontSize）と色を決めておく。
  final TextStyle style;
  final bool frame;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final overflow = maxLines == null
        ? TextOverflow.clip
        : TextOverflow.ellipsis;
    final fill = Text(
      text,
      textAlign: TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      // 表紙の大きさは変わらないので、文字サイズ設定は効かせない。
      textScaler: TextScaler.noScaling,
      style: style,
    );
    if (!frame) return fill;

    final fontSize = style.fontSize ?? 14;
    return Stack(
      children: [
        // ふちは上の文字と同じ形で組むよう、まわりの文字の形に重ねる。
        // 同じ文字を2回探したり読み上げたりしないよう、Text ではなく RichText にして読み上げも外す。
        ExcludeSemantics(
          child: RichText(
            text: TextSpan(
              text: text,
              style: DefaultTextStyle.of(context).style.merge(
                style.copyWith(
                  color: null,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = fontSize * 0.24
                    ..strokeJoin = StrokeJoin.round
                    ..color = Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.28),
                      blurRadius: fontSize * 0.12,
                      offset: Offset(0, fontSize * 0.04),
                    ),
                  ],
                ),
              ),
            ),
            textAlign: TextAlign.center,
            maxLines: maxLines,
            overflow: overflow,
            textScaler: TextScaler.noScaling,
          ),
        ),
        fill,
      ],
    );
  }
}

/// [child] を [color] 一色に塗り、[filter] をかける。
class _Silhouette extends StatelessWidget {
  const _Silhouette({
    required this.color,
    required this.filter,
    required this.child,
  });

  final Color color;
  final ui.ImageFilter filter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: filter,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: child,
      ),
    );
  }
}
