import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/screens/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'UNI482',
  memberCount: 3,
);

const _members = [
  DiaryBookMember(userId: 'me', displayName: '彩人'),
  DiaryBookMember(userId: 'mio', displayName: '美緒'),
  DiaryBookMember(userId: 'ken', displayName: '健太'),
];

/// サインインした状態のホームから、大学の日記帳を開く。
/// [members] を渡せば、開いたあとに書き換えてメンバーの変化を試せる。
Future<void> _openDiaryBook(
  WidgetTester tester, {
  List<Diary> diaries = const [],
  List<TimelinePost> posts = const [],
  Map<String, List<DiaryBookMember>>? members,
}) async {
  // タイムラインが画面に収まるよう、縦長の画面にする。
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferencesStoreProvider.overrideWithValue(FakePreferencesStore()),
        openedNotificationRepositoryProvider.overrideWithValue(
          FakeOpenedNotificationRepository(),
        ),
        authenticationRepositoryProvider.overrideWithValue(
          FakeAuthenticationRepository(
            initial: const Authentication(isLoginApp: true),
          ),
        ),
        profileRepositoryProvider.overrideWithValue(
          FakeProfileRepository(
            profile: const Profile(id: 'me', displayName: '彩人'),
          ),
        ),
        diaryBookRepositoryProvider.overrideWithValue(
          FakeDiaryBookRepository([
            _university,
          ], members: members ?? {_university.id: _members}),
        ),
        diaryRepositoryProvider.overrideWithValue(
          FakeDiaryRepository({_university.id: diaries}),
        ),
        postRepositoryProvider.overrideWithValue(
          FakePostRepository(
            timelinePosts: {
              _university.id: [...posts],
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
}

void main() {
  final today = diaryDateOf(DateTime.now());

  testWidgets('ホームで日記帳を押すと、日記帳のページが開く', (tester) async {
    await _openDiaryBook(tester);

    expect(find.byType(DiaryBookPage), findsOneWidget);
    // 見出しの下に、今日の日付を「10月3日 金曜日」の形で出す。
    expect(
      find.textContaining('${today.month}月${today.day}日 '),
      findsOneWidget,
    );
    expect(find.byTooltip('日付を選ぶ'), findsOneWidget);
  });

  testWidgets('その日の日記と記録が出て、読めない日記は伏せてある', (tester) async {
    await _openDiaryBook(
      tester,
      diaries: [
        Diary(
          id: 'd1',
          authorId: 'mio',
          date: today,
          writtenAt: DateTime.now(),
        ),
        Diary(
          id: 'd2',
          authorId: 'me',
          date: today,
          writtenAt: DateTime.now(),
          title: '',
          body: '今日はゼミの発表だった',
        ),
      ],
      posts: [
        TimelinePost(
          id: 'p1',
          authorId: 'ken',
          message: '図書館で勉強中',
          postedAt: diaryDayStartOf(today),
        ),
      ],
    );

    expect(find.text('今日はゼミの発表だった'), findsOneWidget);
    expect(find.text('この日記帳に今日の日記を書くと読めます'), findsOneWidget);
    expect(find.text('図書館で勉強中'), findsOneWidget);
  });

  testWidgets('今の時間の欄の自分のカードから、この日記帳に記録できる', (tester) async {
    await _openDiaryBook(tester);

    // 今日を見ているので、今の時間の欄にメンバー全員が出る。
    expect(find.text('美緒'), findsOneWidget);
    expect(find.text('健太'), findsOneWidget);
    // 自分もまだ記録していなければ、ほかの人と同じく「まだ記録がありません」と出す。
    expect(find.text('まだ記録がありません'), findsNWidgets(3));

    await tester.tap(find.widgetWithText(InkWell, '彩人'));
    await tester.pumpAndSettle();
    expect(find.text('大学に記録します'), findsOneWidget);
    expect(find.text('共有する日記帳'), findsNothing);

    await tester.enterText(find.byType(TextField), 'カフェで勉強中');
    await tester.pump();
    await tester.tap(find.text('記録する'));
    await tester.pumpAndSettle();

    expect(find.text('カフェで勉強中'), findsOneWidget);
    expect(find.text('記録しました'), findsOneWidget);
  });

  testWidgets('カレンダーでほかの日を選ぶと、その日を表示する', (tester) async {
    await _openDiaryBook(
      tester,
      posts: [
        TimelinePost(
          id: 'p1',
          authorId: 'mio',
          message: '昨日の記録',
          postedAt: diaryDayStartOf(today).subtract(const Duration(hours: 1)),
        ),
      ],
    );
    expect(find.text('昨日の記録'), findsNothing);

    final yesterday = DateTime(today.year, today.month, today.day - 1);
    await tester.tap(find.byTooltip('日付を選ぶ'));
    await tester.pumpAndSettle();
    // 昨日が先月なら、前の月に戻してから選ぶ。
    if (yesterday.month != today.month) {
      await tester.tap(find.byTooltip('前の月'));
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.bySemanticsLabel(RegExp('^${yesterday.month}月${yesterday.day}日')),
    );
    await tester.pumpAndSettle();

    expect(find.text('昨日の記録'), findsOneWidget);
    // 今日ではないので、今の時間の欄は出ない。
    expect(find.text('まだ記録がありません'), findsNothing);
  });

  testWidgets('開いている間に外されたら、読み直したときに知らせてホームに戻る', (tester) async {
    final members = {_university.id: _members};
    await _openDiaryBook(tester, members: members);

    // 外されると、RLS でメンバーが1人も読めなくなる。
    members[_university.id] = [];
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(find.text('「大学」は見られなくなりました'), findsOneWidget);

    await tester.tap(find.text('ホームに戻る'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsNothing);
    expect(find.text('大学'), findsNothing);
    expect(find.text('日記帳を作る'), findsOneWidget);
  });
}
