import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';

CoverSticker _sticker(String emoji, {double x = 0.5, double y = 0.5}) {
  return CoverSticker(emoji: emoji, x: x, y: y, size: 0.2);
}

CoverStroke _stroke(List<Offset> points, {double width = 0.02}) {
  return CoverStroke(color: 0xFF111111, width: width, points: points);
}

void main() {
  group('CoverSticker.clamped', () {
    test('中心を表紙の中に、大きさを上限と下限の間におさめる', () {
      const sticker = CoverSticker(emoji: '🌻', x: -0.2, y: 2, size: 3);

      final clamped = sticker.clamped();

      expect(clamped.x, 0);
      expect(clamped.y, coverHeightRatio);
      expect(clamped.size, maxCoverStickerSize);
      expect(
        const CoverSticker(
          emoji: '🌻',
          x: 0.5,
          y: 0.5,
          size: 0.01,
        ).clamped().size,
        minCoverStickerSize,
      );
    });
  });

  group('絵文字', () {
    test('貼ったものは一番上に重なり、範囲におさめて足す', () {
      final decoration = const CoverDecoration()
          .addSticker(_sticker('🌻'))
          .addSticker(_sticker('🍙', x: 1.5));

      expect(decoration.stickers.map((s) => s.emoji), ['🌻', '🍙']);
      expect(decoration.stickers.last.x, 1);
    });

    test('貼れる数を超えると足さない', () {
      var decoration = const CoverDecoration();
      for (var i = 0; i < maxCoverStickers; i++) {
        decoration = decoration.addSticker(_sticker('$i'));
      }

      expect(decoration.canAddSticker, isFalse);
      expect(
        decoration.addSticker(_sticker('x')).stickers,
        hasLength(maxCoverStickers),
      );
    });

    test('動かすときも範囲におさめる', () {
      final decoration = const CoverDecoration().addSticker(_sticker('🌻'));

      final moved = decoration.replaceSticker(0, _sticker('🌻', y: -1));

      expect(moved.stickers.single.y, 0);
    });

    test('前へ・うしろへで重なりの順を変え、端より先には動かさない', () {
      final decoration = const CoverDecoration()
          .addSticker(_sticker('a'))
          .addSticker(_sticker('b'))
          .addSticker(_sticker('c'));

      expect(decoration.moveSticker(0, 1).stickers.map((s) => s.emoji), [
        'b',
        'a',
        'c',
      ]);
      expect(decoration.moveSticker(2, 1).stickers.map((s) => s.emoji), [
        'a',
        'c',
        'b',
      ]);
      expect(decoration.moveSticker(2, 3), same(decoration));
      expect(decoration.moveSticker(0, -1), same(decoration));
    });

    test('はがす', () {
      final decoration = const CoverDecoration()
          .addSticker(_sticker('a'))
          .addSticker(_sticker('b'));

      expect(decoration.removeSticker(0).stickers.map((s) => s.emoji), ['b']);
    });
  });

  group('文字と名前', () {
    test('文字は上限まで置け、名前は数えない', () {
      var decoration = const CoverDecoration().addSticker(
        const CoverSticker(isName: true, x: 0.5, y: 0.3, size: 0.3),
      );
      for (var i = 0; i < maxCoverTexts + 2; i++) {
        decoration = decoration.addSticker(
          CoverSticker(text: '$i', x: 0.5, y: 0.5, size: 0.3),
        );
      }

      expect(decoration.textCount, maxCoverTexts);
      expect(decoration.hasName, isTrue);
      expect(decoration.canAddText, isFalse);
      // 文字を置けなくても、絵文字はまだ貼れる。
      expect(decoration.addSticker(_sticker('🌻')).stickers.last.emoji, '🌻');
    });

    test('名前は1つしか貼れない', () {
      const name = CoverSticker(isName: true, x: 0.5, y: 0.3, size: 0.3);

      final decoration = const CoverDecoration()
          .addSticker(name)
          .addSticker(name);

      expect(decoration.stickers, hasLength(1));
    });

    test('v1 の飾りは名前を貼ったものとして持たない', () {
      expect(const CoverDecoration(version: 1).placesName, isFalse);
      expect(const CoverDecoration().placesName, isTrue);
    });
  });

  group('らくがき', () {
    test('まっすぐな線は両端だけに間引く', () {
      final points = [for (var i = 0; i <= 100; i++) Offset(i / 100, 0.5)];

      final decoration = const CoverDecoration().addStroke(_stroke(points));

      expect(decoration.strokes.single.points, [
        const Offset(0, 0.5),
        const Offset(1, 0.5),
      ]);
    });

    test('曲がり角は残す', () {
      final decoration = const CoverDecoration().addStroke(
        _stroke(const [
          Offset(0, 0),
          Offset(0.25, 0.25),
          Offset(0.5, 0.5),
          Offset(0.75, 0.25),
          Offset(1, 0),
        ]),
      );

      expect(decoration.strokes.single.points, const [
        Offset(0, 0),
        Offset(0.5, 0.5),
        Offset(1, 0),
      ]);
    });

    test('点1つの線（タップ）も足す', () {
      final decoration = const CoverDecoration().addStroke(
        _stroke(const [Offset(0.3, 0.3)]),
      );

      expect(decoration.strokes.single.points, const [Offset(0.3, 0.3)]);
    });

    test('点の数の上限を超えるぶんは切り捨て、上限に届いたら描き始められない', () {
      // 曲がり続けて間引けない線。
      final zigzag = [
        for (var i = 0; i < maxCoverStrokePoints + 10; i++)
          Offset((i % 100) / 100, i.isEven ? 0.2 : 0.8),
      ];

      final decoration = const CoverDecoration().addStroke(_stroke(zigzag));

      expect(decoration.pointCount, maxCoverStrokePoints);
      expect(decoration.remainingPoints, 0);
      expect(decoration.canAddStroke, isFalse);
      expect(
        decoration.addStroke(_stroke(const [Offset(0.1, 0.1)])),
        same(decoration),
      );
    });

    test('線の数の上限に届いたら描き始められない', () {
      var decoration = const CoverDecoration();
      for (var i = 0; i < maxCoverStrokes; i++) {
        decoration = decoration.addStroke(_stroke(const [Offset(0.5, 0.5)]));
      }

      expect(decoration.canAddStroke, isFalse);
    });

    test('消しゴムは、間引いて点の離れた線でも、点のあいだに触れれば消す', () {
      final decoration = const CoverDecoration().addStroke(
        _stroke(const [Offset(0, 0.5), Offset(1, 0.5)]),
      );

      expect(
        decoration
            .eraseStrokesAt(const Offset(0.5, 0.51), reach: 0.025)
            .strokes,
        isEmpty,
      );
    });

    test('消しゴムは触れた線を1本まるごと消し、触れなければそのまま', () {
      final decoration = const CoverDecoration()
          .addStroke(_stroke(const [Offset(0.1, 0.1), Offset(0.9, 0.1)]))
          .addStroke(_stroke(const [Offset(0.1, 1), Offset(0.9, 1)]));

      final erased = decoration.eraseStrokesAt(
        const Offset(0.1, 0.11),
        reach: 0.025,
      );

      expect(erased.strokes, hasLength(1));
      expect(erased.strokes.single.points.first.dy, 1);
      expect(
        decoration.eraseStrokesAt(const Offset(0.5, 0.5), reach: 0.025),
        same(decoration),
      );
    });
  });

  test('新しいアプリで飾ったものは編集できない', () {
    expect(const CoverDecoration().isEditable, isTrue);
    expect(
      const CoverDecoration(version: coverDecorationVersion + 1).isEditable,
      isFalse,
    );
  });
}
