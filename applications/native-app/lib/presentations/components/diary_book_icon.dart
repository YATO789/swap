import 'package:flutter/material.dart';

/// 色を選んでいない日記帳の表紙のグレー。暗いテーマでは沈んだグレーにする。
Color defaultCoverColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF3A3A3A)
    : const Color(0xFFECECEF);

/// 表紙 [cover] の上に載せる文字の色。明るい表紙には黒、暗い表紙には白を使う。
Color coverInkColor(Color cover) => cover.computeLuminance() > 0.38
    ? const Color(0xFF1D1D1F)
    : Colors.white;

/// 日記帳のアイコン。表紙の色の小さな本に、名前の1文字目を [coverInkColor] で入れて出す。
class DiaryBookIcon extends StatelessWidget {
  const DiaryBookIcon({
    super.key,
    required this.name,
    this.coverColor,
    this.size = 48,
  });

  /// 日記帳の名前。1文字目（絵文字なども見た目の1文字）を表紙に入れる。
  final String name;

  /// 表紙の色（0xAARRGGBB）。null なら [defaultCoverColor]。
  final int? coverColor;

  /// 本の高さ。幅はその 3/4 にする。
  final double size;

  @override
  Widget build(BuildContext context) {
    final coverColor = this.coverColor;
    final color = coverColor == null
        ? defaultCoverColor(context)
        : Color(coverColor);
    final width = size * 3 / 4;
    final spineWidth = size * 0.1;

    return SizedBox(
      // 丸のアイコンだったころと並びが揃うよう、正方形の場所を取って真ん中に置く。
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: width,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(size * 0.03),
              right: Radius.circular(size * 0.08),
            ),
          ),
          child: Stack(
            children: [
              // 背表紙。表紙の見本と同じく、明るい帯と暗い折り目で本らしく見せる。
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: spineWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
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
                padding: EdgeInsets.only(left: spineWidth),
                child: Center(
                  child: Text(
                    name.trim().characters.firstOrNull ?? '',
                    // 文字サイズ設定で本からはみ出さないようにする。
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontSize: size * 0.34,
                      fontWeight: FontWeight.w700,
                      color: coverInkColor(color),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
