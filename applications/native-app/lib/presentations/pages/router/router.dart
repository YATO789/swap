import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:swap/domains/app_update/app_update.dart';
import 'package:swap/presentations/providers/authentication_notifier.dart';
import 'package:swap/presentations/providers/diary_book_notifier.dart';
import 'package:swap/presentations/providers/profile_notifier.dart';

import '../cover_decoration_page/cover_decoration_page.dart';
import '../create_diary_book_page/create_diary_book_page.dart';
import '../diary_book_info_page/diary_book_info_page.dart';
import '../diary_book_page/diary_book_page.dart';
import '../diary_detail_page/diary_detail_page.dart';
import '../diary_editor_page/diary_editor_page.dart';
import '../feedback_page/feedback_page.dart';
import '../home_page/home_page.dart';
import '../my_page/my_page.dart';
import '../onboarding_page/onboarding_page.dart';
import '../splash_page/splash_page.dart';
import '../update_page/update_page.dart';
import '../welcome_page/welcome_page.dart';
import 'open_book_page.dart';
import '../../providers/app_update_notifier.dart';

part '_generated/router.g.dart';

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
  const DiaryBookRoute({required this.id, this.$extra});

  final String id;

  /// ホームで押した表紙。あれば、その表紙をめくって開く。
  final DiaryBookOrigin? $extra;

  // 画面の中ほどの左右スワイプは日付の移動に使うので、戻るのは画面の端からだけにする。
  // 表紙から開かないとき（通知から開いたときなど）は、端から戻れるよう iOS の標準の画面遷移で開く
  // （_materialPage を参照）。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final page = DiaryBookPage(diaryBookId: id);
    final origin = $extra;
    if (origin == null) return _materialPage(state, page);
    return openBookPage(key: state.pageKey, origin: origin, child: page);
  }
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

/// [id] の日記帳の表紙（名前・色・飾り）を編集するページ。
@TypedGoRoute<CoverDecorationRoute>(path: '/diary-books/:id/cover')
class CoverDecorationRoute extends GoRouteData with $CoverDecorationRoute {
  const CoverDecorationRoute({required this.id});

  final String id;

  // 表紙の上のドラッグを戻るスワイプに取られないよう、下から出てくるモーダルにする。
  // 閉じるボタンで閉じ、書きかけなら確かめる。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: state.pageKey,
      fullscreenDialog: true,
      child: CoverDecorationPage(diaryBookId: id),
    );
  }
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

  // 画面の中ほどの左右スワイプはほかの人の日記へめくるのに使うので、戻るのは画面の端からだけにする。
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _materialPage(
      state,
      DiaryDetailPage(diaryBookId: id, date: date, initialAuthorId: author),
    );
  }
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

@TypedGoRoute<FeedbackRoute>(path: '/me/feedback')
class FeedbackRoute extends GoRouteData with $FeedbackRoute {
  const FeedbackRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _materialPage(state, const FeedbackPage());
  }
}

/// iOS では標準の画面遷移で開き、画面の左端から右にスワイプして戻れるページ。
///
/// go_router は `build` だけのページを、アプリが material_ui の MaterialApp のときだけ MaterialPage で開く。
/// このアプリは Flutter の MaterialApp を使っているので、`build` だけだと遷移のアニメーションも戻るスワイプもないページになる。
/// push で開くページは、これで MaterialPage を明示する。
Page<void> _materialPage(GoRouterState state, Widget child) {
  return MaterialPage(key: state.pageKey, child: child);
}
