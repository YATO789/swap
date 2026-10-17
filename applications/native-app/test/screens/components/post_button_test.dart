import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/components/post_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('入力欄風の欄と日記を書くボタンが出る', (tester) async {
    await tester.pumpApp(const Scaffold(bottomNavigationBar: PostButton()));

    expect(find.text('今なにしてる？'), findsOneWidget);
    expect(find.byTooltip('今日の日記を書く'), findsOneWidget);
  });

  testWidgets('端末の言語が英語なら、英語で出る', (tester) async {
    await tester.pumpApp(
      const Scaffold(bottomNavigationBar: PostButton()),
      locale: const Locale('en'),
    );

    expect(find.text('What are you up to?'), findsOneWidget);
    expect(find.byTooltip("Write today's diary"), findsOneWidget);
  });
}
