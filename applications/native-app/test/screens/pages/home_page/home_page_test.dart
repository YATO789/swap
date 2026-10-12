import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/post_diary_book_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';
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

List<Override> _overrides(
  List<DiaryBook> diaryBooks, {
  FakeOpenedNotificationRepository? notifications,
}) => [
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
  openedNotificationRepositoryProvider.overrideWithValue(
    notifications ?? FakeOpenedNotificationRepository(),
  ),
];

Future<void> _pumpHome(WidgetTester tester, List<DiaryBook> diaryBooks) async {
  await tester.pumpApp(const HomePage(), overrides: _overrides(diaryBooks));
  await tester.pump();
}

/// 日記帳のページへ移れるように、ルーターの中にホームを置く。
/// 日記帳のページは、開いた日記帳の id だけを出す。
Future<void> _pumpHomeWithRouter(
  WidgetTester tester,
  FakeOpenedNotificationRepository notifications,
) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      GoRoute(
        path: AppRoutes.diaryBook,
        builder: (_, state) =>
            Scaffold(body: Text('日記帳 ${state.pathParameters['id']}')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        postDiaryBookStoreProvider.overrideWithValue(FakePostDiaryBookStore()),
        ..._overrides(_diaryBooks, notifications: notifications),
      ],
      child: MaterialApp.router(theme: buildLightTheme(), routerConfig: router),
    ),
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

  testWidgets('記録の通知をタップすると、その日記帳を開く', (tester) async {
    final notifications = FakeOpenedNotificationRepository();
    await _pumpHomeWithRouter(tester, notifications);

    notifications.diaryBookIds.add('company');
    await tester.pumpAndSettle();

    expect(find.text('日記帳 company'), findsOneWidget);
  });

  testWidgets('開いている日記帳の通知をタップしても、同じページを重ねない', (tester) async {
    final notifications = FakeOpenedNotificationRepository();
    await _pumpHomeWithRouter(tester, notifications);

    notifications.diaryBookIds.add('company');
    await tester.pumpAndSettle();
    notifications.diaryBookIds.add('company');
    await tester.pumpAndSettle();

    // 戻るとホームに出る。
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.text('日記帳 company'), findsNothing);
    expect(find.text('大学'), findsOneWidget);
  });
}
