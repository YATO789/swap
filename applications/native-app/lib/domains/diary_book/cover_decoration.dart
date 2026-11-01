import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/cover_decoration.freezed.dart';

/// このアプリが読み書きできる飾りの形の番号。これより大きい飾りは表示だけして、編集させない。
///
/// 2 から、名前を貼ったものの1つ（[CoverSticker.isName]）として持つ。
/// 1 の飾りでは、名前は前のように表紙の上のほうに決まった形で出す。
const coverDecorationVersion = 2;

/// 表紙の高さ（表紙の幅を 1 とした割合）。
const coverHeightRatio = 4 / 3;

/// 表紙に貼れるもの（絵文字・文字・名前）の数。
const maxCoverStickers = 20;

/// 表紙に置ける文字の数（名前は数えない）。
const maxCoverTexts = 10;

/// 表紙に置く文字1つの長さの上限。
const maxCoverTextLength = 30;

/// 表紙に置く文字1つの行の数の上限。
const maxCoverTextLines = 3;

/// 貼ったものの幅の下限と上限（表紙の幅との割合）。
const minCoverStickerSize = 0.08;
const maxCoverStickerSize = 1.2;

/// 表紙に描けるらくがきの線の数。
const maxCoverStrokes = 200;

/// らくがきの点の数の、全部の線を合わせた上限。DB の 64KB の制約に余裕を持って入る数にする。
/// 絵文字 20 個・線 200 本・1000 点で 49.6KB（ローカルの DB の pg_column_size で測った）。
/// 1点がおよそ 32 バイトなので、1500 点だと 64KB を超えることがある。
const maxCoverStrokePoints = 1000;

/// らくがきの線の太さの下限と上限（表紙の幅との割合）。
const minCoverStrokeWidth = 0.004;
const maxCoverStrokeWidth = 0.1;

/// 線を間引くときに、もとの線からずれてよい距離（表紙の幅との割合）。
const _simplifyTolerance = 0.002;

/// 日記帳の表紙の飾り。
///
/// 位置と大きさは表紙の幅を 1 とした割合で持つ（y は 0〜[coverHeightRatio]）。
/// どの大きさの表紙に出しても同じ並びになる。
@freezed
abstract class CoverDecoration with _$CoverDecoration {
  const factory CoverDecoration({
    /// 飾りの形の番号。[coverDecorationVersion] より大きければ、新しいアプリで飾ったもの。
    @Default(coverDecorationVersion) int version,

    /// 貼ったもの。後ろほど上に重なる。
    @Default(<CoverSticker>[]) List<CoverSticker> stickers,

    /// らくがきの線。描いた順に重ね、貼ったものすべての上に出す。
    @Default(<CoverStroke>[]) List<CoverStroke> strokes,
  }) = _CoverDecoration;

  const CoverDecoration._();

  /// 何も貼っておらず、らくがきもしていないか。
  bool get isEmpty {
    return stickers.isEmpty && strokes.isEmpty;
  }

  /// このアプリで編集できるか。新しいアプリで飾ったものは、知らない飾りを消さないよう編集させない。
  bool get isEditable {
    return version <= coverDecorationVersion;
  }

  /// 名前を貼ったものの1つとして置いているか。
  ///
  /// false（v1）なら、名前は前のように表紙の上のほうに決まった形で出す。
  /// true なら、名前を貼ったものから外せば表紙に名前は出ない。
  bool get placesName {
    return version >= 2;
  }

  /// 名前を貼っているか。
  bool get hasName {
    return stickers.any((sticker) => sticker.isName);
  }

  /// 置いた文字の数（名前は数えない）。
  int get textCount {
    return stickers.where((sticker) => sticker.text != null).length;
  }

  /// 全部の線の点の数。
  int get pointCount {
    var count = 0;
    for (final stroke in strokes) {
      count += stroke.points.length;
    }
    return count;
  }

  /// まだ描ける点の数。
  int get remainingPoints {
    return maxCoverStrokePoints - pointCount;
  }

  /// まだ何か貼れるか。
  bool get canAddSticker {
    return stickers.length < maxCoverStickers;
  }

  /// まだ文字を置けるか。
  bool get canAddText {
    return canAddSticker && textCount < maxCoverTexts;
  }

  /// まだ線を描き始められるか。
  bool get canAddStroke {
    return strokes.length < maxCoverStrokes && remainingPoints > 0;
  }

  /// [sticker] を一番上に貼る。貼れる数や置ける文字の数を超えるとき、
  /// もう名前を貼っているのに名前を貼ろうとしたときは何もしない。
  CoverDecoration addSticker(CoverSticker sticker) {
    if (!canAddSticker ||
        (sticker.text != null && !canAddText) ||
        (sticker.isName && hasName)) {
      return this;
    }
    return copyWith(stickers: [...stickers, sticker.clamped()]);
  }

  /// [index] の貼ったものを [sticker] にする。表紙の外へは出さず、大きさも上限と下限におさめる。
  CoverDecoration replaceSticker(int index, CoverSticker sticker) {
    return copyWith(
      stickers: [
        for (var i = 0; i < stickers.length; i++)
          i == index ? sticker.clamped() : stickers[i],
      ],
    );
  }

  /// [index] の貼ったものをはがす。
  CoverDecoration removeSticker(int index) {
    return copyWith(stickers: [...stickers]..removeAt(index));
  }

