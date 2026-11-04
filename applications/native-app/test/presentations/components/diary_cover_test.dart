import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/presentations/components/cover_decoration_layer.dart';
import 'package:swap/presentations/components/diary_cover.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('名前を出し、高さを幅の 4/3 にする', (tester) async {
    await tester.pumpApp(
      const Center(child: DiaryCover(name: '大学', color: null, width: 120)),
    );

    expect(find.text('大学'), findsOneWidget);
    expect(tester.getSize(find.byType(DiaryCover)), const Size(120, 160));
  });

  testWidgets('飾りがあれば、貼った絵文字とらくがきを出す', (tester) async {
    await tester.pumpApp(
      const Center(
        child: DiaryCover(
          name: '大学',
          color: null,
          width: 120,
          decoration: CoverDecoration(
            stickers: [CoverSticker(emoji: '🌻', x: 0.5, y: 0.8, size: 0.3)],
            strokes: [
              CoverStroke(
                color: 0xFF111111,
                width: 0.02,
                points: [Offset(0.2, 0.2), Offset(0.8, 0.2)],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CoverDecorationLayer), findsOneWidget);
    // 白いふちと影の分も同じ文字で描く。
    expect(find.text('🌻'), findsWidgets);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is CoverStrokePainter,
      ),
      findsOneWidget,
    );
  });

  testWidgets('名前を貼った飾りなら、決まった場所には名前を出さず、貼ったものとして出す', (tester) async {
    await tester.pumpApp(
      const Center(
        child: DiaryCover(
          name: '大学',
          color: null,
          width: 120,
          decoration: CoverDecoration(
            stickers: [
              CoverSticker(isName: true, x: 0.5, y: 0.3, size: 0.3),
              CoverSticker(text: '2026', x: 0.5, y: 1, size: 0.3),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CoverDecorationLayer), findsOneWidget);
    expect(find.text('大学'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
  });

  testWidgets('名前を外した飾りなら、名前を出さない', (tester) async {
    await tester.pumpApp(
      const Center(
        child: DiaryCover(
          name: '大学',
          color: null,
          width: 120,
          decoration: CoverDecoration(),
        ),
      ),
    );

    expect(find.text('大学'), findsNothing);
  });

  testWidgets('飾りが空なら飾りの層を置かない', (tester) async {
    await tester.pumpApp(
      const Center(
        child: DiaryCover(
          color: null,
          width: 120,
          decoration: CoverDecoration(),
        ),
      ),
    );

    expect(find.byType(CoverDecorationLayer), findsNothing);
  });
}
