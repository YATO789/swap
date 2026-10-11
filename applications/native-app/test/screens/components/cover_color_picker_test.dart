import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/components/cover_color_picker.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('選べる色の数だけ丸を出し、押した色を返す', (tester) async {
    Color? selected;
    var called = false;
    await tester.pumpApp(
      Scaffold(
        body: CoverColorPicker(
          selected: null,
          onSelected: (color) {
            called = true;
            selected = color;
          },
        ),
      ),
    );

    final circles = find.bySemanticsLabel('表紙の色');
    expect(circles, findsNWidgets(coverColors.length));

    await tester.tap(circles.at(1));
    expect(called, isTrue);
    expect(selected, initialCoverColor);
  });
}
