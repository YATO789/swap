import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/presentations/components/cover_decoration_layer.dart';
import 'package:swap/presentations/pages/cover_decoration_page/components/color_palette.dart';
import 'package:swap/presentations/pages/cover_decoration_page/cover_decoration_page.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/pump_app.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'Uni4823',
  memberCount: 3,
);

/// 大学の日記帳の表紙の編集ページを開く。保存した日記帳は [repository] に入る。
Future<FakeDiaryBookRepository> _open(
  WidgetTester tester, {
  DiaryBook diaryBook = _university,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final repository = FakeDiaryBookRepository([diaryBook]);
  await tester.pumpApp(
    const CoverDecorationPage(diaryBookId: 'university'),
    overrides: [
      authenticationRepositoryProvider.overrideWithValue(
        FakeAuthenticationRepository(
          initial: const Authentication(isSignedIn: true),
        ),
      ),
      diaryBookRepositoryProvider.overrideWithValue(repository),
    ],
  );
  await tester.pumpAndSettle();
  return repository;
}

/// 編集中の表紙に描いているらくがきの線。
List<CoverStroke> _strokes(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.byWidgetPredicate(
      (widget) => widget is CustomPaint && widget.painter is CoverStrokePainter,
    ),
  );
  return (paint.painter! as CoverStrokePainter).strokes;
}

/// パレットのシートの [color] の色。
Finder _paletteColor(int color) {
  return find.bySemanticsLabel('色 ${paletteColorName(color)}');
}

TextButton _saveButton(WidgetTester tester) {
  return tester.widget<TextButton>(find.widgetWithText(TextButton, '保存する'));
}

