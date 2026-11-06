import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/firebase/messaging_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/push_token/push_token_datasource.dart';

part '_generated/push_token_repository.g.dart';

@riverpod
PushTokenRepository pushTokenRepository(Ref ref) {
  return PushTokenRepository(
    ref.watch(messagingDatasourceProvider),
    ref.watch(pushTokenDatasourceProvider),
  );
}

/// この端末を自分のプッシュ通知の送り先にしたり、送り先から外したりする。
/// 通知の許可は NotificationPermissionRepository が扱う。
class PushTokenRepository {
  const PushTokenRepository(this._messaging, this._pushTokens);

  final MessagingDatasource _messaging;
  final PushTokenDatasource _pushTokens;

  /// FCM トークンが替わったら、新しいトークンを流す。
  Stream<String> get onTokenRefresh {
    return _messaging.onTokenRefresh;
  }

  /// この端末の FCM トークン。
  Future<String?> fetchToken() {
    return _messaging.fetchToken();
  }

  /// [token] を自分の送り先として保存する。
  Future<void> register(String token) {
    return _pushTokens.register(token);
  }

  /// この端末を自分の送り先から外す。サーバーに聞く必要があるので、サインアウトする前に呼ぶ。
  Future<void> unregister() async {
    final token = await _messaging.fetchToken();
    if (token != null) await _pushTokens.unregister(token);
  }

  /// この端末の FCM トークンを無効にする。
  Future<void> deleteToken() {
    return _messaging.deleteToken();
  }

  /// この端末の未読数を 0 に戻す。
  Future<void> resetUnreadCount() async {
    final token = await _messaging.fetchToken();
    if (token != null) await _pushTokens.resetUnreadCount(token);
  }
}
