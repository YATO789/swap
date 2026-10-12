import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/infrastructures/datasources/stores/diary_book_grid_store.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';
import 'package:swap/screens/pages/onboarding_page/onboarding_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/screens/pages/welcome_page/welcome_page.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';
import '../../../helpers/pump_app.dart';

/// ルーターごとアプリを出す。サインインしていない状態から始まる。
Future<void> _pumpRouterApp(WidgetTester tester, {Profile? profile}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        diaryBookGridStoreProvider.overrideWithValue(FakeDiaryBookGridStore()),
        authenticationRepositoryProvider.overrideWith(
          FakeAuthenticationRepository.new,
        ),
        openedNotificationRepositoryProvider.overrideWithValue(
          FakeOpenedNotificationRepository(),
        ),
        profileRepositoryProvider.overrideWith(
          () => FakeProfileRepository(profile: profile),
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
}

void main() {
  testWidgets('アプリ名とサインインボタンが出る', (tester) async {
    await tester.pumpApp(const WelcomePage());

    expect(find.text('Swap!'), findsOneWidget);
    expect(find.text('Appleでサインイン'), findsOneWidget);
  });

  testWidgets('サインインすると、名前を決めていればホームへ進む', (tester) async {
    await _pumpRouterApp(
      tester,
      profile: const Profile(id: 'me', displayName: '彩人'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WelcomePage), findsOneWidget);

    await tester.tap(find.text('Appleでサインイン'));
    await tester.pump();

    expect(find.text('サインイン中…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('サインインすると、名前を決めていなければオンボーディングへ進む', (tester) async {
    await _pumpRouterApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Appleでサインイン'));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingPage), findsOneWidget);
  });
}
