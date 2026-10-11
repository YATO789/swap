import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';

import '../create_diary_book_page/create_diary_book_page.dart';
import '../diary_book_page/diary_book_page.dart';
import '../home_page/home_page.dart';
import '../onboarding_page/onboarding_page.dart';
import '../splash_page/splash_page.dart';
import '../welcome_page/welcome_page.dart';

part '_generated/router.g.dart';

/// 画面のパス。
abstract final class AppRoutes {
  static const home = '/';
  static const welcome = '/welcome';
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const createDiaryBook = '/diary-books/new';
  static const diaryBook = '/diary-books/:id';

  /// [id] の日記帳のページ。
  static String diaryBookOf(String id) => '/diary-books/$id';
}

/// アプリの画面遷移。サインイン状態とプロフィールの有無で出す画面を決める。
///
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
    ..listen(authenticationRepositoryProvider, (_, _) => refresh.value++)
    ..listen(profileRepositoryProvider, (_, _) => refresh.value++);

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (_, state) {
      String? goTo(String path) => state.matchedLocation == path ? null : path;

      if (!ref.read(authenticationRepositoryProvider).isLoginApp) {
        return goTo(AppRoutes.welcome);
      }
      final profile = ref.read(profileRepositoryProvider);
      if (profile.isLoading || profile.hasError) return goTo(AppRoutes.splash);
      if (profile.value == null) return goTo(AppRoutes.onboarding);

      return switch (state.matchedLocation) {
        AppRoutes.welcome ||
        AppRoutes.splash ||
        AppRoutes.onboarding => AppRoutes.home,
        _ => null,
      };
    },
    routes: [
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomePage()),
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.createDiaryBook,
        // 下から出てくるモーダルにして、キャンセルで閉じる。
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const CreateDiaryBookPage(),
        ),
      ),
      // /diary-books/new に当たらないよう、日記帳を作るページより後に置く。
      GoRoute(
        path: AppRoutes.diaryBook,
        builder: (_, state) =>
            DiaryBookPage(diaryBookId: state.pathParameters['id']!),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
}
