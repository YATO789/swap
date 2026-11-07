import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/diary_reminder_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/presentations/pages/cover_decoration_page/cover_decoration_page.dart';
import 'package:swap/presentations/pages/diary_book_info_page/diary_book_info_page.dart';
import 'package:swap/presentations/pages/home_page/home_page.dart';
import 'package:swap/presentations/pages/router/router.dart';
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
/// [refreshed] は、読み直したときに返す日記帳の一覧。ほかの人が変えたことにする。
/// [initial] を渡すと、大学の日記帳をそれにする。
Future<void> _openInfo(
  WidgetTester tester, {
  bool createdByMe = false,
  List<DiaryBook>? refreshed,
  DiaryBook initial = _university,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final today = diaryDateOf(DateTime.now());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferencesStoreProvider.overrideWithValue(FakePreferencesStore()),
        openedNotificationRepositoryProvider.overrideWithValue(
          FakeOpenedNotificationRepository(),
        ),
        diaryReminderRepositoryProvider.overrideWithValue(
          FakeDiaryReminderRepository(),
        ),
        authenticationRepositoryProvider.overrideWithValue(
          FakeAuthenticationRepository(
            initial: const Authentication(isSignedIn: true),
          ),
        ),
        profileRepositoryProvider.overrideWithValue(
          FakeProfileRepository(
            profile: const Profile(id: 'me', displayName: '彩人'),
          ),
        ),
        diaryBookRepositoryProvider.overrideWithValue(
          FakeDiaryBookRepository(
            [if (createdByMe) initial.copyWith(createdBy: 'me') else initial],
            members: {_university.id: _members},
          )..refreshed = refreshed,
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
  await tester.tap(find.text('大学'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('日記帳の情報'));
  await tester.pumpAndSettle();
}

/// 情報ページ全体のスクロール。名前の入力欄の中にもスクロールがあるので、外側を選ぶ。
final _pageScrollable = find
    .descendant(
      of: find.byType(DiaryBookInfoPage),
      matching: find.byType(Scrollable),
    )
    .first;

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

  testWidgets('表紙の下の入力欄で名前を変えると、表紙にも日記帳のページにも映る', (tester) async {
    await _openInfo(tester);

    await tester.enterText(find.byType(TextField), ' ゼミ ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // 入力欄と表紙。
    expect(find.text('ゼミ'), findsNWidgets(2));

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('ゼミ'), findsOneWidget);
  });

  testWidgets('名前を書き換えると保存ボタンが出て、押すと保存して知らせる', (tester) async {
    await _openInfo(tester);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.text('「保存」か「完了」を押すと保存します'), findsOneWidget);
    // 書き換えるまでは保存ボタンを出さない。
    expect(find.text('保存'), findsNothing);

    await tester.enterText(find.byType(TextField), 'ゼミ');
    await tester.pump();
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('名前を保存しました'), findsOneWidget);
    expect(find.text('保存'), findsNothing);
    expect(find.text('ゼミ'), findsNWidgets(2));
  });

  testWidgets('保存を押さずに入力欄の外を押しても保存せず、保存ボタンは残る', (tester) async {
    await _openInfo(tester);

    await tester.enterText(find.byType(TextField), 'ゼミ');
    await tester.pump();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    expect(find.text('名前を保存しました'), findsNothing);
    expect(find.text('保存'), findsOneWidget);
    // 表紙はまだ元の名前。
    expect(find.text('大学'), findsOneWidget);
  });

  testWidgets('保存を押さずに戻ると、捨ててよいか確かめ、捨てると名前は変わらない', (tester) async {
    await _openInfo(tester);

    await tester.enterText(find.byType(TextField), 'ゼミ');
    await tester.pump();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('入力内容を破棄しますか？'), findsOneWidget);
    await tester.tap(find.text('破棄する'));
    await tester.pumpAndSettle();

    // 日記帳のページに戻り、名前は元のまま。
    expect(find.text('大学'), findsOneWidget);
    expect(find.text('ゼミ'), findsNothing);
  });

  testWidgets('名前を空にすると、元の名前に戻して何もしない', (tester) async {
    await _openInfo(tester);

    await tester.enterText(find.byType(TextField), '  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('大学'), findsNWidgets(2));
  });

  testWidgets('表紙に名前を貼っていれば、名前を変えると文字の大きさが変わらないよう幅も変える', (tester) async {
    const name = CoverSticker(isName: true, x: 0.5, y: 0.3, size: 0.2);
    await _openInfo(
      tester,
      initial: _university.copyWith(
        coverDecoration: const CoverDecoration(stickers: [name]),
      ),
    );

    await tester.enterText(find.byType(TextField), '大学のゼミ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(DiaryBookInfoPage)),
    );
    final saved =
        (await container.read(diaryBookRepositoryProvider).fetchJoined())
            .single;
    expect(saved.name, '大学のゼミ');
    // 2文字から5文字になったので、幅も広がる。
    expect(saved.coverDecoration!.stickers.single.size, greaterThan(0.4));
  });

  testWidgets('「表紙を編集」を押すと、表紙の編集ページを開く', (tester) async {
    await _openInfo(tester);

    await tester.tap(find.text('表紙を編集'));
    await tester.pumpAndSettle();

    expect(find.byType(CoverDecorationPage), findsOneWidget);
  });

  testWidgets('表紙を押しても、表紙の編集ページを開く', (tester) async {
    await _openInfo(tester);

    await tester.tap(find.bySemanticsLabel('大学の表紙、表紙を編集'));
    await tester.pumpAndSettle();

    expect(find.byType(CoverDecorationPage), findsOneWidget);
  });

  testWidgets('新しいアプリで飾った表紙は、編集ページを開かずにアップデートを促す', (tester) async {
    await _openInfo(
      tester,
      initial: _university.copyWith(
        coverDecoration: const CoverDecoration(
          version: coverDecorationVersion + 1,
          stickers: [CoverSticker(isName: true, x: 0.5, y: 0.3, size: 0.3)],
        ),
      ),
    );

    await tester.tap(find.text('表紙を編集'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookInfoPage), findsOneWidget);
    expect(find.text('表紙を編集するには、アプリをアップデートしてください'), findsOneWidget);
  });

  testWidgets('招待コードを作り直すと、新しいコードが出る', (tester) async {
    await _openInfo(tester);

    await tester.scrollUntilVisible(
      find.text('招待コードを作り直す'),
      100,
      scrollable: _pageScrollable,
    );
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

  testWidgets('作った人は人数の上限を変えられ、今の人数より少なくは選べない', (tester) async {
    await _openInfo(tester, createdByMe: true);

    expect(find.text('8人まで'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(RegExp('^人数の上限を変える')));
    await tester.pumpAndSettle();

    expect(find.text('8人まで・あと5人'), findsOneWidget);

    // 3人いるので、2人は押しても選べない。
    await tester.tap(find.bySemanticsLabel('2人'));
    await tester.pump();
    expect(find.text('8人まで・あと5人'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('3人'));
    await tester.pump();
    expect(find.text('3人まで・満員'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('5人'));
    await tester.pump();
    expect(find.text('5人まで・あと2人'), findsOneWidget);
    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    expect(find.text('5人まで'), findsOneWidget);
  });

  testWidgets('引っぱって読み直すと、ほかの人が変えた人数の上限も映る', (tester) async {
    await _openInfo(tester, refreshed: [_university.copyWith(memberLimit: 4)]);
    expect(find.text('8人まで'), findsOneWidget);

    await tester.fling(find.text('この日記を書く人'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.text('4人まで'), findsOneWidget);
  });

  testWidgets('作った人でなければ、人数の上限は見えるだけで変えられない', (tester) async {
    await _openInfo(tester);

    expect(find.text('8人まで'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('^人数の上限を変える')), findsNothing);
  });

  testWidgets('退出するとホームに戻り、一覧から日記帳が消える', (tester) async {
    await _openInfo(tester);

    await tester.scrollUntilVisible(
      find.text('日記帳を退出'),
      100,
      scrollable: _pageScrollable,
    );
    await tester.tap(find.text('日記帳を退出'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('退出する'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('「大学」から退出しました'), findsOneWidget);
    expect(find.text('大学'), findsNothing);
  });
}
