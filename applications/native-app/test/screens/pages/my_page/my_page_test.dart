import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/diary_book_grid_store.dart';
import 'package:swap/infrastructures/datasources/stores/theme_mode_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/infrastructures/repositories/push_token_repository.dart';
import 'package:swap/screens/pages/my_page/my_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/screens/pages/welcome_page/welcome_page.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';

/// サインインした状態でルーターごとアプリを出し、ホームからマイページを開く。
Future<void> _openMyPage(
  WidgetTester tester, {
  FakeDiaryBookGridStore? gridStore,
  FakePushTokenRepository? pushTokenRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        diaryBookGridStoreProvider.overrideWithValue(
          gridStore ?? FakeDiaryBookGridStore(),
        ),
        themeModeStoreProvider.overrideWithValue(FakeThemeModeStore()),
        openedNotificationRepositoryProvider.overrideWithValue(
          FakeOpenedNotificationRepository(),
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
        pushTokenRepositoryProvider.overrideWith(
          () => pushTokenRepository ?? FakePushTokenRepository(),
        ),
        diaryBookRepositoryProvider.overrideWith(
          () => FakeDiaryBookRepository(const []),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          theme: buildLightTheme(),
          routerConfig: ref.watch(routerProvider),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byTooltip('プロフィールと設定'));
  await tester.pumpAndSettle();
  expect(find.byType(MyPage), findsOneWidget);
}

void main() {
  testWidgets('日記帳の並べ方を選ぶと、保存する', (tester) async {
    final gridStore = FakeDiaryBookGridStore();
    await _openMyPage(tester, gridStore: gridStore);

    await tester.tap(find.bySemanticsLabel('表紙'));
    await tester.pumpAndSettle();
    expect(gridStore.grid, isTrue);

    await tester.tap(find.bySemanticsLabel('リスト'));
    await tester.pumpAndSettle();
    expect(gridStore.grid, isFalse);
  });

  testWidgets('ログアウトを確かめると、通知の送り先から外してウェルカム画面に戻る', (tester) async {
    final pushTokenRepository = FakePushTokenRepository();
    await _openMyPage(tester, pushTokenRepository: pushTokenRepository);
    await tester.scrollUntilVisible(find.text('ログアウト'), 200);

    await tester.tap(find.text('ログアウト'));
    await tester.pumpAndSettle();
    expect(find.text('ログアウトしますか？'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'ログアウト'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
    // サーバーに頼むにはサインインしている必要があるので、サインアウトより先に外す。
    expect(pushTokenRepository.unregisteredWhileSignedIn, [true]);
  });

  testWidgets('キャンセルすると、ログアウトせずにマイページに残る', (tester) async {
    await _openMyPage(tester);
    await tester.scrollUntilVisible(find.text('ログアウト'), 200);

    await tester.tap(find.text('ログアウト'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    expect(find.text('ログアウトしますか？'), findsNothing);
    expect(find.byType(MyPage), findsOneWidget);
  });
}
