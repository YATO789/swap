import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/messaging_datasource.g.dart';

@riverpod
MessagingDatasource messagingDatasource(Ref ref) {
  return MessagingDatasource(FirebaseMessaging.instance);
}

/// 通知の許可と端末の FCM トークンを Firebase から受け取る。
class MessagingDatasource {
  const MessagingDatasource(this._messaging);

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

  /// この端末の FCM トークン取得
  Future<String?> fetchToken() async {
    // APNs のトークンがないうちに getToken を呼ぶと例外になる。届けば onTokenRefresh で受け取れる。
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await _messaging.getAPNSToken() == null) {
      return null;
    }
    return _messaging.getToken();
  }

  /// FCMトークンが新しく発行されるたびに流れる。
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// この端末の FCM トークンを無効にする。古いトークンには送っても届かなくなる。
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}
