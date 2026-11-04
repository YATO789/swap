import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/opened_notification_datasource.g.dart';

@riverpod
OpenedNotificationDatasource openedNotificationDatasource(Ref ref) {
  return OpenedNotificationDatasource(FirebaseMessaging.instance);
}

/// 利用者がタップして開いたプッシュ通知を Firebase から受け取る。
class OpenedNotificationDatasource {
  const OpenedNotificationDatasource(this._messaging);

  final FirebaseMessaging _messaging;

  /// アプリが閉じていたときに通知のタップで起動したとき
  Future<RemoteMessage?> fetchInitialMessage() =>
      _messaging.getInitialMessage();

  /// アプリが裏にあるときに通知がタップされたとき。
  Stream<RemoteMessage> get onOpened => FirebaseMessaging.onMessageOpenedApp;
}
