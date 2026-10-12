import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/my_page/my_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/screens/pages/welcome_page/welcome_page.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';

/// サインインした状態でルーターごとアプリを出し、ホームからマイページを開く。
Future<void> _openMyPage(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
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

  await tester.scrollUntilVisible(find.text('ログアウト'), 200);
}

void main() {
  testWidgets('ログアウトを確かめると、ウェルカム画面に戻る', (tester) async {
    await _openMyPage(tester);

    await tester.tap(find.text('ログアウト'));
    await tester.pumpAndSettle();
    expect(find.text('ログアウトしますか？'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'ログアウト'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
  });

  testWidgets('キャンセルすると、ログアウトせずにマイページに残る', (tester) async {
    await _openMyPage(tester);

    await tester.tap(find.text('ログアウト'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    expect(find.text('ログアウトしますか？'), findsNothing);
    expect(find.byType(MyPage), findsOneWidget);
  });
}
