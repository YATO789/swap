import 'package:flutter/material.dart';

import '../../domains/diary_book/cover_decoration.dart';
import 'cover_decoration_layer.dart';
import 'diary_book_icon.dart';

/// 日記帳の表紙。
///
/// 下から 表紙の色 → 背表紙 → 貼ったもの → らくがき の順に重ねる。
/// 名前は飾りの貼ったものの1つとして、置いた場所に置いた形で出す（[CoverDecoration.placesName]）。
/// 飾りがないときや、名前を貼ったものにする前（v1）の飾りでは、名前を表紙の上のほうに
/// 白いふちを付けて入れ、飾りで隠れないよう一番上に出す。
class DiaryCover extends StatelessWidget {
  const DiaryCover({
    super.key,
    this.name = '',
    required this.color,
    required this.width,
    this.decoration,
    this.decorationLayer,
  });

  final String name;

  /// 表紙の色。null なら決まったグレー。
  final Color? color;

  /// 表紙の幅。高さはその 4/3 にし、中の文字や背表紙もこれに合わせて大きくする。
  final double width;

  /// 表紙の飾り。null なら飾りなし。
  final CoverDecoration? decoration;

  /// [decoration] の代わりに背表紙の上に置く層。
  /// 編集ページが、触って動かせる飾りを差し込むのに使う。名前もこの層で出す。
  final Widget? decorationLayer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coverColor = color ?? defaultCoverColor(context);
    final length = name.runes.length;
    // 長い名前でも表紙に収まるよう、文字数で大きさを変える。
    // 幅 168 のときの大きさを基準に、表紙の大きさに合わせて伸ばす。
    final k = width / 168;
    final fontSize = (length <= 6 ? 22.0 : (length <= 12 ? 19.0 : 16.0)) * k;
    final inkColor = coverInkColor(coverColor);
    final decoration = this.decoration;
    final decorationLayer =
        this.decorationLayer ??
        (decoration == null || decoration.isEmpty
            ? null
            : CoverDecorationLayer(
                decoration: decoration,
                coverWidth: width,
                name: name,
                inkColor: inkColor,
              ));
    final fixedName =
        this.decorationLayer == null && !(decoration?.placesName ?? false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: width,
      height: width * coverHeightRatio,
      // 表紙からはみ出した飾りは表紙の縁で切る。
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.horizontal(
          left: const Radius.circular(2),
          right: Radius.circular(6 * k),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.14),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 背表紙。光の当たる明るい帯と、折り目の暗い線で本らしく見せる。
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 14 * k,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(2),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.35, 0.75, 1],
                ),
              ),
            ),
          ),
          if (decorationLayer != null) Positioned.fill(child: decorationLayer),
          if (fixedName)
            IgnorePointer(
              child: Padding(
                padding: EdgeInsets.fromLTRB(28 * k, 40 * k, 16 * k, 16 * k),
                child: Align(
                  alignment: Alignment.topCenter,
                  // 名前を貼ったものにしたときと同じく、白いふちを付ける。
                  child: FramedCoverText(
                    name,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      height: coverTextHeight,
                      color: coverTextInk(inkColor, frame: true),
                    ),
                    frame: true,
                    maxLines: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
