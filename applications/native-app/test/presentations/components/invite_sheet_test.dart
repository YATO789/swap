import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/presentations/components/cover_decoration_layer.dart';
import 'package:swap/presentations/components/invite_sheet.dart';

import '../../helpers/pump_app.dart';

const _diaryBook = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'Uni4823',
  memberCount: 1,
);

/// 押すと招待シートを開くボタンを出す。
Future<void> _pumpOpener(
  WidgetTester tester, {
  VoidCallback? onDecorateCover,
}) async {
  await tester.pumpApp(
    Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => showInviteSheet(
            context,
            _diaryBook,
            justCreated: true,
            onDecorateCover: onDecorateCover,
          ),
          child: const Text('開く'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('開く'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('表紙を飾る入口があれば、見本の表紙と文を出し、押すとシートを閉じて呼ぶ', (tester) async {
    var decorated = 0;
    await _pumpOpener(tester, onDecorateCover: () => decorated++);

    expect(find.text('絵文字や文字、らくがきで、表紙を自分たちらしく飾れます'), findsOneWidget);
    expect(find.byType(CoverDecorationLayer), findsOneWidget);

    await tester.tap(find.text('表紙を飾る'));
    await tester.pumpAndSettle();

    expect(decorated, 1);
    expect(find.text('表紙を飾る'), findsNothing);
  });

  testWidgets('表紙を飾る入口がなければ、見本も出さない', (tester) async {
    await _pumpOpener(tester);

    expect(find.text('表紙を飾る'), findsNothing);
    expect(find.byType(CoverDecorationLayer), findsNothing);
  });
}
