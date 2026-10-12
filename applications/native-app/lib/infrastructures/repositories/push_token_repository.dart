import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/push_token_datasource.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';

part '_generated/push_token_repository.g.dart';

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトの前に [unregister] で送り先から外し、サインアウトしたらトークンも無効にして、
/// 前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
@Riverpod(keepAlive: true)
class PushTokenRepository extends _$PushTokenRepository {
  PushTokenDatasource get _datasource => ref.read(pushTokenDatasourceProvider);

  @override
  Future<void> build() async {
    if (!ref.watch(authenticationRepositoryProvider).isLoginApp) return;

    // onDispose の中では ref を使えないので、先に取り出しておく。
    final datasource = _datasource;
    final subscription = datasource.onTokenRefresh.listen(_register);
    ref.onDispose(() {
      subscription.cancel();
      // サインアウトしてサインイン状態が変わったときにここに来る。
      unawaited(datasource.deleteToken().catchError(_logFailure));
    });

    await _datasource.requestPermission();
    final token = await _datasource.fetchToken();
    if (token != null) await _register(token);
  }

  /// この端末を自分の送り先から外す。サーバーに聞く必要があるので、サインアウトする前に呼ぶ。
  Future<void> unregister() async {
    final token = await _datasource.fetchToken();
    if (token != null) await _datasource.unregister(token);
  }

  Future<void> _register(String token) async {
    try {
      await _datasource.register(token);
    } on Object catch (e, stackTrace) {
      _logFailure(e, stackTrace);
    }
  }

  void _logFailure(Object error, StackTrace stackTrace) {
    debugPrint('プッシュ通知の送り先を更新できませんでした: $error\n$stackTrace');
  }
}
