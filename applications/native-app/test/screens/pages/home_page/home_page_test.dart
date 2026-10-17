import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:swap/domains/app_update/app_update.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/repositories/app_update_repository.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_grid_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';
import '../../../helpers/pump_app.dart';

const _diaryBooks = [
  DiaryBook(
    id: 'university',
    name: '大学',
    inviteCode: 'UNI482',
    memberCount: 5,
    coverColor: 0xFF2F3E5C,
  ),
  DiaryBook(id: 'company', name: '会社', inviteCode: 'WRK731', memberCount: 8),
];

List<Override> _overrides(
  List<DiaryBook> diaryBooks, {
  FakeOpenedNotificationRepository? notifications,
  FakeDiaryBookRepository? diaryBookRepository,
  FakeAppUpdateRepository? appUpdateRepository,
}) => [
  appUpdateRepositoryProvider.overrideWith(
    () => appUpdateRepository ?? FakeAppUpdateRepository(),
  ),
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
    () => diaryBookRepository ?? FakeDiaryBookRepository(diaryBooks),
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
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(
        path: '/diary-books/:id',
        builder: (_, state) =>
            Scaffold(body: Text('日記帳 ${state.pathParameters['id']}')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferencesStoreProvider.overrideWithValue(FakePreferencesStore()),
        ..._overrides(_diaryBooks, notifications: notifications),
      ],
      child: MaterialApp.router(
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildLightTheme(),
        routerConfig: router,
      ),
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

  testWidgets('設定に合わせてリストかグリッドで出す', (tester) async {
    await _pumpHome(tester, _diaryBooks);

    // 選んだことがなければグリッド。
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.text('5人'), findsOneWidget);

    // 設定画面で切り替えたときと同じく、保存した値を変える。
    await ProviderScope.containerOf(tester.element(find.byType(HomePage)))
        .read(diaryBookGridRepositoryProvider.notifier)
        .save(false);
    await tester.pump();

    expect(find.byIcon(Icons.chevron_right), findsWidgets);
  });

  testWidgets('新しいバージョンがあれば知らせ、あとでにすると覚えておく', (tester) async {
    final repository = FakeAppUpdateRepository(AppUpdate.optional);
    await tester.pumpApp(
      const HomePage(),
      overrides: _overrides(_diaryBooks, appUpdateRepository: repository),
    );
    await tester.pumpAndSettle();

    expect(find.text('新しいバージョンがあります'), findsOneWidget);

    await tester.tap(find.text('あとで'));
    await tester.pumpAndSettle();

    expect(find.text('新しいバージョンがあります'), findsNothing);
    expect(repository.skipped, isTrue);
  });

  testWidgets('アップデートしなくてよければ知らせない', (tester) async {
    await _pumpHome(tester, _diaryBooks);
    await tester.pumpAndSettle();

    expect(find.text('新しいバージョンがあります'), findsNothing);
  });

  testWidgets('引っ張ると、ほかの人が変えた名前や表紙を読み直す', (tester) async {
    final repository = FakeDiaryBookRepository(_diaryBooks);
    await tester.pumpApp(
      const HomePage(),
      overrides: _overrides(_diaryBooks, diaryBookRepository: repository),
    );
    await tester.pump();

    repository.refreshed = [
      _diaryBooks.first.copyWith(name: 'ゼミ', memberCount: 6),
      _diaryBooks.last,
    ];
    await tester.fling(find.text('大学'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.text('大学'), findsNothing);
    expect(find.text('ゼミ'), findsOneWidget);
    expect(find.text('6人'), findsOneWidget);
  });

  testWidgets('読み直せなければ、一覧はそのままで知らせる', (tester) async {
    final repository = FakeDiaryBookRepository(_diaryBooks)
      ..failsToRefresh = true;
    await tester.pumpApp(
      const HomePage(),
      overrides: _overrides(_diaryBooks, diaryBookRepository: repository),
    );
    await tester.pump();

    await tester.fling(find.text('大学'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.text('大学'), findsOneWidget);
    expect(find.text('日記帳を読み込めませんでした。もう一度お試しください'), findsOneWidget);
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
