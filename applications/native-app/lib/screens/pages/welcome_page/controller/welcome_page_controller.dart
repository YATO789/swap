import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helpers/authentication_helper.dart';

part '_generated/welcome_page_controller.g.dart';

/// サインインを試した結果。
enum SignInResult {
  succeeded,
  canceled,
  failed,
}

/// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。
@riverpod
class WelcomePageController extends _$WelcomePageController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  AuthenticationHelper get _authentication {
    return ref.read(authenticationProvider.notifier);
  }

  /// Apple アカウントでサインインする。
  Future<SignInResult> signInWithApple() async {
    var signedIn = false;
    final result = await _run(() async {
      signedIn = await _authentication.signInWithApple();
    });
    if (result == SignInResult.failed) return result;
    return signedIn ? SignInResult.succeeded : SignInResult.canceled;
  }

  /// 匿名ユーザーとしてサインインする。開発中の確認用。
  Future<SignInResult> signInAnonymously() {
    return _run(_authentication.signInAnonymously);
  }

  Future<SignInResult> _run(Future<void> Function() signIn) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(signIn);
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('サインインに失敗しました: $error\n$stackTrace');
      return SignInResult.failed;
    }
    return SignInResult.succeeded;
  }
}
