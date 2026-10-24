import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/presentations/components/user_avatar.dart';

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

  testWidgets('色があれば、自分かどうかにかかわらずその色で塗る', (tester) async {
    await tester.pumpApp(
      const UserAvatar(name: '美緒', filled: false, color: 0xFFFFE07A),
    );

    final decoration =
        tester.widget<Container>(find.byType(Container)).decoration
            as BoxDecoration;
    expect(decoration.color, const Color(0xFFFFE07A));
  });
}
