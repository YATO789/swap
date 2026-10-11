import 'package:flutter_test/flutter_test.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';
import 'package:swap/screens/pages/welcome_page/welcome_page.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('アプリ名とサインインボタンが出る', (tester) async {
    await tester.pumpApp(const WelcomePage());

    expect(find.text('Swap!'), findsOneWidget);
    expect(find.text('Appleでサインイン'), findsOneWidget);
  });

  testWidgets('サインインするとホームへ進む', (tester) async {
    await tester.pumpApp(const WelcomePage());

    await tester.tap(find.text('Appleでサインイン'));
    await tester.pump();

    expect(find.text('サインイン中…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
