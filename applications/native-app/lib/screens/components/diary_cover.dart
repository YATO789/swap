import 'package:flutter/material.dart';

import 'diary_book_icon.dart';

/// 日記帳の表紙。名前があれば表紙の上のほうに [coverInkColor] で入れる。
class DiaryCover extends StatelessWidget {
  const DiaryCover({
    super.key,
    this.name = '',
    required this.color,
    required this.width,
  });

  final String name;

  /// 表紙の色。null なら決まったグレー。
  final Color? color;

  /// 表紙の幅。高さはその 4/3 にし、中の文字や背表紙もこれに合わせて大きくする。
  final double width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coverColor = color ?? defaultCoverColor(context);
    final length = name.runes.length;
    // 長い名前でも表紙に収まるよう、文字数で大きさを変える。
    // 幅 168 のときの大きさを基準に、表紙の大きさに合わせて伸ばす。
    final k = width / 168;
    final fontSize = (length <= 6 ? 22.0 : (length <= 12 ? 19.0 : 16.0)) * k;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: width,
      height: width * 4 / 3,
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
          Padding(
            padding: EdgeInsets.fromLTRB(28 * k, 40 * k, 16 * k, 16 * k),
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: coverInkColor(coverColor),
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  // 表紙の大きさは変わらないので、文字サイズ設定は効かせない。
                  textScaler: TextScaler.noScaling,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
