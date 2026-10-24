import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/authentication_notifier.dart';

part '_generated/welcome_page_controller.g.dart';

/// サインインを試した結果。
enum SignInResult { succeeded, canceled, failed }

/// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。
@riverpod
class WelcomePageController extends _$WelcomePageController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  /// Apple アカウントでサインインする。
  Future<SignInResult> signInWithApple() async {
    final auth = ref.read(authenticationProvider.notifier);

    var signedIn = false;
    final result = await _run(() async {
      signedIn = await auth.signInWithApple();
    });

    if (result == SignInResult.failed) return result;
    return signedIn ? SignInResult.succeeded : SignInResult.canceled;
  }

  /// 匿名ユーザーとしてサインインする。
  Future<SignInResult> signInAnonymously() {
    final auth = ref.read(authenticationProvider.notifier);

    return _run(auth.signInAnonymously);
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
