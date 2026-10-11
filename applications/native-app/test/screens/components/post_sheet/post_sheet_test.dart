import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/screens/components/post_button.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/pump_app.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  icon: '大',
  inviteCode: 'UNI482',
  memberCount: 5,
);

const _family = DiaryBook(
  id: 'family',
  name: '家族',
  icon: '家',
  inviteCode: 'FAM482',
  memberCount: 3,
);

/// 書き込みバーを置いて、押して投稿シートを開く。
Future<FakePostRepository> _openSheet(WidgetTester tester) async {
  final postRepository = FakePostRepository();
  await tester.pumpApp(
    const Scaffold(bottomNavigationBar: PostButton()),
    overrides: [
      diaryBookRepositoryProvider.overrideWith(
        () => FakeDiaryBookRepository([_university, _family]),
      ),
      postRepositoryProvider.overrideWithValue(postRepository),
    ],
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('今なにしてる？'));
  await tester.pumpAndSettle();
  return postRepository;
}

FilledButton _submitButton(WidgetTester tester) =>
    tester.widget(find.widgetWithText(FilledButton, '記録する'));

void main() {
  // 選んだ日記帳はシートを閉じても覚えているので、テストの順番に意味がある。

  testWidgets('書いて日記帳を選ぶまで記録できない', (tester) async {
    await _openSheet(tester);

    expect(find.text('共有する日記帳'), findsOneWidget);
    expect(_submitButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'カフェで勉強中');
    await tester.pump();
    expect(_submitButton(tester).onPressed, isNull);

    await tester.tap(find.text('家族'));
    await tester.pump();
    expect(_submitButton(tester).onPressed, isNotNull);
  });

  testWidgets('記録すると選んだ日記帳に出して閉じる', (tester) async {
    final postRepository = await _openSheet(tester);

    await tester.enterText(find.byType(TextField), ' カフェで勉強中 ');
    // 前に選んだ家族は選ばれたまま。大学も足す。
    await tester.tap(find.text('大学'));
    await tester.pump();
    await tester.tap(find.text('記録する'));
    await tester.pumpAndSettle();

    expect(postRepository.posts, const [
      Post(message: 'カフェで勉強中', diaryBookIds: ['university', 'family']),
    ]);
    expect(find.text('共有する日記帳'), findsNothing);
  });

  testWidgets('書きかけで閉じようとすると、破棄するか聞く', (tester) async {
    await _openSheet(tester);

    await tester.enterText(find.byType(TextField), 'カフェで勉強中');
    await tester.pump();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('入力内容を破棄しますか？'), findsOneWidget);

    await tester.tap(find.text('破棄'));
    await tester.pumpAndSettle();
    expect(find.text('共有する日記帳'), findsNothing);
  });
}
