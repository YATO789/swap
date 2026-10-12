import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part '_generated/push_token_datasource.g.dart';

@riverpod
PushTokenDatasource pushTokenDatasource(Ref ref) {
  return PushTokenDatasource(
    Supabase.instance.client,
    FirebaseMessaging.instance,
  );
}

/// 端末の FCM トークンを Firebase から受け取り、Supabase の push_tokens テーブルに送り先として保存する。
class PushTokenDatasource {
  const PushTokenDatasource(this._client, this._messaging);

  final SupabaseClient _client;
  final FirebaseMessaging _messaging;

  /// 通知を出してよいか利用者に聞く。一度答えたあとは何も出さない。
  ///
  /// アプリを開いているときに届いた通知も、iOS で出すようにする。
  Future<void> requestPermission() async {
    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// この端末の FCM トークン。iOS で APNs のトークンがまだ届いていなければ null。
  Future<String?> fetchToken() async {
    // APNs のトークンがないうちに getToken を呼ぶと例外になる。届けば onTokenRefresh で受け取れる。
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await _messaging.getAPNSToken() == null) {
      return null;
    }
    return _messaging.getToken();
  }

  /// FCM トークンが新しく発行されるたびに流れる。
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// [token] を自分の送り先として保存する。
  Future<void> register(String token) async {
    await _client.rpc<void>(
      'register_push_token',
      params: {'p_token': token},
    );
  }

  /// この端末の FCM トークンを無効にする。古いトークンには送っても届かなくなる。
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}
