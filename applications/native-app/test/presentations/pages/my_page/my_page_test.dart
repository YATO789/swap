import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/feedback_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/infrastructures/repositories/push_token_repository.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/presentations/pages/feedback_page/feedback_page.dart';
import 'package:swap/presentations/pages/my_page/my_page.dart';
import 'package:swap/presentations/pages/router/router.dart';
import 'package:swap/presentations/pages/welcome_page/welcome_page.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';

/// 設定画面の一覧。名前の入力欄もスクロールできるので、一覧を名指しして送る。
final _settingsList = find.byType(Scrollable).first;

/// サインインした状態でルーターごとアプリを出し、ホームからマイページを開く。
Future<void> _openMyPage(
  WidgetTester tester, {
  FakePreferencesStore? preferencesStore,
  FakeAuthenticationRepository? authenticationRepository,
  FakePushTokenRepository? pushTokenRepository,
  FakeFeedbackRepository? feedbackRepository,
  FakeProfileRepository? profileRepository,
}) async {
  final authentication =
      authenticationRepository ??
      FakeAuthenticationRepository(
        initial: const Authentication(isSignedIn: true),
      );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferencesStoreProvider.overrideWithValue(
          preferencesStore ?? FakePreferencesStore(),
        ),
        openedNotificationRepositoryProvider.overrideWithValue(
          FakeOpenedNotificationRepository(),
        ),
        authenticationRepositoryProvider.overrideWithValue(authentication),
        profileRepositoryProvider.overrideWithValue(
          profileRepository ??
              FakeProfileRepository(
                profile: const Profile(id: 'me', displayName: '彩人'),
              ),
        ),
        pushTokenRepositoryProvider.overrideWithValue(
          pushTokenRepository ?? FakePushTokenRepository(authentication),
        ),
        diaryBookRepositoryProvider.overrideWithValue(
          FakeDiaryBookRepository(const []),
        ),
        feedbackRepositoryProvider.overrideWithValue(
          feedbackRepository ?? FakeFeedbackRepository(),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
  testWidgets('設定画面の中で名前を変えて完了を押すと、保存する', (tester) async {
    final profileRepository = FakeProfileRepository(
      profile: const Profile(id: 'me', displayName: '彩人'),
    );
    await _openMyPage(tester, profileRepository: profileRepository);
    final nameField = find.widgetWithText(TextField, '彩人');
    expect(nameField, findsOneWidget);

    await tester.enterText(nameField, '  あやと  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(profileRepository.profile?.displayName, 'あやと');
    expect(find.text('プロフィールを保存しました'), findsOneWidget);
  });

  testWidgets('名前を空にして欄を離れると、保存せずに元の名前に戻す', (tester) async {
    final profileRepository = FakeProfileRepository(
      profile: const Profile(id: 'me', displayName: '彩人'),
    );
    await _openMyPage(tester, profileRepository: profileRepository);
    final nameField = find.widgetWithText(TextField, '彩人');

    await tester.enterText(nameField, '');
    await tester.pump();
    expect(find.text('名前を入力してください'), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(profileRepository.profile?.displayName, '彩人');
    expect(find.widgetWithText(TextField, '彩人'), findsOneWidget);
    expect(find.text('名前を入力してください'), findsNothing);
  });

  testWidgets('日記帳の並べ方を選ぶと、保存する', (tester) async {
    final preferencesStore = FakePreferencesStore();
    await _openMyPage(tester, preferencesStore: preferencesStore);

    await tester.tap(find.bySemanticsLabel('並べる'));
    await tester.pumpAndSettle();
    expect(preferencesStore.diaryBookPaged, isFalse);

    await tester.tap(find.bySemanticsLabel('1冊ずつ'));
    await tester.pumpAndSettle();
    expect(preferencesStore.diaryBookPaged, isTrue);
  });

  testWidgets('書き込みバーの説明のスイッチを切り替えると、保存する', (tester) async {
    final preferencesStore = FakePreferencesStore();
    await _openMyPage(tester, preferencesStore: preferencesStore);
    final hintSwitch = find.widgetWithText(SwitchListTile, '書き込みバーの説明');
    await tester.scrollUntilVisible(hintSwitch, 200, scrollable: _settingsList);

    await tester.tap(hintSwitch);
    await tester.pumpAndSettle();
    expect(preferencesStore.postHintVisible, isFalse);

    await tester.tap(hintSwitch);
    await tester.pumpAndSettle();
    expect(preferencesStore.postHintVisible, isTrue);
  });

  testWidgets('フィードバックを書いて送ると、送ってマイページに戻る', (tester) async {
    final feedbackRepository = FakeFeedbackRepository();
    await _openMyPage(tester, feedbackRepository: feedbackRepository);
    // すぐ下の行まで送って、フィードバックの行を画面に収める。
    await tester.scrollUntilVisible(
      find.text('バージョン'),
      200,
      scrollable: _settingsList,
    );

    await tester.tap(find.text('フィードバックを送る'));
    await tester.pumpAndSettle();
    expect(find.byType(FeedbackPage), findsOneWidget);
    // 何も書いていなければ送れない。
    final sendButton = find.widgetWithText(TextButton, '送信');
    expect(tester.widget<TextButton>(sendButton).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '  通知の時間を選びたい  ');
    await tester.pump();
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    expect(feedbackRepository.sent, ['通知の時間を選びたい']);
    expect(find.byType(FeedbackPage), findsNothing);
    expect(find.byType(MyPage), findsOneWidget);
    expect(find.text('フィードバックを送りました。ありがとうございます'), findsOneWidget);
  });

  testWidgets('フィードバックを送れなかったら、書いた内容を残してページに残る', (tester) async {
    final feedbackRepository = FakeFeedbackRepository()..fails = true;
    await _openMyPage(tester, feedbackRepository: feedbackRepository);
    await tester.scrollUntilVisible(
      find.text('バージョン'),
      200,
      scrollable: _settingsList,
    );
    await tester.tap(find.text('フィードバックを送る'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '通知の時間を選びたい');
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, '送信'));
    await tester.pumpAndSettle();

    expect(find.byType(FeedbackPage), findsOneWidget);
    expect(find.text('通知の時間を選びたい'), findsOneWidget);
    expect(find.text('送信できませんでした。もう一度お試しください'), findsOneWidget);
  });

  testWidgets('ログアウトを確かめると、通知の送り先から外してウェルカム画面に戻る', (tester) async {
    final authenticationRepository = FakeAuthenticationRepository(
      initial: const Authentication(isSignedIn: true),
    );
    final pushTokenRepository = FakePushTokenRepository(
      authenticationRepository,
    );
    await _openMyPage(
      tester,
      authenticationRepository: authenticationRepository,
      pushTokenRepository: pushTokenRepository,
    );
    await tester.scrollUntilVisible(
      find.text('ログアウト'),
      200,
      scrollable: _settingsList,
    );

    await tester.tap(find.text('ログアウト'));
    await tester.pumpAndSettle();
    expect(find.text('ログアウトしますか？'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'ログアウト'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
    // サーバーに頼むにはサインインしている必要があるので、サインアウトより先に外す。
    expect(pushTokenRepository.unregisteredWhileSignedIn, [true]);
  });

  testWidgets('キャンセルすると、ログアウトせずにマイページに残る', (tester) async {
    await _openMyPage(tester);
    await tester.scrollUntilVisible(
      find.text('ログアウト'),
      200,
      scrollable: _settingsList,
    );

    await tester.tap(find.text('ログアウト'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    expect(find.text('ログアウトしますか？'), findsNothing);
    expect(find.byType(MyPage), findsOneWidget);
  });
}
