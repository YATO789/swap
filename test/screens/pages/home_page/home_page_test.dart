import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('日記帳の一覧と書き込みバーが出る', (tester) async {
    await tester.pumpApp(const HomePage());

    expect(find.text('大学'), findsOneWidget);
    expect(find.text('会社'), findsOneWidget);
    expect(find.text('高校'), findsOneWidget);
    expect(find.text('今なにしてる？'), findsOneWidget);
  });

  testWidgets('リストとグリッドを切り替えられる', (tester) async {
    await tester.pumpApp(const HomePage());

    expect(find.byIcon(Icons.chevron_right), findsWidgets);

    await tester.tap(find.byTooltip('表紙を大きく表示'));
    await tester.pump();

    expect(find.byTooltip('リストで表示'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);

    await tester.tap(find.byTooltip('リストで表示'));
    await tester.pump();

    expect(find.byTooltip('表紙を大きく表示'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsWidgets);
  });
}
