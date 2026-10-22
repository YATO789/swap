import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructures/repositories/push_token_repository.dart';
import 'authentication_helper.dart';

part '_generated/push_token_helper.g.dart';

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
@Riverpod(keepAlive: true, name: 'pushTokenProvider')
class PushTokenHelper extends _$PushTokenHelper {
  @override
  Future<void> build() async {
    if (!ref.watch(authenticationProvider).isLoginApp) return;

    // onDispose の中では ref を使えないので、先に取り出しておく。
    final repository = ref.read(pushTokenRepositoryProvider);
    final subscription = repository.onTokenRefresh.listen(
      (token) => _register(repository, token),
    );
    ref.onDispose(() {
      subscription.cancel();
      // サインアウトしてサインイン状態が変わったときにここに来る。
      unawaited(repository.deleteToken().catchError(_logFailure));
    });

    await repository.requestPermission();
    final token = await repository.fetchToken();
    if (token != null) await _register(repository, token);
  }

  /// アプリを開いたら呼び、この端末の未読数を 0 に戻す。アイコンのバッジは iOS 側（SceneDelegate）で消す。
  Future<void> resetUnreadCount() async {
    if (!ref.read(authenticationProvider).isLoginApp) return;
    try {
      await ref.read(pushTokenRepositoryProvider).resetUnreadCount();
    } on Object catch (e, stackTrace) {
      _logFailure(e, stackTrace);
    }
  }

  Future<void> _register(PushTokenRepository repository, String token) async {
    try {
      await repository.register(token);
    } on Object catch (e, stackTrace) {
      _logFailure(e, stackTrace);
    }
  }

  void _logFailure(Object error, StackTrace stackTrace) {
    debugPrint('プッシュ通知の送り先を更新できませんでした: $error\n$stackTrace');
  }
}
