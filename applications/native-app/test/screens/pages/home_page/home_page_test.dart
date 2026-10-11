import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/pump_app.dart';

const _diaryBooks = [
  DiaryBook(
    id: 'university',
    name: '大学',
    icon: '大',
    inviteCode: 'UNI482',
    memberCount: 5,
    coverColor: 0xFF2F3E5C,
  ),
  DiaryBook(
    id: 'company',
    name: '会社',
    icon: '社',
    inviteCode: 'WRK731',
    memberCount: 8,
  ),
];

Future<void> _pumpHome(WidgetTester tester, List<DiaryBook> diaryBooks) async {
  await tester.pumpApp(
    const HomePage(),
    overrides: [
      authenticationRepositoryProvider.overrideWith(
        () => FakeAuthenticationRepository(
          initial: const Authentication(isLoginApp: true),
        ),
      ),
      profileRepositoryProvider.overrideWith(
        () => FakeProfileRepository(
          profile: const Profile(id: 'me', displayName: '彩人'),
        ),
      ),
      diaryBookRepositoryProvider.overrideWith(
        () => FakeDiaryBookRepository(diaryBooks),
      ),
    ],
  );
  await tester.pump();
}

void main() {
  testWidgets('日記帳の一覧と書き込みバーが出る', (tester) async {
    await _pumpHome(tester, _diaryBooks);

    expect(find.text('大学'), findsOneWidget);
    expect(find.text('会社'), findsOneWidget);
    expect(find.text('5人'), findsOneWidget);
    expect(find.text('今なにしてる？'), findsOneWidget);
    expect(find.byTooltip('日記帳を追加'), findsOneWidget);
  });

  testWidgets('日記帳がなければ作るか参加するよう案内する', (tester) async {
    await _pumpHome(tester, const []);

    expect(find.text('日記帳を作る'), findsOneWidget);
    expect(find.text('招待コードで参加'), findsOneWidget);
    expect(find.text('今なにしてる？'), findsNothing);
    expect(find.byTooltip('日記帳を追加'), findsNothing);
  });

  testWidgets('リストとグリッドを切り替えられる', (tester) async {
    await _pumpHome(tester, _diaryBooks);

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
