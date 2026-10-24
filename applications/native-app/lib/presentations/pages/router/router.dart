import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:swap/domains/app_update/app_update.dart';
import 'package:swap/presentations/providers/authentication_notifier.dart';
import 'package:swap/presentations/providers/diary_book_notifier.dart';
import 'package:swap/presentations/providers/profile_notifier.dart';

import '../create_diary_book_page/create_diary_book_page.dart';
import '../diary_book_info_page/diary_book_info_page.dart';
import '../diary_book_page/diary_book_page.dart';
import '../diary_detail_page/diary_detail_page.dart';
import '../diary_editor_page/diary_editor_page.dart';
import '../home_page/home_page.dart';
import '../my_page/my_page.dart';
import '../onboarding_page/onboarding_page.dart';
import '../profile_edit_page/profile_edit_page.dart';
import '../splash_page/splash_page.dart';
import '../update_page/update_page.dart';
import '../welcome_page/welcome_page.dart';
import '../../providers/app_update_notifier.dart';

part '_generated/router.g.dart';

/// アプリの画面遷移。アップデートの要否、サインイン状態とプロフィールの有無で出す画面を決める。
///
/// - アップデートしないと使えない: アップデートの画面
/// - サインインしていない: ウェルカム画面
/// - プロフィールを読んでいる: スプラッシュ画面
/// - プロフィールがまだない: オンボーディング画面
/// - それ以外: ホーム
///
/// 状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // ルーターは作り直さず、状態が変わったことだけを伝える。値に意味はない。
  final refresh = ValueNotifier(0);
  ref
    ..listen(appUpdateProvider, (_, _) => refresh.value++)
    ..listen(authenticationProvider, (_, _) => refresh.value++)
    ..listen(profileProvider, (_, _) => refresh.value++);

  final home = const HomeRoute().location;
  final welcome = const WelcomeRoute().location;
  final splash = const SplashRoute().location;
  final onboarding = const OnboardingRoute().location;
  final update = const UpdateRoute().location;

  final router = GoRouter(
    initialLocation: home,
    refreshListenable: refresh,
    redirect: (_, state) {
      String? goTo(String path) => state.matchedLocation == path ? null : path;

      // 確かめている間や確かめられなかったときは、使えるままにする。
      if (ref.read(appUpdateProvider).value == AppUpdate.required) {
        return goTo(update);
      }
      if (!ref.read(authenticationProvider).isSignedIn) {
        return goTo(welcome);
      }
      final profile = ref.read(profileProvider);
      if (profile.isLoading || profile.hasError) return goTo(splash);
      if (profile.value == null) return goTo(onboarding);

      final isEntrance = [
        welcome,
        splash,
        onboarding,
        update,
      ].contains(state.matchedLocation);
      return isEntrance ? home : null;
    },
    routes: $appRoutes,
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
}

/// 起動直後の画面を消して、最初の画面を見せてよいか。
///
/// [router] の redirect と同じ順に、行き先の画面が中身を出せるようになったかを見る。
/// ホームは日記帳の一覧を読み終えるまで待ち、読んでいる間の表示を起動直後の画面で隠す。
/// 読めなかったときは、やり直すボタンを見せるために消す。
@riverpod
bool firstScreenReady(Ref ref) {
  if (ref.watch(appUpdateProvider).value == AppUpdate.required) {
    return true;
  }
  if (!ref.watch(authenticationProvider).isSignedIn) return true;
  final profile = ref.watch(profileProvider);
  if (profile.hasError) return true;
  if (profile.isLoading) return false;
  if (profile.value == null) return true;
  return !ref.watch(diaryBookProvider).isLoading;
}

/// 日付を URL に `2026-10-13` の形で載せる。
String _encodeDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

DateTime _decodeDate(String value) => DateTime.parse(value);

// $appRoutes はここに書いた順に並び、上から順に当てはめる。

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<WelcomeRoute>(path: '/welcome')
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomePage();
}

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingPage();
}

@TypedGoRoute<UpdateRoute>(path: '/update')
class UpdateRoute extends GoRouteData with $UpdateRoute {
  const UpdateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const UpdatePage();
}

/// 日記帳を作るページ。作った日記帳を返す。
@TypedGoRoute<CreateDiaryBookRoute>(path: '/diary-books/new')
class CreateDiaryBookRoute extends GoRouteData with $CreateDiaryBookRoute {
  const CreateDiaryBookRoute();

  // 下から出てくるモーダルにして、キャンセルで閉じる。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: const CreateDiaryBookPage(),
      );
}

/// [id] の日記帳のページ。
// /diary-books/new に当たらないよう、日記帳を作るページより後に置く。
@TypedGoRoute<DiaryBookRoute>(path: '/diary-books/:id')
class DiaryBookRoute extends GoRouteData with $DiaryBookRoute {
  const DiaryBookRoute({required this.id});

  final String id;

  // 画面の中ほどの左右スワイプは日付の移動に使うので、戻るのは画面の端からだけにする。
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DiaryBookPage(diaryBookId: id);
}

/// [id] の日記帳の情報ページ。
@TypedGoRoute<DiaryBookInfoRoute>(path: '/diary-books/:id/info')
class DiaryBookInfoRoute extends GoRouteData with $DiaryBookInfoRoute {
  const DiaryBookInfoRoute({required this.id});

  final String id;

  // 端からだけでなく、画面のどこからでも右にスワイプして戻れるようにする。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SwipeablePage(
        key: state.pageKey,
        builder: (_) => DiaryBookInfoPage(diaryBookId: id),
      );
}

/// [id] の日記帳の [date] の日記を読むページ。最初は [author] の日記を開く。
@TypedGoRoute<DiaryDetailRoute>(path: '/diary-books/:id/diaries/:date')
class DiaryDetailRoute extends GoRouteData with $DiaryDetailRoute {
  const DiaryDetailRoute({
    required this.id,
    @TypedQueryParameter(encoder: _encodeDate, decoder: _decodeDate)
    required this.date,
    required this.author,
  });

  final String id;
  final DateTime date;
  final String? author;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DiaryDetailPage(diaryBookId: id, date: date, initialAuthorId: author);
}

/// 自分の [date] の日記を書くページ。[diaryBook] が null なら参加している日記帳すべてに書く。
@TypedGoRoute<DiaryEditorRoute>(path: '/diaries/write')
class DiaryEditorRoute extends GoRouteData with $DiaryEditorRoute {
  const DiaryEditorRoute({
    @TypedQueryParameter(encoder: _encodeDate, decoder: _decodeDate)
    required this.date,
    this.diaryBook,
  });

  final DateTime date;
  final String? diaryBook;

  // 下から出てくるモーダルにして、閉じるボタンで閉じる。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: DiaryEditorPage(date: date, diaryBookId: diaryBook),
      );
}

@TypedGoRoute<MyPageRoute>(path: '/me')
class MyPageRoute extends GoRouteData with $MyPageRoute {
  const MyPageRoute();

  // 端からだけでなく、画面のどこからでも右にスワイプして戻れるようにする。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SwipeablePage(key: state.pageKey, builder: (_) => const MyPage());
}

@TypedGoRoute<ProfileEditRoute>(path: '/me/profile')
class ProfileEditRoute extends GoRouteData with $ProfileEditRoute {
  const ProfileEditRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileEditPage();
}
