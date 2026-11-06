import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/firebase/messaging_datasource.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/infrastructures/datasources/supabase/push_token/push_token_datasource.dart';

part '_generated/push_token_repository.g.dart';

@riverpod
PushTokenRepository pushTokenRepository(Ref ref) {
  return PushTokenRepository(
    ref.watch(messagingDatasourceProvider),
    ref.watch(pushTokenDatasourceProvider),
    ref.watch(preferencesStoreProvider),
  );
}

/// この端末を自分のプッシュ通知の送り先にしたり、送り先から外したりする。
class PushTokenRepository {
  const PushTokenRepository(this._messaging, this._pushTokens, this._store);

  final MessagingDatasource _messaging;
  final PushTokenDatasource _pushTokens;
  final PreferencesStore _store;

  /// FCM トークンが替わったら、新しいトークンを流す。
  Stream<String> get onTokenRefresh {
    return _messaging.onTokenRefresh;
  }

  /// オンボーディングで、通知の許可を聞かずに「あとで」で始めたか。
  bool get permissionSkipped {
    return _store.readNotificationPermissionSkipped();
  }

  /// 通知の許可を聞く。「あとで」で始めたことは忘れる。
  Future<void> requestPermission() async {
    await _store.saveNotificationPermissionSkipped(false);
    await _messaging.requestPermission();
  }

  /// 通知の許可を聞かずに始めたことを覚えておく。
  Future<void> skipPermission() {
    return _store.saveNotificationPermissionSkipped(true);
  }

  /// アプリを開いているときに届いた通知も出すようにする。
  Future<void> showNotificationsInForeground() {
    return _messaging.showNotificationsInForeground();
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
