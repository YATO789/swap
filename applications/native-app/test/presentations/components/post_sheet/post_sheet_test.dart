import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/track.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/presentations/components/post_button.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fake_stores.dart';
import '../../../helpers/pump_app.dart';

const _university = DiaryBook(
  id: 'university',
  name: '大学',
  inviteCode: 'UNI482',
  memberCount: 5,
);

const _family = DiaryBook(
  id: 'family',
  name: '家族',
  inviteCode: 'FAM482',
  memberCount: 3,
);

/// 曲の検索で見つかる曲。
final _track = Track(
  id: 'track1',
  title: '夜の終わりのバス停',
  artist: 'しずくの森',
  album: '遠回り',
  duration: const Duration(minutes: 3, seconds: 48),
  storeUrl: Uri.parse('https://music.apple.com/jp/album/1?i=1'),
);

/// 曲を探すシートを開いたときに出る、人気の曲。
final _popularTrack = Track(
  id: 'track2',
  title: '十一月の窓',
  artist: 'あさぎ',
  album: '十一月の窓 - Single',
  duration: const Duration(minutes: 4, seconds: 2),
  storeUrl: Uri.parse('https://music.apple.com/jp/album/2?i=2'),
);

/// 書き込みバーを置いて、押して投稿シートを開く。前に [savedIds] の日記帳を選んだことにする。
/// 曲を探すシートには、人気の曲として [popularTracks] を出す。
/// [postRepository] を渡せば、それを使う。
Future<FakePostRepository> _openSheet(
  WidgetTester tester, {
  Set<String> savedIds = const {},
  List<Track> popularTracks = const [],
  FakePostRepository? postRepository,
}) async {
  postRepository ??= FakePostRepository()..popularTracks = popularTracks;
  postRepository.tracks = [_track];
  await tester.pumpApp(
    const Scaffold(bottomNavigationBar: PostButton()),
    preferencesStore: FakePreferencesStore(postDiaryBookIds: {...savedIds}),
    overrides: [
      authenticationRepositoryProvider.overrideWithValue(
        FakeAuthenticationRepository(
          initial: const Authentication(isSignedIn: true),
        ),
      ),
      diaryBookRepositoryProvider.overrideWithValue(
        FakeDiaryBookRepository([_university, _family]),
      ),
      postRepositoryProvider.overrideWithValue(postRepository),
    ],
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('ひとこと'));
  await tester.pumpAndSettle();
  return postRepository;
}

FilledButton _submitButton(WidgetTester tester) =>
    tester.widget(find.widgetWithText(FilledButton, '記録する'));

void main() {
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
    final postRepository = await _openSheet(tester, savedIds: {'family'});

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

    await tester.tap(find.text('破棄する'));
    await tester.pumpAndSettle();
    expect(find.text('共有する日記帳'), findsNothing);
  });

  testWidgets('曲を探してつけ、記録と一緒に書く', (tester) async {
    final postRepository = await _openSheet(tester, savedIds: {'family'});

    await tester.enterText(find.byType(TextField), '帰り道');
    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'しずく');
    // 打つのが止まってから探しに行く。
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 曲を押しただけでは選ばれず、下のバーに出る。
    await tester.tap(find.text('夜の終わりのバス停'));
    await tester.pumpAndSettle();
    expect(find.text('夜の終わりのバス停'), findsNWidgets(2));
    expect(find.byTooltip('夜の終わりのバス停をつける'), findsOneWidget);

    // バーの → で選ぶ。
    await tester.tap(find.byTooltip('夜の終わりのバス停をつける'));
    await tester.pumpAndSettle();

    // つけた曲がボタンの場所に出る。
    expect(find.text('夜の終わりのバス停'), findsOneWidget);
    expect(find.text('曲をつける'), findsNothing);

    await tester.tap(find.text('記録する'));
    await tester.pumpAndSettle();

    expect(postRepository.posts, [
      Post(message: '帰り道', diaryBookIds: const ['family'], track: _track),
    ]);
  });

  testWidgets('何も打つ前は人気の曲が並び、そこから選べる', (tester) async {
    await _openSheet(tester, popularTracks: [_popularTrack]);

    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    expect(find.text('十一月の窓'), findsOneWidget);
    expect(find.text('曲名やアーティスト名で探せます'), findsNothing);

    // 打ち始めたら、検索の結果に入れ替わる。
    await tester.enterText(find.byType(TextField).last, 'バス停');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('十一月の窓'), findsNothing);
    expect(find.text('夜の終わりのバス停'), findsOneWidget);

    await tester.tap(find.byTooltip('消す'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('十一月の窓'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('十一月の窓をつける'));
    await tester.pumpAndSettle();
    expect(find.text('十一月の窓'), findsOneWidget);
    expect(find.text('曲をつける'), findsNothing);
  });

  testWidgets('人気の曲を取れなければ、探し方を出す', (tester) async {
    await _openSheet(tester);

    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    expect(find.text('曲名やアーティスト名で探せます'), findsOneWidget);
  });

  testWidgets('人気の曲を取れなかったら、次に開いたときに取り直す', (tester) async {
    final postRepository = FakePostRepository()
      ..failsPopularTracks = true
      ..popularTracks = [_popularTrack];
    await _openSheet(tester, postRepository: postRepository);

    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    expect(find.text('曲名やアーティスト名で探せます'), findsOneWidget);

    // 閉じて、取れるようになってから開き直す。
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    postRepository.failsPopularTracks = false;
    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    expect(find.text('十一月の窓'), findsOneWidget);
  });

  testWidgets('つけた曲を押すと、その曲名で探した状態で開く', (tester) async {
    await _openSheet(tester, popularTracks: [_popularTrack]);

    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('十一月の窓'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('十一月の窓をつける'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('十一月の窓'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField).last);
    expect(field.controller!.text, '十一月の窓');
  });

  testWidgets('つけた曲は × で外せる', (tester) async {
    await _openSheet(tester);

    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'バス停');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('夜の終わりのバス停'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('夜の終わりのバス停をつける'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('曲を外す'));
    await tester.pumpAndSettle();
    expect(find.text('夜の終わりのバス停'), findsNothing);
    expect(find.text('曲をつける'), findsOneWidget);
  });

  testWidgets('合う曲がなければ、見つからなかったと出す', (tester) async {
    await _openSheet(tester);

    await tester.tap(find.text('曲をつける'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'zzz');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('「zzz」に合う曲は見つかりませんでした'), findsOneWidget);
  });
}
