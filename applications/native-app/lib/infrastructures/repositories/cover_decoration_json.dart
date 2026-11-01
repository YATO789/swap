import 'dart:ui';

import 'package:swap/domains/diary_book/cover_decoration.dart';

/// diary_books.cover_decoration の JSON を飾りにする。
///
/// メンバーなら API から好きな値を書けるので、形の違うところは飛ばして、読めたものだけを返す。
/// 全体が読めないときや、v1 で何も飾っていないときは null。
/// v2 からは何もなくても返す（名前を表紙から外したことを表す）。
/// 新しいアプリで飾ったもの（`v` が大きい）は、読めたものが何もなくても編集させないために返す。
CoverDecoration? coverDecorationFromJson(Object? json) {
  if (json is! Map<String, dynamic>) {
    return null;
  }
  final version = _asInt(json['v']) ?? 1;
  final stickers = _takeStickers([
    for (final item in _asList(json['stickers'])) ?_stickerFromJson(item),
  ], placesName: version >= 2);
  final strokes = <CoverStroke>[
    for (final item in _asList(json['strokes'])) ?_strokeFromJson(item),
  ];
  final decoration = CoverDecoration(
    version: version,
    stickers: stickers,
    strokes: _takeStrokes(strokes),
  );
  if (decoration.isEmpty && !decoration.placesName) {
    return null;
  }
  return decoration;
}

/// 飾りを diary_books.cover_decoration に書く JSON にする。
/// 飾りがないときと、v1 で何も飾っていないときは null。
Map<String, dynamic>? coverDecorationToJson(CoverDecoration? decoration) {
  if (decoration == null || (decoration.isEmpty && !decoration.placesName)) {
    return null;
  }
  return {
    'v': decoration.version,
    'stickers': [
      for (final sticker in decoration.stickers)
        {
          if (sticker.emoji case final emoji?) ...{
            'type': 'emoji',
            'char': emoji,
          } else if (sticker.text case final text?) ...{
            'type': 'text',
            'text': text,
          } else
            'type': 'name',
          'x': _round(sticker.x),
          'y': _round(sticker.y),
          'size': _round(sticker.size),
          'rot': _round(sticker.rotation),
          'frame': sticker.frame,
          if (sticker.isText) 'color': ?sticker.color,
        },
    ],
    'strokes': [
      for (final stroke in decoration.strokes)
        {
          'color': stroke.color,
          'width': _round(stroke.width),
          'points': [
            for (final point in stroke.points)
              [_round(point.dx), _round(point.dy)],
          ],
        },
    ],
  };
}

/// 絵文字・文字・名前を読む。知らない種類（新しいアプリの写真など）は飛ばす。
CoverSticker? _stickerFromJson(Object? json) {
  if (json is! Map<String, dynamic>) {
    return null;
  }
  final x = _asDouble(json['x']);
  final y = _asDouble(json['y']);
  final size = _asDouble(json['size']);
  if (x == null || y == null || size == null) {
    return null;
  }
  final frame = json['frame'];
  final sticker = CoverSticker(
    x: x,
    y: y,
    size: size,
    rotation: _asDouble(json['rot']) ?? 0,
    frame: frame is bool ? frame : true,
  );
  switch (json['type']) {
    case 'emoji':
      final emoji = json['char'];
      if (emoji is! String || emoji.isEmpty) {
        return null;
      }
      return sticker.copyWith(emoji: emoji).clamped();
    case 'text':
      final text = json['text'];
      if (text is! String || !_isValidText(text)) {
        return null;
      }
      return sticker
          .copyWith(text: text, color: _asColor(json['color']))
          .clamped();
    case 'name':
      return sticker
          .copyWith(isName: true, color: _asColor(json['color']))
          .clamped();
    default:
      return null;
  }
}

/// 空でなく、置ける長さと行の数におさまっている文字か。
bool _isValidText(String text) {
  return text.trim().isNotEmpty &&
      text.runes.length <= maxCoverTextLength &&
      '\n'.allMatches(text).length < maxCoverTextLines;
}

/// 貼れる数と置ける文字の数におさまるぶんだけ、前から取る。
/// 名前は1つだけにし、名前を貼ったものにする前の飾り（[placesName] が false）では取らない。
List<CoverSticker> _takeStickers(
  List<CoverSticker> stickers, {
  required bool placesName,
}) {
  final taken = <CoverSticker>[];
  var texts = 0;
  var hasName = false;
  for (final sticker in stickers) {
    if (taken.length >= maxCoverStickers) {
      break;
    }
    if (sticker.isName) {
      if (!placesName || hasName) {
        continue;
      }
      hasName = true;
    }
    if (sticker.text != null) {
      if (texts >= maxCoverTexts) {
        continue;
      }
      texts++;
    }
    taken.add(sticker);
  }
  return taken;
}

CoverStroke? _strokeFromJson(Object? json) {
  if (json is! Map<String, dynamic>) {
    return null;
  }
  final color = _asInt(json['color']);
  final width = _asDouble(json['width']);
  if (color == null || color < 0 || color > 0xFFFFFFFF || width == null) {
    return null;
  }
  final points = <Offset>[
    for (final item in _asList(json['points'])) ?_pointFromJson(item),
  ];
  if (points.isEmpty) {
    return null;
  }
  return CoverStroke(
    color: color,
    width: width.clamp(minCoverStrokeWidth, maxCoverStrokeWidth),
    points: points,
  );
}

Offset? _pointFromJson(Object? json) {
  if (json is! List<dynamic> || json.length != 2) {
    return null;
  }
  final x = _asDouble(json[0]);
  final y = _asDouble(json[1]);
  if (x == null || y == null) {
    return null;
  }
  return Offset(x.clamp(0.0, 1.0), y.clamp(0.0, coverHeightRatio));
}

/// 描ける線の数と点の数におさまるぶんだけ、前から取る。
List<CoverStroke> _takeStrokes(List<CoverStroke> strokes) {
  final taken = <CoverStroke>[];
  var points = 0;
  for (final stroke in strokes) {
    if (taken.length >= maxCoverStrokes ||
        points + stroke.points.length > maxCoverStrokePoints) {
      break;
    }
    taken.add(stroke);
    points += stroke.points.length;
  }
  return taken;
}

List<dynamic> _asList(Object? value) {
  return value is List<dynamic> ? value : const [];
}

int? _asInt(Object? value) {
  return value is int ? value : null;
}

/// 0xAARRGGBB の色だけを読む。
int? _asColor(Object? value) {
  final color = _asInt(value);
  if (color == null || color < 0 || color > 0xFFFFFFFF) {
    return null;
  }
  return color;
}

/// 有限の数だけを読む。
double? _asDouble(Object? value) {
  if (value is! num || !value.isFinite) {
    return null;
  }
  return value.toDouble();
}

/// 保存する数字を小数 3 桁に丸める。表紙の幅 1000 分の 1 まであれば見た目は変わらない。
double _round(double value) {
  return (value * 1000).round() / 1000;
}
