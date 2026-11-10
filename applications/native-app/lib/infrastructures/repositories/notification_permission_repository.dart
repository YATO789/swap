import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/notification/notification_permission.dart';
import 'package:swap/infrastructures/datasources/firebase/messaging_datasource.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

part '_generated/notification_permission_repository.g.dart';

@riverpod
NotificationPermissionRepository notificationPermissionRepository(Ref ref) {
  return NotificationPermissionRepository(
    ref.watch(messagingDatasourceProvider),
    ref.watch(preferencesStoreProvider),
  );
}

/// 通知を出してよいかを利用者に聞いたり、聞かずに始めたことを覚えたりする。
class NotificationPermissionRepository {
  const NotificationPermissionRepository(this._messaging, this._store);

  final MessagingDatasource _messaging;
  final PreferencesStore _store;

  /// オンボーディングで、通知の許可を聞かずに「あとで」で始めたか。
  bool get skipped {
    return _store.readNotificationPermissionSkipped();
  }

  /// 通知を出してよいかの今の状態。聞きはしない。
  Future<NotificationPermission> fetch() async {
    return switch (await _messaging.fetchAuthorizationStatus()) {
      AuthorizationStatus.authorized ||
      AuthorizationStatus.provisional => NotificationPermission.granted,
      AuthorizationStatus.denied ||
      AuthorizationStatus.deniedPermanently => NotificationPermission.denied,
      AuthorizationStatus.notDetermined => NotificationPermission.notDetermined,
    };
  }

  /// 通知の許可を聞く。「あとで」で始めたことは忘れる。
  Future<void> request() async {
    await _store.saveNotificationPermissionSkipped(false);
    await _messaging.requestPermission();
  }

  /// 通知の許可を聞かずに始めたことを覚えておく。
  Future<void> skip() {
    return _store.saveNotificationPermissionSkipped(true);
  }

  /// アプリを開いているときに届いた通知も出すようにする。許可は聞かない。
  Future<void> showInForeground() {
    return _messaging.showNotificationsInForeground();
  }
}
