import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/utils/format.dart';

import '../helpers/pump_app.dart';

void main() {
  final date = DateTime(2025, 10, 3);

  /// [locale] の言語で [format] した文字を返す。
  Future<String> formatIn(
    WidgetTester tester,
    Locale locale,
    String Function(BuildContext context) format,
  ) async {
    late String text;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          text = format(context);
          return const SizedBox();
        },
      ),
      locale: locale,
    );
    return text;
  }

  testWidgets('日本語では「10月3日 金曜日」の形になる', (tester) async {
    const ja = Locale('ja');
    expect(
      await formatIn(tester, ja, (c) => formatDateWithWeekday(c, date)),
      '10月3日 金曜日',
    );
    expect(await formatIn(tester, ja, (c) => formatMonthDay(c, date)), '10月3日');
    expect(
      await formatIn(tester, ja, (c) => formatYearMonth(c, date)),
      '2025年10月',
    );
  });

  testWidgets('英語では「Friday, October 3」の形になる', (tester) async {
    const en = Locale('en');
    expect(
      await formatIn(tester, en, (c) => formatDateWithWeekday(c, date)),
      'Friday, October 3',
    );
    expect(
      await formatIn(tester, en, (c) => formatMonthDay(c, date)),
      'October 3',
    );
    expect(
      await formatIn(tester, en, (c) => formatYearMonth(c, date)),
      'October 2025',
    );
  });
}
