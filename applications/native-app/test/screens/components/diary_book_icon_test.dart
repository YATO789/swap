import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/components/diary_book_icon.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('名前の1文字目を出す', (tester) async {
    await tester.pumpApp(const DiaryBookIcon(name: '大学'));

    expect(find.text('大'), findsOneWidget);
  });

  testWidgets('いくつかの文字が合わさった絵文字も、見た目の1文字のまま出す', (tester) async {
    await tester.pumpApp(const DiaryBookIcon(name: '👨‍👩‍👧家族'));

    expect(find.text('👨‍👩‍👧'), findsOneWidget);
  });

  testWidgets('高さ size に対して幅を 3/4 にする', (tester) async {
    await tester.pumpApp(
      const Center(child: DiaryBookIcon(name: '大学', size: 40)),
    );

    final book = tester.getSize(
      find.descendant(
        of: find.byType(DiaryBookIcon),
        matching: find.byType(Container),
      ),
    );
    expect(book, const Size(30, 40));
  });
}