void main() {
  testWidgets('何も変えていなければ保存できない', (tester) async {
    await _open(tester);

    expect(_saveButton(tester).onPressed, isNull);
  });

  testWidgets('飾りのない表紙を開くと、名前を貼ったものとして動かせる', (tester) async {
    await _open(tester);

    await tester.tap(find.bySemanticsLabel('表紙の名前 大学'));
    await tester.pumpAndSettle();

    // 名前は選べて、色の帯は出るが、書き換えるボタンは出ない。
    expect(find.text('白いふち'), findsOneWidget);
    expect(find.bySemanticsLabel('文字の色 表紙に合わせる'), findsOneWidget);
    expect(find.text('書き換える'), findsNothing);
    // 名前を貼ったものに直しただけなので、保存はできない。
    expect(_saveButton(tester).onPressed, isNull);
  });

  testWidgets('虹色の丸からパレットを開いて色を選ぶと、名前の色になり保存できる', (tester) async {
    final repository = await _open(tester);

    await tester.tap(find.bySemanticsLabel('表紙の名前 大学'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('ほかの色を選ぶ'));
    await tester.pumpAndSettle();

    expect(find.text('文字の色'), findsOneWidget);
    final color = paletteColors[30];
    await tester.tap(_paletteColor(color));
    await tester.pumpAndSettle();

    expect(find.text('文字の色'), findsNothing);
    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    final saved = (await repository.fetchJoined()).single;
    final name = saved.coverDecoration!.stickers.single;
    expect(name.isName, isTrue);
    expect(name.color, color);
  });

  testWidgets('文字を置き、選んでもう一度押すと書き換えられ、元に戻すで戻る', (tester) async {
    await _open(tester);

    await tester.tap(find.text('文字'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), ' 2026 ');
    await tester.pump();
    await tester.tap(find.text('置く'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('置いた文字 2026'), findsOneWidget);
    expect(_saveButton(tester).onPressed, isNotNull);

    // 置いた文字は選ばれているので、もう一度押すと書き換えられる。
    await tester.tap(find.bySemanticsLabel('置いた文字 2026'));
    await tester.pumpAndSettle();
    expect(find.text('文字を書き換える'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '夏');
    await tester.pump();
    await tester.tap(find.text('保存する').last);
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('置いた文字 夏'), findsOneWidget);

    await tester.tap(find.byTooltip('元に戻す'));
    await tester.pump();

    expect(find.bySemanticsLabel('置いた文字 2026'), findsOneWidget);
  });

  testWidgets('名前を外して保存すると、名前のない表紙になり、文字のシートから置き直せる', (tester) async {
    final repository = await _open(tester);

    await tester.tap(find.bySemanticsLabel('表紙の名前 大学'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('消す'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('文字'));
    await tester.pumpAndSettle();
    expect(find.text('日記帳の名前を置く'), findsOneWidget);
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    final saved = (await repository.fetchJoined()).single;
    expect(saved.coverDecoration, isNotNull);
    expect(saved.coverDecoration!.placesName, isTrue);
    expect(saved.coverDecoration!.hasName, isFalse);
  });

  testWidgets('らくがきで表紙をなぞると線が増え、保存すると日記帳に入る', (tester) async {
    final repository = await _open(tester);

    await tester.tap(find.text('らくがき'));
    await tester.pumpAndSettle();
    final area = find.bySemanticsLabel('らくがきをする場所。表紙をなぞって線を描く');
    final center = tester.getCenter(area);
    await tester.dragFrom(center, const Offset(60, 40));
    await tester.pumpAndSettle();

    expect(_strokes(tester), hasLength(1));

    await tester.tap(find.text('終わる'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    final saved = (await repository.fetchJoined()).single;
    expect(saved.coverDecoration!.strokes, hasLength(1));
  });

  testWidgets('消しゴムでなぞると、触れた線が消える', (tester) async {
    await _open(
      tester,
      diaryBook: _university.copyWith(
        coverDecoration: const CoverDecoration(
          strokes: [
            CoverStroke(
              color: 0xFF111111,
              width: 0.024,
              points: [Offset(0, 0.7), Offset(1, 0.7)],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('らくがき'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('消しゴム'));
    await tester.pumpAndSettle();
    final area = find.bySemanticsLabel('らくがきをする場所。表紙をなぞって線を描く');
    final rect = tester.getRect(area);
    // 線は表紙の幅の 0.7 の高さを横切っている。
    await tester.tapAt(Offset(rect.center.dx, rect.top + rect.width * 0.7));
    await tester.pumpAndSettle();

    expect(_strokes(tester), isEmpty);
  });

  testWidgets('色を選ぶと表紙の色が変わり、保存できるようになる', (tester) async {
    await _open(tester);

    await tester.tap(find.text('色'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('表紙の色').at(1));
    await tester.pumpAndSettle();

    expect(_saveButton(tester).onPressed, isNotNull);
  });

  testWidgets('らくがきの虹色の丸からパレットの色を選ぶと、その色で線を描ける', (tester) async {
    await _open(tester);

    await tester.tap(find.text('らくがき'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('ほかの色を選ぶ'));
    await tester.pumpAndSettle();
    expect(find.text('ペンの色'), findsOneWidget);
    final color = paletteColors[40];
    await tester.tap(_paletteColor(color));
    await tester.pumpAndSettle();

    final area = find.bySemanticsLabel('らくがきをする場所。表紙をなぞって線を描く');
    await tester.dragFrom(tester.getCenter(area), const Offset(60, 40));
    await tester.pumpAndSettle();

    expect(_strokes(tester).single.color, color);
  });

  testWidgets('表紙の色の虹色の丸からパレットの色を選ぶと、表紙の色になる', (tester) async {
    final repository = await _open(tester);

    await tester.tap(find.text('色'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('ほかの色を選ぶ'));
    await tester.pumpAndSettle();
    expect(find.text('表紙の色'), findsOneWidget);
    final color = paletteColors[50];
    await tester.tap(_paletteColor(color));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    final saved = (await repository.fetchJoined()).single;
    expect(saved.coverColor, color);
  });

  testWidgets('貼った絵文字を選ぶと、重なり順・ふち・消すが出て、消すとはがれる', (tester) async {
    await _open(
      tester,
      diaryBook: _university.copyWith(
        coverDecoration: const CoverDecoration(
          stickers: [CoverSticker(emoji: '🌻', x: 0.5, y: 0.9, size: 0.3)],
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('貼った絵文字 🌻'));
    await tester.pumpAndSettle();

    expect(find.text('前へ'), findsOneWidget);
    expect(find.text('白いふち'), findsOneWidget);

    await tester.tap(find.text('消す'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('貼った絵文字 🌻'), findsNothing);
    expect(_saveButton(tester).onPressed, isNotNull);
  });
}
