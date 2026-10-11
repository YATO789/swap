import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/components/diary_cover.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('名前を出し、高さを幅の 4/3 にする', (tester) async {
    await tester.pumpApp(
      const Center(child: DiaryCover(name: '大学', color: null, width: 120)),
    );

    expect(find.text('大学'), findsOneWidget);
    expect(tester.getSize(find.byType(DiaryCover)), const Size(120, 160));
  });
}
