import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/domains/reaction/reaction.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/diary_reminder_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/presentations/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/presentations/pages/diary_detail_page/diary_detail_page.dart';
import 'package:swap/presentations/pages/router/router.dart';
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
Future<FakeDiaryRepository> _openDiaryBook(
  WidgetTester tester, {
  required List<Diary> diaries,
  List<TimelinePost> posts = const [],
  List<TimelinePost> otherDiaryBookPosts = const [],
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final diaryRepository = FakeDiaryRepository({_university.id: diaries});
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
            [_university],
            members: {_university.id: _members},
          ),
        ),
        diaryRepositoryProvider.overrideWithValue(diaryRepository),
        postRepositoryProvider.overrideWithValue(
          FakePostRepository(
            timelinePosts: {
              _university.id: [...posts],
              'family': [...otherDiaryBookPosts],
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
  return diaryRepository;
}

void main() {
  final today = diaryDateOf(DateTime.now());

  Diary diary(String authorId, String body, {String title = ''}) => Diary(
    id: '$authorId-diary',
    authorId: authorId,
    date: today,
    writtenAt: diaryDayStartOf(today).add(const Duration(hours: 16)),
    title: title,
    body: body,
  );

  testWidgets('日記のカードを押すと、全文とその日の記録が出る', (tester) async {
    await _openDiaryBook(
      tester,
      diaries: [diary('me', 'ゼミの発表がうまくいった', title: '発表の日')],
      posts: [
        TimelinePost(
          id: 'p1',
          authorId: 'me',
          message: '発表の準備中',
          postedAt: diaryDayStartOf(today).add(const Duration(hours: 5)),
        ),
      ],
    );

    await tester.tap(find.text('ゼミの発表がうまくいった'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryDetailPage), findsOneWidget);
    expect(find.text('${today.month}月${today.day}日'), findsOneWidget);
    expect(find.text('発表の日'), findsOneWidget);
    expect(find.text('ゼミの発表がうまくいった'), findsOneWidget);
    expect(find.text('発表の準備中'), findsOneWidget);
    // 1ページだけならページ番号は出さない。
    expect(find.text('1'), findsNothing);
  });

  testWidgets(
    'iOS では画面の左端から右にスワイプすると、日記帳のページに戻る',
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    (tester) async {
      await _openDiaryBook(
        tester,
        diaries: [diary('me', '自分の日記'), diary('mio', '美緒の日記')],
      );
      await tester.tap(find.text('自分の日記'));
      await tester.pumpAndSettle();
      expect(find.byType(DiaryDetailPage), findsOneWidget);

      // 画面の中ほどからのスワイプでは戻らない。
      await tester.timedDragFrom(
        const Offset(200, 400),
        const Offset(150, 0),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DiaryDetailPage), findsOneWidget);

      await tester.timedDragFrom(
        const Offset(5, 400),
        const Offset(300, 0),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DiaryDetailPage), findsNothing);
      expect(find.byType(DiaryBookPage), findsOneWidget);
    },
  );

  testWidgets('ほかの日記帳にだけ出した記録は出さない', (tester) async {
    await _openDiaryBook(
      tester,
      diaries: [diary('me', '自分の日記'), diary('mio', '美緒の日記')],
      posts: [
        TimelinePost(
          id: 'p1',
          authorId: 'mio',
          message: '大学に出した記録',
          postedAt: diaryDayStartOf(today).add(const Duration(hours: 5)),
        ),
      ],
      otherDiaryBookPosts: [
        TimelinePost(
          id: 'p2',
          authorId: 'mio',
          message: '家族にだけ出した記録',
          postedAt: diaryDayStartOf(today).add(const Duration(hours: 6)),
        ),
      ],
    );

    await tester.tap(find.text('美緒の日記'));
    await tester.pumpAndSettle();

    expect(find.text('大学に出した記録'), findsOneWidget);
    expect(find.text('家族にだけ出した記録'), findsNothing);
  });

  testWidgets('読める日記を1人1ページにし、ページ番号を出す。伏せてある日記はページにしない', (tester) async {
    await _openDiaryBook(
      tester,
      diaries: [
        diary('mio', '美緒の日記'),
        diary('me', '自分の日記'),
        // 本文のない日記は伏せてある日記として扱われる。
        Diary(
          id: 'ken-diary',
          authorId: 'ken',
          date: today,
          writtenAt: DateTime.now(),
        ),
      ],
    );

    await tester.tap(find.text('美緒の日記'));
    await tester.pumpAndSettle();

    // 自分の日記が1ページ目なので、押した美緒の日記は2ページ目になる。伏せてある日記の3ページ目はない。
    expect(find.text('2'), findsOneWidget);
    expect(find.text('美緒の日記'), findsOneWidget);
    // 人の日記には編集や削除のメニューを出さない。
    expect(find.byTooltip('メニュー'), findsNothing);

    await tester.tap(find.byTooltip('戻る'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('自分の日記'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('自分の日記'), findsOneWidget);
    expect(find.byTooltip('メニュー'), findsOneWidget);
  });

  group('日記のリアクション', () {
    List<Reaction> mioDiaryReactions(FakeDiaryRepository repository) {
      return repository.diaries[_university.id]!
          .firstWhere((diary) => diary.authorId == 'mio')
          .reactions;
    }

    testWidgets('右下のボタンから絵文字を選ぶとチップが出て、ボタンがその絵文字になる', (tester) async {
      final repository = await _openDiaryBook(
        tester,
        diaries: [diary('me', '自分の日記'), diary('mio', '美緒の日記')],
      );
      await tester.tap(find.text('美緒の日記'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('リアクションを付ける'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('😂'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('あなたが😂'), findsOneWidget);
      expect(find.byTooltip('リアクションを変える。今は😂'), findsOneWidget);
      expect(mioDiaryReactions(repository), [
        const Reaction(userId: 'me', emoji: '😂'),
      ]);
    });

    testWidgets('チップを押すと、その絵文字で付けられて、もう一度押すと取り消せる', (tester) async {
      final repository = await _openDiaryBook(
        tester,
        diaries: [
          diary('me', '自分の日記'),
          diary('mio', '美緒の日記').copyWith(
            reactions: const [Reaction(userId: 'ken', emoji: '👏')],
          ),
        ],
      );
      await tester.tap(find.text('美緒の日記'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('健太が👏'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('健太が👏'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('健太、あなたが👏'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('健太、あなたが👏'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('健太が👏'), findsOneWidget);
      expect(find.byTooltip('リアクションを付ける'), findsOneWidget);
      expect(mioDiaryReactions(repository), [
        const Reaction(userId: 'ken', emoji: '👏'),
      ]);
    });

    testWidgets('自分の日記には、付いたリアクションだけを出してボタンは出さない', (tester) async {
      await _openDiaryBook(
        tester,
        diaries: [
          diary('me', '自分の日記').copyWith(
            reactions: const [
              Reaction(userId: 'mio', emoji: '❤️'),
              Reaction(userId: 'ken', emoji: '❤️'),
            ],
          ),
        ],
      );
      // タイムラインのカードにも出す。
      expect(find.bySemanticsLabel('美緒、健太が❤️'), findsOneWidget);

      await tester.tap(find.text('自分の日記'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('美緒、健太が❤️'), findsOneWidget);
      expect(find.byTooltip('リアクションを付ける'), findsNothing);
    });

    testWidgets('保存できなかったら、元に戻して知らせる', (tester) async {
      final repository = await _openDiaryBook(
        tester,
        diaries: [diary('me', '自分の日記'), diary('mio', '美緒の日記')],
      );
      repository.failsReactions = true;
      await tester.tap(find.text('美緒の日記'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('リアクションを付ける'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('❤️'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('あなたが❤️'), findsNothing);
      expect(find.byTooltip('リアクションを付ける'), findsOneWidget);
      expect(find.text('リアクションを保存できませんでした。もう一度お試しください'), findsOneWidget);
    });

    testWidgets('リアクションを付けて戻ると、タイムラインのカードにチップが出る', (tester) async {
      await _openDiaryBook(
        tester,
        diaries: [diary('me', '自分の日記'), diary('mio', '美緒の日記')],
      );
      await tester.tap(find.text('美緒の日記'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('リアクションを付ける'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('❤️'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('戻る'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('あなたが❤️'), findsOneWidget);
    });
  });

  testWidgets('自分の日記を消すと、日記帳のページに戻って日記が消える', (tester) async {
    final repository = await _openDiaryBook(
      tester,
      diaries: [diary('me', '消す日記')],
    );

    await tester.tap(find.text('消す日記'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('メニュー'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('削除'));
    await tester.pumpAndSettle();
    expect(find.text('日記を削除しますか？'), findsOneWidget);
    await tester.tap(find.text('削除する'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
    expect(find.text('日記を削除しました'), findsOneWidget);
    expect(find.text('消す日記'), findsNothing);
    expect(repository.diaries[_university.id], isEmpty);
  });
}