  /// [from] の貼ったものを重なりの [to] へ移す。範囲の外なら何もしない。
  CoverDecoration moveSticker(int from, int to) {
    if (to < 0 || to >= stickers.length) {
      return this;
    }
    final moved = [...stickers];
    moved.insert(to, moved.removeAt(from));
    return copyWith(stickers: moved);
  }

  /// 描き終えた [stroke] を間引いて足す。描ける線の数や点の数を超えるぶんは足さない。
  CoverDecoration addStroke(CoverStroke stroke) {
    if (!canAddStroke || stroke.points.isEmpty) {
      return this;
    }
    final simplified = stroke.simplified();
    final points = simplified.points.length > remainingPoints
        ? simplified.points.sublist(0, remainingPoints)
        : simplified.points;
    return copyWith(
      strokes: [
        ...strokes,
        simplified.copyWith(points: points),
      ],
    );
  }

  /// [point] から [reach] より近くを通る線を、1本まるごと消す。
  CoverDecoration eraseStrokesAt(Offset point, {required double reach}) {
    final kept = [
      for (final stroke in strokes)
        if (!stroke.touches(point, reach: reach)) stroke,
    ];
    if (kept.length == strokes.length) {
      return this;
    }
    return copyWith(strokes: kept);
  }
}

/// 表紙に貼った絵文字・文字・名前の1つ。
///
/// 絵文字は [emoji]、文字は [text] を持ち、名前は [isName] にする。どれか1つだけにする。
/// 名前は中身を持たず、日記帳の名前をそのまま出す（名前を変えると表紙の文字も変わる）。
@freezed
abstract class CoverSticker with _$CoverSticker {
  const factory CoverSticker({
    /// 絵文字。絵文字でなければ null。
    String? emoji,

    /// 置いた文字。文字でなければ null。改行で何行かにできる。
    String? text,

    /// 日記帳の名前か。
    @Default(false) bool isName,

    /// 中心の位置。
    required double x,
    required double y,

    /// 幅（白いふちを含む）。
    required double size,

    /// 回転（ラジアン、時計回り）。
    @Default(0) double rotation,

    /// 白いふちを付けるか。
    @Default(true) bool frame,

    /// 文字と名前の色（0xAARRGGBB）。null なら表紙の色に合わせて黒か白にする。絵文字では使わない。
    int? color,
  }) = _CoverSticker;

  const CoverSticker._();

  /// 文字か名前か。色を変えられる。
  bool get isText {
    return text != null || isName;
  }

  /// 中心を表紙の中に、大きさを上限と下限の間におさめたもの。
  CoverSticker clamped() {
    return copyWith(
      x: x.clamp(0.0, 1.0),
      y: y.clamp(0.0, coverHeightRatio),
      size: size.clamp(minCoverStickerSize, maxCoverStickerSize),
    );
  }
}

/// らくがきの線1本。
@freezed
abstract class CoverStroke with _$CoverStroke {
  const factory CoverStroke({
    /// 線の色（0xAARRGGBB）。
    required int color,

    /// 線の太さ。
    required double width,

    /// 線が通る点。
    required List<Offset> points,
  }) = _CoverStroke;

  const CoverStroke._();

  /// [point] から、線の太さの半分に [reach] を足した距離より近くを通るか。
  /// 間引いた線は点と点のあいだが離れているので、点ではなく点をつないだ線分との距離で見る。
  bool touches(Offset point, {required double reach}) {
    final limit = width / 2 + reach;
    if (points.length == 1) {
      return (points.first - point).distance < limit;
    }
    for (var i = 1; i < points.length; i++) {
      if (_distanceToSegment(point, points[i - 1], points[i]) < limit) {
        return true;
      }
    }
    return false;
  }

  /// 見た目がほぼ変わらない範囲で点を減らしたもの（Ramer–Douglas–Peucker 法）。
  CoverStroke simplified() {
    if (points.length <= 2) {
      return this;
    }
    final keep = List<bool>.filled(points.length, false);
    keep[0] = true;
    keep[points.length - 1] = true;
    _markKept(points, 0, points.length - 1, keep);
    return copyWith(
      points: [
        for (var i = 0; i < points.length; i++)
          if (keep[i]) points[i],
      ],
    );
  }
}

/// [first] と [last] を結ぶ線から一番離れた点が許す距離より遠ければ、その点を残して左右を同じように調べる。
void _markKept(List<Offset> points, int first, int last, List<bool> keep) {
  if (last - first < 2) {
    return;
  }
  var farthest = first;
  var maxDistance = 0.0;
  for (var i = first + 1; i < last; i++) {
    final distance = _distanceToSegment(points[i], points[first], points[last]);
    if (distance > maxDistance) {
      maxDistance = distance;
      farthest = i;
    }
  }
  if (maxDistance <= _simplifyTolerance) {
    return;
  }
  keep[farthest] = true;
  _markKept(points, first, farthest, keep);
  _markKept(points, farthest, last, keep);
}

/// [point] から、[start] と [end] を結ぶ線分までの距離。
double _distanceToSegment(Offset point, Offset start, Offset end) {
  final segment = end - start;
  final lengthSquared = segment.distanceSquared;
  if (lengthSquared == 0) {
    return (point - start).distance;
  }
  final toPoint = point - start;
  final t =
      ((toPoint.dx * segment.dx + toPoint.dy * segment.dy) / lengthSquared)
          .clamp(0.0, 1.0);
  return (point - (start + segment * t)).distance;
}
