import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/screens/pages/home_page/components/invite_sheet.dart';
import 'package:swap/screens/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../../helpers/fake_repositories.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  icon: '大',
  inviteCode: 'Uni4829',
  memberCount: 2,
);

const _family = DiaryBook(
  id: 'family',
  name: '家族',
  icon: '家',
  inviteCode: 'Fam2345',
  memberCount: 1,
);

/// サインインした状態でホームを開き、招待コードで参加するダイアログを開く。
Future<void> _openJoinDialog(
  WidgetTester tester, {
  List<DiaryBook> joined = const [],
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
          () => FakeDiaryBookRepository(
            joined,
            members: {
              _university.id: const [
                DiaryBookMember(userId: 'mio', displayName: '美緒'),
                DiaryBookMember(userId: 'ken', displayName: '健太'),
              ],
            },
            invitable: const [_university, _family],
          ),
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
  if (joined.isEmpty) {
    // 日記帳がないうちは、画面の真ん中のボタンから参加する。
    await tester.tap(find.text('招待コードで参加'));
  } else {
    await tester.tap(find.byTooltip('日記帳を追加'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('招待コードで参加'));
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('コードを確かめて日記帳を見てから参加すると、その日記帳が開く', (tester) async {
    await _openJoinDialog(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('PINコード'), findsOneWidget);

    final confirm = find.widgetWithText(TextButton, '確認する');
    expect(tester.widget<TextButton>(confirm).onPressed, isNull);

    // 英数字以外は入らない。
    await tester.enterText(find.byType(TextField), 'Uni-4829');
    await tester.pump();
    expect(find.text('Uni4829'), findsOneWidget);

    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.text('大学'), findsOneWidget);
    expect(find.text('2人のメンバー'), findsOneWidget);

    await tester.tap(find.text('参加する'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
    expect(find.textContaining('今日・'), findsOneWidget);
  });

  testWidgets('大文字と小文字が違えば、合うコードはない', (tester) async {
    await _openJoinDialog(tester);

    await tester.enterText(find.byType(TextField), 'UNI4829');
    await tester.pump();
    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();

    expect(find.text('招待コードが見つかりません'), findsOneWidget);

    // コードを書き換えると、メッセージは消える。
    await tester.enterText(find.byType(TextField), 'UNI482');
    await tester.pump();
    expect(find.text('招待コードが見つかりません'), findsNothing);
  });

  testWidgets('招待メッセージを丸ごと貼り付けると、コードだけが入る', (tester) async {
    await _openJoinDialog(tester);

    await tester.enterText(find.byType(TextField), inviteMessage(_university));
    await tester.pump();
    expect(find.text('Uni4829'), findsOneWidget);

    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();
    expect(find.text('大学'), findsOneWidget);
  });

  testWidgets('キャンセルで閉じる', (tester) async {
    await _openJoinDialog(tester);

    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('もう参加している日記帳なら、参加せずに開ける', (tester) async {
    await _openJoinDialog(tester, joined: const [_university]);

    await tester.enterText(find.byType(TextField), 'Uni4829');
    await tester.pump();
    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();

    expect(find.text('この日記帳にはもう参加しています'), findsOneWidget);
    await tester.tap(find.text('日記帳を開く'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
  });
}
