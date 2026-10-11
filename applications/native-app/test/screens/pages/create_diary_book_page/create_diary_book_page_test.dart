import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/create_diary_book_page/create_diary_book_page.dart';
import 'package:swap/screens/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../helpers/fake_repositories.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  icon: '大',
  inviteCode: 'UNI482',
  memberCount: 5,
);

/// 名前を決めてサインインした状態のホームから始める。
Future<void> _pumpHome(
  WidgetTester tester, {
  List<DiaryBook> diaryBooks = const [],
}) async {
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
          () => FakeDiaryBookRepository(diaryBooks),
        ),
        diaryRepositoryProvider.overrideWithValue(FakeDiaryRepository()),
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
}

void main() {
  testWidgets('名前を入れて作成すると、作った日記帳が開き、ホームの一覧にも出る', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('日記帳を作る'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateDiaryBookPage), findsOneWidget);

    await tester.enterText(find.byType(TextField), '大学');
    await tester.pump();
    await tester.tap(find.text('作成'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateDiaryBookPage), findsNothing);
    expect(find.byType(DiaryBookPage), findsOneWidget);
    expect(find.text('大学'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('大学'), findsOneWidget);
    expect(find.text('1人'), findsOneWidget);
  });

  testWidgets('日記帳があれば、AppBar の本のアイコンからも作れる', (tester) async {
    await _pumpHome(tester, diaryBooks: [_university]);

    await tester.tap(find.byTooltip('日記帳を追加'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('日記帳を作る'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateDiaryBookPage), findsOneWidget);

    await tester.enterText(find.byType(TextField), '会社');
    await tester.pump();
    await tester.tap(find.text('作成'));
    await tester.pumpAndSettle();
    expect(find.byType(DiaryBookPage), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('大学'), findsOneWidget);
    expect(find.text('会社'), findsOneWidget);
  });

  testWidgets('名前を入れたままキャンセルすると、破棄するか聞く', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('日記帳を作る'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '大学');
    await tester.pump();

    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();
    expect(find.text('入力内容を破棄しますか？'), findsOneWidget);

    await tester.tap(find.text('破棄'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateDiaryBookPage), findsNothing);
  });
}
