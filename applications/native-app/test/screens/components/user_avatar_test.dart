import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/components/user_avatar.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('名前の1文字目を出す', (tester) async {
    await tester.pumpApp(const UserAvatar(name: '彩人', filled: true));

    expect(find.text('彩'), findsOneWidget);
  });

  testWidgets('名前が空なら人のアイコンを出す', (tester) async {
    await tester.pumpApp(const UserAvatar(name: '  ', filled: false));

    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
