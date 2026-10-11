import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/screens/pages/diary_detail_page/diary_detail_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  icon: '大',
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
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final diaryRepository = FakeDiaryRepository({_university.id: diaries});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
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
            [_university],
            members: {_university.id: _members},
          ),
        ),
        diaryRepositoryProvider.overrideWithValue(diaryRepository),
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
    expect(find.text('${today.month}月${today.day}日の日記'), findsOneWidget);
    expect(find.text('発表の日'), findsOneWidget);
    expect(find.text('ゼミの発表がうまくいった'), findsOneWidget);
    expect(find.text('発表の準備中'), findsOneWidget);
    // 1ページだけならページ番号は出さない。
    expect(find.text('1 / 1'), findsNothing);
  });

  testWidgets('読める日記を横にめくって読める。伏せてある日記はページにしない', (tester) async {
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

    // 自分の日記が1ページ目なので、押した美緒の日記は2ページ目になる。
    expect(find.text('2 / 2'), findsOneWidget);
    expect(find.text('美緒の日記'), findsOneWidget);
    // 人の日記には編集や削除のメニューを出さない。
    expect(find.byTooltip('メニュー'), findsNothing);

    await tester.tap(find.byTooltip('前の日記'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('自分の日記'), findsOneWidget);
    expect(find.byTooltip('メニュー'), findsOneWidget);
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
    await tester.tap(find.widgetWithText(TextButton, '削除'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
    expect(find.text('日記を削除しました'), findsOneWidget);
    expect(find.text('消す日記'), findsNothing);
    expect(repository.diaries[_university.id], isEmpty);
  });
}
