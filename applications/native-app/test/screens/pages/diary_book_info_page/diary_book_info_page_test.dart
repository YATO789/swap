import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/infrastructures/datasources/stores/diary_book_grid_store.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/diary_book_info_page/diary_book_info_page.dart';
import 'package:swap/screens/pages/home_page/home_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'Uni4823',
  memberCount: 3,
  createdBy: 'mio',
);

const _members = [
  DiaryBookMember(userId: 'mio', displayName: '美緒'),
  DiaryBookMember(userId: 'me', displayName: '彩人'),
  DiaryBookMember(userId: 'ken', displayName: '健太'),
];

/// サインインした状態のホームから大学の日記帳を開き、情報ページを開く。
/// [createdByMe] なら、自分が大学の日記帳を作ったことにする。
Future<void> _openInfo(WidgetTester tester, {bool createdByMe = false}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final today = diaryDateOf(DateTime.now());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        diaryBookGridStoreProvider.overrideWithValue(FakeDiaryBookGridStore()),
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
          () => FakeDiaryBookRepository(
            [
              if (createdByMe)
                _university.copyWith(createdBy: 'me')
              else
                _university,
            ],
            members: {_university.id: _members},
          ),
        ),
        diaryRepositoryProvider.overrideWithValue(
          FakeDiaryRepository({
            _university.id: [
              Diary(
                id: 'd1',
                authorId: 'mio',
                date: today,
                writtenAt: DateTime.now(),
              ),
            ],
          }),
        ),
        postRepositoryProvider.overrideWithValue(
          FakePostRepository(
            timelinePosts: {
              _university.id: [
                for (final id in ['p1', 'p2'])
                  TimelinePost(
                    id: id,
                    authorId: 'ken',
                    message: '図書館で勉強中',
                    postedAt: diaryDayStartOf(today),
                  ),
              ],
            },
          ),
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
  await tester.tap(find.text('大学'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('日記帳の情報'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('日記帳のページから情報ページを開くと、メンバーと招待コードが出る', (tester) async {
    await _openInfo(tester);

    expect(find.byType(DiaryBookInfoPage), findsOneWidget);
    // 自分が先頭に来る。
    expect(
      tester.getTopLeft(find.text('彩人')).dy,
      lessThan(tester.getTopLeft(find.text('美緒')).dy),
    );
    expect(find.text('あなた'), findsOneWidget);
    expect(find.text('Uni4823'), findsOneWidget);
  });

  testWidgets('名前を変えると、情報ページにも日記帳のページにも映る', (tester) async {
    await _openInfo(tester);

    await tester.tap(find.bySemanticsLabel(RegExp('^名前を変える')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), ' ゼミ ');
    await tester.pump();
    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    expect(find.text('ゼミ'), findsNWidgets(2));

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('ゼミ'), findsOneWidget);
  });

  testWidgets('招待コードを作り直すと、新しいコードが出る', (tester) async {
    await _openInfo(tester);

    await tester.scrollUntilVisible(find.text('招待コードを作り直す'), 100);
    await tester.tap(find.text('招待コードを作り直す'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('作り直す'));
    await tester.pumpAndSettle();

    expect(find.text('Uni4823'), findsNothing);
    expect(find.text('Re23456'), findsOneWidget);
    expect(find.text('招待コードを作り直しました'), findsOneWidget);
  });

  testWidgets('作った人がほかのメンバーを外すと、一覧から消えて招待コードも変わる', (tester) async {
    await _openInfo(tester, createdByMe: true);

    // 自分の行にはメニューがない。
    expect(find.byTooltip('彩人さんのメニュー'), findsNothing);

    await tester.tap(find.byTooltip('健太さんのメニュー'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('この日記帳から外す'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('外す'));
    await tester.pumpAndSettle();

    expect(find.text('健太さんを外しました'), findsOneWidget);
    expect(find.text('健太'), findsNothing);
    expect(find.text('Re23456'), findsOneWidget);
  });

  testWidgets('作った人でなければ、メンバーを外すメニューは出ない', (tester) async {
    await _openInfo(tester);

    expect(find.byTooltip('美緒さんのメニュー'), findsNothing);
    expect(find.byTooltip('健太さんのメニュー'), findsNothing);
  });

  testWidgets('退出するとホームに戻り、一覧から日記帳が消える', (tester) async {
    await _openInfo(tester);

    await tester.scrollUntilVisible(find.text('日記帳を退出'), 100);
    await tester.tap(find.text('日記帳を退出'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('退出する'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('「大学」から退出しました'), findsOneWidget);
    expect(find.text('大学'), findsNothing);
  });
}
