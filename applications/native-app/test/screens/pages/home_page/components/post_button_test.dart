import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/pages/home_page/components/post_button.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('入力欄風の欄と日記を書くボタンが出る', (tester) async {
    await tester.pumpApp(const Scaffold(bottomNavigationBar: PostButton()));

    expect(find.text('今なにしてる？'), findsOneWidget);
    expect(find.byTooltip('今日の日記を書く'), findsOneWidget);
  });
}
