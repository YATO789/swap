import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/usecase/users/authentication_usecase.dart';

import '../home_page/home_page.dart';
import '../welcome_page/welcome_page.dart';

part '_generated/router.g.dart';

/// 画面のパス。
abstract final class AppRoutes {
  static const home = '/';
  static const welcome = '/welcome';
}

/// アプリの画面遷移。サインインしていなければウェルカム画面、していればホームを出す。
///
/// サインイン状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // ルーターは作り直さず、サインイン状態の変化だけを伝える。
  final isLoginApp = ValueNotifier(
    ref.read(authenticationUsecaseProvider).isLoginApp,
  );
  ref.listen(
    authenticationUsecaseProvider,
    (_, next) => isLoginApp.value = next.isLoginApp,
  );

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: isLoginApp,
    redirect: (_, state) {
      final atWelcome = state.matchedLocation == AppRoutes.welcome;
      if (!isLoginApp.value) return atWelcome ? null : AppRoutes.welcome;
      return atWelcome ? AppRoutes.home : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomePage(),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    isLoginApp.dispose();
  });
  return router;
}
