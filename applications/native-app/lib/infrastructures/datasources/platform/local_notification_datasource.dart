import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part '_generated/local_notification_datasource.g.dart';

/// 通知のタップを受け取る口を一つにしたいので、一度作ったら破棄しない。
@Riverpod(keepAlive: true)
LocalNotificationDatasource localNotificationDatasource(Ref ref) {
  final datasource = LocalNotificationDatasource(
    FlutterLocalNotificationsPlugin(),
  );
  ref.onDispose(datasource.dispose);
  return datasource;
}

/// 端末の中で予約して出す通知（ローカル通知）を扱う。
class LocalNotificationDatasource {
  LocalNotificationDatasource(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  final _tapped = StreamController<String?>.broadcast();
  Future<void>? _initializing;
  bool _launchFetched = false;

  /// 使う前に一度だけ初期化する。通知の許可はここでは聞かない（オンボーディングとホームで聞く）。
  Future<void> _ensureInitialized() {
    return _initializing ??= _initialize();
  }

  Future<void> _initialize() async {
    tz.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        _tapped.add(response.payload);
      },
    );
  }

  /// [at] に通知を出すよう予約する。同じ [id] の予約があれば置き換える。
  /// [at] は端末のタイムゾーンの時刻として扱う。
  Future<void> schedule({
    required int id,
    required DateTime at,
    required String body,
    required String payload,
  }) async {
    await _ensureInitialized();
    // 旅行などでタイムゾーンが変わっていることがあるので、予約のたびに合わせ直す。
    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime(
        tz.local,
        at.year,
        at.month,
        at.day,
        at.hour,
        at.minute,
      ),
      body: body,
      payload: payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('diary_reminder', 'Diary reminder'),
        // アプリを開いているときも出す。
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
          presentSound: true,
        ),
      ),
      // 正確な時刻のアラームは権限がいるので使わない。数分ずれてもよい。
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// まだ出していない予約をすべて取り消す。出した通知やプッシュ通知は消さない。
  Future<void> cancelAllScheduled() async {
    await _ensureInitialized();
    await _plugin.cancelAllPendingNotifications();
  }

  /// 通知のタップでアプリが起動していれば、その通知に付けた payload を返す。
  /// 起動したときの通知でなければ null。同じ起動で二度目からは null を返す。
  Future<String?> fetchLaunchPayload() async {
    await _ensureInitialized();
    if (_launchFetched) return null;
    _launchFetched = true;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return details.notificationResponse?.payload;
  }

  /// アプリが開いているか裏にあるときに、通知がタップされたら payload を流す。
  Stream<String?> get onTapped async* {
    await _ensureInitialized();
    yield* _tapped.stream;
  }

  void dispose() {
    _tapped.close();
  }
}
