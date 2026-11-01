import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/infrastructures/repositories/cover_decoration_json.dart';

/// DB から返ってくるのと同じく、JSON の文字列を読んだ値にする。
Object? _decode(String json) {
  return jsonDecode(json);
}

void main() {
  group('coverDecorationFromJson', () {
    test('正しい形を読む', () {
      final decoration = coverDecorationFromJson(
        _decode('''
          {"v": 1,
           "stickers": [{"type": "emoji", "char": "🌻", "x": 0.3, "y": 0.63, "size": 0.24, "rot": -0.22, "frame": false}],
           "strokes": [{"color": 4282278877, "width": 0.016, "points": [[0.28, 0.44], [0.304, 0.449]]}]}
        '''),
      );

      expect(
        decoration,
        const CoverDecoration(
          version: 1,
          stickers: [
            CoverSticker(
              emoji: '🌻',
              x: 0.3,
              y: 0.63,
              size: 0.24,
              rotation: -0.22,
              frame: false,
            ),
          ],
          strokes: [
            CoverStroke(
              color: 4282278877,
              width: 0.016,
              points: [Offset(0.28, 0.44), Offset(0.304, 0.449)],
            ),
          ],
        ),
      );
    });

    test('文字と名前を読む', () {
      final decoration = coverDecorationFromJson(
        _decode('''
          {"v": 2,
           "stickers": [
             {"type": "name", "x": 0.536, "y": 0.323, "size": 0.27, "rot": 0, "frame": false},
             {"type": "text", "text": "2026", "x": 0.5, "y": 1.1, "size": 0.3, "rot": 0.05, "frame": true, "color": 4294967295}
           ]}
        '''),
      );

      expect(
        decoration,
        const CoverDecoration(
          stickers: [
            CoverSticker(
              isName: true,
              x: 0.536,
              y: 0.323,
              size: 0.27,
              frame: false,
            ),
            CoverSticker(
              text: '2026',
              x: 0.5,
              y: 1.1,
              size: 0.3,
              rotation: 0.05,
              color: 0xFFFFFFFF,
            ),
          ],
        ),
      );
      expect(decoration!.placesName, isTrue);
    });

    test('null・object でないもの・v1 で何もない飾りは、飾りなし', () {
      expect(coverDecorationFromJson(null), isNull);
      expect(coverDecorationFromJson(_decode('[1, 2]')), isNull);
      expect(coverDecorationFromJson(_decode('"text"')), isNull);
      expect(coverDecorationFromJson(_decode('{"v": 1}')), isNull);
      expect(
        coverDecorationFromJson(_decode('{"stickers": "x", "strokes": 3}')),
        isNull,
      );
    });

    test('v2 で何もない飾りは、名前を外した表紙として返す', () {
      final decoration = coverDecorationFromJson(
        _decode('{"v": 2, "stickers": [], "strokes": []}'),
      );

      expect(decoration, isNotNull);
      expect(decoration!.placesName, isTrue);
      expect(decoration.hasName, isFalse);
    });

    test('文字は長すぎるもの・行が多すぎるもの・空のもの・上限を超えるぶんを飛ばし、名前は1つだけ読む', () {
      final decoration = coverDecorationFromJson(
        _decode(
          jsonEncode({
            'v': 2,
            'stickers': [
              {'type': 'name', 'x': 0.5, 'y': 0.3, 'size': 0.3},
              {'type': 'name', 'x': 0.5, 'y': 0.6, 'size': 0.3},
              {
                'type': 'text',
                'text': 'あ' * (maxCoverTextLength + 1),
                'x': 0.5,
                'y': 0.5,
                'size': 0.3,
              },
              {
                'type': 'text',
                'text': '1\n2\n3\n4',
                'x': 0.5,
                'y': 0.5,
                'size': 0.3,
              },
              {'type': 'text', 'text': '  ', 'x': 0.5, 'y': 0.5, 'size': 0.3},
              {
                'type': 'text',
                'text': 'ok',
                'x': 0.5,
                'y': 0.5,
                'size': 0.3,
                'color': -1,
              },
              for (var i = 0; i < maxCoverTexts; i++)
                {'type': 'text', 'text': '$i', 'x': 0.5, 'y': 0.5, 'size': 0.3},
            ],
          }),
        ),
      )!;

      expect(decoration.stickers.where((s) => s.isName), hasLength(1));
      expect(decoration.stickers.first.y, 0.3);
      expect(decoration.textCount, maxCoverTexts);
      expect(decoration.stickers[1].text, 'ok');
      // 色として読めない値は、表紙に合わせる色にする。
      expect(decoration.stickers[1].color, isNull);
    });

    test('v1 の飾りの名前は読まない（名前は決まった形で出す）', () {
      final decoration = coverDecorationFromJson(
        _decode('''
          {"v": 1,
           "stickers": [
             {"type": "name", "x": 0.5, "y": 0.3, "size": 0.3},
             {"type": "emoji", "char": "🌻", "x": 0.5, "y": 0.5, "size": 0.2}
           ]}
        '''),
      )!;

      expect(decoration.placesName, isFalse);
      expect(decoration.stickers.map((s) => s.emoji), ['🌻']);
    });

    test('知らない種類や形の違う要素は飛ばし、読めたものだけ出す', () {
      final decoration = coverDecorationFromJson(
        _decode('''
          {"v": 1,
           "stickers": [
             {"type": "photo", "path": "a/1.jpg", "x": 0.5, "y": 0.5, "size": 0.5, "rot": 0, "frame": true},
             {"type": "emoji", "char": "", "x": 0.5, "y": 0.5, "size": 0.2},
             {"type": "emoji", "char": "🍙", "x": "0.5", "y": 0.5, "size": 0.2},
             "text",
             {"type": "emoji", "char": "🌻", "x": 0.5, "y": 0.5, "size": 0.2}
           ],
           "strokes": [
             {"color": -1, "width": 0.02, "points": [[0.1, 0.1]]},
             {"color": 4278190080, "width": 0.02, "points": []},
             {"color": 4278190080, "width": 0.02, "points": [[0.1], "x", [0.2, 0.2]]}
           ]}
        '''),
      )!;

      expect(decoration.stickers.map((s) => s.emoji), ['🌻']);
      // 足りない項目は決まった値にする。
      expect(decoration.stickers.single.rotation, 0);
      expect(decoration.stickers.single.frame, isTrue);
      expect(decoration.strokes.single.points, const [Offset(0.2, 0.2)]);
    });

    test('数値は範囲におさめる', () {
      final decoration = coverDecorationFromJson(
        _decode('''
          {"stickers": [{"type": "emoji", "char": "🌻", "x": 5, "y": -1, "size": 100}],
           "strokes": [{"color": 4278190080, "width": 9, "points": [[-1, 9]]}]}
        '''),
      )!;

      final sticker = decoration.stickers.single;
      expect(sticker.x, 1);
      expect(sticker.y, 0);
      expect(sticker.size, maxCoverStickerSize);
      expect(decoration.strokes.single.width, maxCoverStrokeWidth);
      expect(
        decoration.strokes.single.points.single,
        const Offset(0, coverHeightRatio),
      );
    });

    test('上限を超えるぶんは読まない', () {
      final stickers = [
        for (var i = 0; i < maxCoverStickers + 5; i++)
          {'type': 'emoji', 'char': '🌻', 'x': 0.5, 'y': 0.5, 'size': 0.2},
      ];
      final strokes = [
        for (var i = 0; i < maxCoverStrokes + 5; i++)
          {
            'color': 0xFF000000,
            'width': 0.02,
            'points': [
              [0.5, 0.5],
            ],
          },
      ];

      final decoration = coverDecorationFromJson(
        _decode(jsonEncode({'stickers': stickers, 'strokes': strokes})),
      )!;

      expect(decoration.stickers, hasLength(maxCoverStickers));
      expect(decoration.strokes, hasLength(maxCoverStrokes));
    });

    test('新しいアプリで飾ったものは、読めたものがなくても編集させないために返す', () {
      final decoration = coverDecorationFromJson(
        _decode(
          '''
          {"v": 2,
           "stickers": [{"type": "photo", "path": "a/1.jpg", "x": 0.5, "y": 0.5, "size": 0.5, "rot": 0, "frame": true}]}
        '''
              .replaceFirst('"v": 2', '"v": ${coverDecorationVersion + 1}'),
        ),
      );

      expect(decoration, isNotNull);
      expect(decoration!.isEmpty, isTrue);
      expect(decoration.isEditable, isFalse);
    });
  });

  group('coverDecorationToJson', () {
    test('小数 3 桁に丸めて書き、読み直すと同じになる', () {
      const decoration = CoverDecoration(
        stickers: [
          CoverSticker(
            emoji: '🌻',
            x: 0.12345,
            y: 0.5,
            size: 0.2,
            rotation: 0.1,
          ),
        ],
        strokes: [
          CoverStroke(
            color: 0xFF3E63DD,
            width: 0.024,
            points: [Offset(0.11111, 0.22222)],
          ),
        ],
      );

      final json = coverDecorationToJson(decoration)!;

      expect(json['v'], coverDecorationVersion);
      expect((json['stickers'] as List).single, {
        'type': 'emoji',
        'char': '🌻',
        'x': 0.123,
        'y': 0.5,
        'size': 0.2,
        'rot': 0.1,
        'frame': true,
      });
      expect(((json['strokes'] as List).single as Map)['points'], [
        [0.111, 0.222],
      ]);
      expect(
        coverDecorationFromJson(_decode(jsonEncode(json)))!.stickers.single.x,
        0.123,
      );
    });

    test('文字と名前を書き、色は決めたときだけ書く', () {
      const decoration = CoverDecoration(
        stickers: [
          CoverSticker(isName: true, x: 0.5, y: 0.3, size: 0.3),
          CoverSticker(
            text: '2026',
            x: 0.5,
            y: 1,
            size: 0.3,
            color: 0xFFFFFFFF,
          ),
        ],
      );

      final json = coverDecorationToJson(decoration)!;

      expect(json['stickers'], [
        {
          'type': 'name',
          'x': 0.5,
          'y': 0.3,
          'size': 0.3,
          'rot': 0.0,
          'frame': true,
        },
        {
          'type': 'text',
          'text': '2026',
          'x': 0.5,
          'y': 1.0,
          'size': 0.3,
          'rot': 0.0,
          'frame': true,
          'color': 0xFFFFFFFF,
        },
      ]);
      expect(coverDecorationFromJson(_decode(jsonEncode(json))), decoration);
    });

    test('飾りがないときと、v1 で何も飾っていないときは null', () {
      expect(coverDecorationToJson(null), isNull);
      expect(coverDecorationToJson(const CoverDecoration(version: 1)), isNull);
    });

    test('v2 では何もなくても書く（名前を外したことを残す）', () {
      expect(coverDecorationToJson(const CoverDecoration()), {
        'v': coverDecorationVersion,
        'stickers': <Object>[],
        'strokes': <Object>[],
      });
    });
  });
}
