import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/infrastructures/datasources/stores/diary_book_grid_store.dart';
import 'package:swap/infrastructures/datasources/stores/post_hint_store.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/screens/pages/diary_editor_page/diary_editor_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'UNI482',
  memberCount: 2,
);

const _family = DiaryBook(
  id: 'family',
  name: '家族',
  inviteCode: 'FAM123',
  memberCount: 3,
);

/// サインインした状態でホームを開く。
Future<FakeDiaryRepository> _openHome(
  WidgetTester tester, {
  List<DiaryBook> diaryBooks = const [_university, _family],
  Map<String, List<Diary>> diaries = const {},
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final diaryRepository = FakeDiaryRepository(diaries);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        diaryBookGridStoreProvider.overrideWithValue(FakeDiaryBookGridStore()),
        postHintStoreProvider.overrideWithValue(FakePostHintStore()),
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
            diaryBooks,
            members: {
              _university.id: const [
                DiaryBookMember(userId: 'me', displayName: '彩人'),
                DiaryBookMember(userId: 'mio', displayName: '美緒'),
              ],
            },
          ),
        ),
        diaryRepositoryProvider.overrideWithValue(diaryRepository),
        postRepositoryProvider.overrideWithValue(FakePostRepository()),
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
  return diaryRepository;
}

/// 本文の入力欄。タイトルの入力欄の次にある。
Finder get _bodyField => find.byType(TextField).last;

void main() {
  final today = diaryDateOf(DateTime.now());

  testWidgets('ホームのペンから、すべての日記帳に今日の日記を書ける', (tester) async {
    final repository = await _openHome(tester);

    await tester.tap(find.byTooltip('今日の日記を書く'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryEditorPage), findsOneWidget);
    expect(find.text('${today.month}月${today.day}日の日記'), findsOneWidget);
    expect(find.bySemanticsLabel('日記を書く日記帳: すべての日記帳'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'いい日');
    await tester.enterText(_bodyField, '散歩をした');
    await tester.pump();
    await tester.tap(find.text('投稿'));
    await tester.pumpAndSettle();

    expect(find.text('日記を投稿しました'), findsOneWidget);
    expect(find.byType(DiaryEditorPage), findsNothing);
    for (final id in [_university.id, _family.id]) {
      final diary = repository.diaries[id]!.single;
      expect(diary.title, 'いい日');
      expect(diary.body, '散歩をした');
    }
  });

  testWidgets('書く日記帳を選び直すと、その日記帳に書いた日記を読み込む', (tester) async {
    await _openHome(
      tester,
      diaries: {
        _family.id: [
          Diary(
            id: 'family-diary',
            authorId: 'me',
            date: today,
            writtenAt: DateTime.now(),
            title: '',
            body: '家族に書いた日記',
          ),
        ],
      },
    );
    await tester.tap(find.byTooltip('今日の日記を書く'));
    await tester.pumpAndSettle();

    // すべての日記帳のときは、どれか1冊に書いたものを出す。
    expect(find.text('家族に書いた日記'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('日記を書く日記帳: すべての日記帳'));
    await tester.pumpAndSettle();
    expect(find.text('今日の日記: 2冊中1冊に書いた'), findsOneWidget);
    await tester.tap(find.text('大学'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('日記を書く日記帳: 大学'), findsOneWidget);
    expect(find.text('家族に書いた日記'), findsNothing);
    expect(find.text('投稿'), findsOneWidget);
  });

  testWidgets('書きかけで閉じようとすると確認が出る', (tester) async {
    await _openHome(tester);
    await tester.tap(find.byTooltip('今日の日記を書く'));
    await tester.pumpAndSettle();

    await tester.enterText(_bodyField, '書きかけ');
    await tester.pump();
    await tester.tap(find.byTooltip('閉じる'));
    await tester.pumpAndSettle();
    expect(find.text('入力内容を破棄しますか？'), findsOneWidget);

    await tester.tap(find.text('破棄する'));
    await tester.pumpAndSettle();
    expect(find.byType(DiaryEditorPage), findsNothing);
  });

  testWidgets('伏せてある日記のカードから書くと、戻ったときにその日記が読める', (tester) async {
    await _openHome(
      tester,
      diaryBooks: const [_university],
      diaries: {
        _university.id: [
          Diary(
            id: 'mio-diary',
            authorId: 'mio',
            date: today,
            writtenAt: DateTime.now(),
            title: '',
            body: '美緒の日記',
          ),
        ],
      },
    );
    await tester.tap(find.text('大学'));
    await tester.pumpAndSettle();
    expect(find.text('美緒の日記'), findsNothing);

    await tester.tap(find.text('この日記帳に今日の日記を書くと読めます'));
    await tester.pumpAndSettle();
    // 1冊しかないので、日記帳は選べない。
    expect(find.bySemanticsLabel('日記を書く日記帳: 大学'), findsOneWidget);

    await tester.enterText(_bodyField, '自分の日記');
    await tester.pump();
    await tester.tap(find.text('投稿'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
    expect(find.text('自分の日記'), findsOneWidget);
    expect(find.text('美緒の日記'), findsOneWidget);
  });
}
