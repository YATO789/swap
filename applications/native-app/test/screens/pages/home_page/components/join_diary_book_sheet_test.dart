import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/screens/components/invite_sheet.dart';
import 'package:swap/screens/pages/diary_book_page/diary_book_page.dart';
import 'package:swap/screens/pages/router/router.dart';
import 'package:swap/theme/app_theme.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/fake_stores.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'Uni4829',
  memberCount: 2,
);

const _family = DiaryBook(
  id: 'family',
  name: '家族',
  inviteCode: 'Fam2345',
  memberCount: 1,
);

const _club = DiaryBook(
  id: 'club',
  name: 'サークル',
  inviteCode: 'Clb6789',
  memberCount: maxDiaryBookMembers,
);

/// 作った人が上限を2人に下げていて、もう2人いる日記帳。
const _pair = DiaryBook(
  id: 'pair',
  name: 'ふたり',
  inviteCode: 'Pai2345',
  memberCount: 2,
  memberLimit: 2,
);

/// サインインした状態でホームを開き、招待コードで参加するシートを開く。
Future<void> _openJoinSheet(
  WidgetTester tester, {
  List<DiaryBook> joined = const [],
}) async {
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
          FakeDiaryBookRepository(
            joined,
            members: {
              _university.id: const [
                DiaryBookMember(userId: 'mio', displayName: '美緒'),
                DiaryBookMember(userId: 'ken', displayName: '健太'),
              ],
              _club.id: [
                for (var i = 0; i < maxDiaryBookMembers; i++)
                  DiaryBookMember(userId: 'member$i', displayName: 'メンバー$i'),
              ],
              _pair.id: const [
                DiaryBookMember(userId: 'mio', displayName: '美緒'),
                DiaryBookMember(userId: 'ken', displayName: '健太'),
              ],
            },
            invitable: const [_university, _family, _club, _pair],
          ),
        ),
        diaryRepositoryProvider.overrideWithValue(FakeDiaryRepository()),
        postRepositoryProvider.overrideWithValue(FakePostRepository()),
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
  if (joined.isEmpty) {
    // 日記帳がないうちは、画面の下のボタンから参加する。
    // テストの画面は低いので、ボタンが見えるまでスクロールする。
    await tester.ensureVisible(find.text('招待コードで参加'));
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
    await _openJoinSheet(tester);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('招待コードで参加'), findsWidgets);

    final confirm = find.widgetWithText(FilledButton, '確認する');
    expect(tester.widget<FilledButton>(confirm).onPressed, isNull);

    // 英数字以外は入らない。
    await tester.enterText(find.byType(TextField), 'Uni-4829');
    await tester.pump();
    expect(find.text('Uni4829'), findsOneWidget);

    await tester.tap(confirm);
    await tester.pumpAndSettle();
    // 名前は表紙と見出しの2か所に出る。
    expect(find.text('大学'), findsWidgets);
    expect(find.text('2人のメンバー'), findsOneWidget);
    expect(find.text('あと6人まで参加できます'), findsOneWidget);

    await tester.tap(find.text('この日記帳に参加する'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
    // 見出しの下に、今日の日付を「10月3日 金曜日」の形で出す。
    final today = diaryDateOf(DateTime.now());
    expect(
      find.textContaining('${today.month}月${today.day}日 '),
      findsOneWidget,
    );
  });

  testWidgets('大文字と小文字が違えば、合うコードはない', (tester) async {
    await _openJoinSheet(tester);

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
    await _openJoinSheet(tester);

    await tester.enterText(
      find.byType(TextField),
      inviteMessage(lookupAppLocalizations(const Locale('ja')), _university),
    );
    await tester.pump();
    expect(find.text('Uni4829'), findsOneWidget);

    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();
    // 名前は表紙と見出しの2か所に出る。
    expect(find.text('大学'), findsWidgets);
  });

  testWidgets('シートの外をタップすると閉じる', (tester) async {
    await _openJoinSheet(tester);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('コピーした招待メッセージを、貼り付けボタンで入れられる', (tester) async {
    await _openJoinSheet(tester);

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? {
              'text': inviteMessage(
                lookupAppLocalizations(const Locale('ja')),
                _university,
              ),
            }
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.tap(find.text('貼り付け'));
    await tester.pump();
    expect(find.text('Uni4829'), findsOneWidget);
  });

  testWidgets('満員の日記帳には参加できない', (tester) async {
    await _openJoinSheet(tester);

    await tester.enterText(find.byType(TextField), 'Clb6789');
    await tester.pump();
    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();

    expect(find.text('この日記帳は満員です（8人まで）'), findsOneWidget);
    final join = find.widgetWithText(FilledButton, 'この日記帳に参加する');
    expect(tester.widget<FilledButton>(join).onPressed, isNull);
  });

  testWidgets('上限を下げた日記帳は、その人数で満員になる', (tester) async {
    await _openJoinSheet(tester);

    await tester.enterText(find.byType(TextField), 'Pai2345');
    await tester.pump();
    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();

    expect(find.text('この日記帳は満員です（2人まで）'), findsOneWidget);
    final join = find.widgetWithText(FilledButton, 'この日記帳に参加する');
    expect(tester.widget<FilledButton>(join).onPressed, isNull);
  });

  testWidgets('満員の日記帳でも、もう参加していれば開ける', (tester) async {
    await _openJoinSheet(tester, joined: const [_club]);

    await tester.enterText(find.byType(TextField), 'Clb6789');
    await tester.pump();
    await tester.tap(find.text('確認する'));
    await tester.pumpAndSettle();

    expect(find.text('この日記帳にはもう参加しています'), findsOneWidget);
    await tester.tap(find.text('日記帳を開く'));
    await tester.pumpAndSettle();

    expect(find.byType(DiaryBookPage), findsOneWidget);
  });

  testWidgets('もう参加している日記帳なら、参加せずに開ける', (tester) async {
    await _openJoinSheet(tester, joined: const [_university]);

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
