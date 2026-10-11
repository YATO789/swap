import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/components/diary_book_icon.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('ラベルの文字を出す', (tester) async {
    await tester.pumpApp(const DiaryBookIcon(label: '大'));

    expect(find.text('大'), findsOneWidget);
  });

  testWidgets('高さ size に対して幅を 3/4 にする', (tester) async {
    await tester.pumpApp(
      const Center(child: DiaryBookIcon(label: '大', size: 40)),
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
