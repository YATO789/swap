import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/platform/local_notification_datasource.dart';

part '_generated/diary_reminder_repository.g.dart';

@riverpod
DiaryReminderRepository diaryReminderRepository(Ref ref) {
  return DiaryReminderRepository(
    ref.watch(localNotificationDatasourceProvider),
  );
}

/// 日記を書くよう知らせる通知（日記のリマインダー）を予約したり、タップを受け取ったりする。
class DiaryReminderRepository {
  const DiaryReminderRepository(this._datasource);

  final LocalNotificationDatasource _datasource;

  /// 日記のリマインダーに付けて、タップされたときに見分ける印。
  static const _payload = 'diary_reminder';

  /// 予約していたリマインダーをすべて取り消し、[times] のそれぞれに [body] の文面で予約し直す。
  Future<void> replace(List<DateTime> times, {required String body}) async {
    await _datasource.cancelAllScheduled();
    for (final time in times) {
      await _datasource.schedule(
        id: _idOf(time),
        at: time,
        body: body,
        payload: _payload,
      );
    }
  }

  /// 予約していたリマインダーをすべて取り消す。
  Future<void> cancelAll() {
    return _datasource.cancelAllScheduled();
  }

  /// 日記のリマインダーがタップされるたびに流す。
  ///
  /// リマインダーのタップでアプリが起動していれば、最初に一度流す。
  Stream<void> opened() async* {
    if (await _datasource.fetchLaunchPayload() == _payload) yield null;
    await for (final payload in _datasource.onTapped) {
      if (payload == _payload) yield null;
    }
  }

  /// 予約を日ごとに見分ける id。予約し直すときに同じ日の予約を置き換えられるよう、日付から作る。
  int _idOf(DateTime time) {
    return time.year * 10000 + time.month * 100 + time.day;
  }
}
