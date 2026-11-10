import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/notification/notification_permission.dart';
import 'package:swap/infrastructures/repositories/notification_permission_repository.dart';
import 'package:swap/usecases/sync_diary_reminder_usecase.dart';

import '../helpers/fake_repositories.dart';

/// 端末に聞かず、[permission] を今の許可の状態として返す。
class _FakeNotificationPermissionRepository
    implements NotificationPermissionRepository {
  _FakeNotificationPermissionRepository(this.permission);

  final NotificationPermission permission;

  @override
  Future<NotificationPermission> fetch() async {
    return permission;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  late FakeDiaryReminderRepository reminders;

  /// 許可の状態を [permission]、書いた日記を [diaries] にして合わせ直し、予約した時刻を返す。
  Future<List<DateTime>> sync({
    bool enabled = true,
    TimeOfDay time = const TimeOfDay(hour: 21, minute: 0),
    NotificationPermission permission = NotificationPermission.granted,
    Map<String, List<Diary>> diaries = const {},
  }) async {
    reminders = FakeDiaryReminderRepository()..scheduled = [DateTime(2000)];
    await SyncDiaryReminderUseCase(
      reminders,
      FakeDiaryRepository(diaries),
      _FakeNotificationPermissionRepository(permission),
    )(enabled: enabled, time: time, body: '日記を書こう');
    return reminders.scheduled;
  }

  Diary myDiaryOn(DateTime date) {
    return Diary(id: 'd1', authorId: 'me', date: date, writtenAt: date);
  }

  test('オフにしていれば、予約を取り消す', () async {
    expect(await sync(enabled: false), isEmpty);
  });

  test('通知が許可されていなければ、予約を取り消す', () async {
    expect(await sync(permission: NotificationPermission.denied), isEmpty);
    expect(
      await sync(permission: NotificationPermission.notDetermined),
      isEmpty,
    );
  });

  test('この先の毎日、選んだ時刻に1件ずつ予約する', () async {
    final now = DateTime.now();
    final times = await sync(time: const TimeOfDay(hour: 21, minute: 30));

    // 今日の時刻をもう過ぎていれば、今日の分は予約しない。
    expect(
      times.length,
      inInclusiveRange(
        SyncDiaryReminderUseCase.days - 1,
        SyncDiaryReminderUseCase.days,
      ),
    );
    expect(times.every((time) => time.isAfter(now)), isTrue);
    expect(times.every((time) => time.hour == 21 && time.minute == 30), isTrue);
    expect({for (final time in times) diaryDateOf(time)}.length, times.length);
  });

  test('今日の日記をどれか1冊に書いていれば、今日の分は予約しない', () async {
    final today = diaryToday();
    final times = await sync(
      diaries: {
        'family': [myDiaryOn(today)],
      },
    );

    expect(times, isNotEmpty);
    expect(times.any((time) => diaryDateOf(time) == today), isFalse);
  });

  test('朝4時より前の時刻は、その日の日記の分として暦の上では翌日に予約する', () async {
    final today = diaryToday();
    final times = await sync(
      time: const TimeOfDay(hour: 1, minute: 0),
      diaries: {
        'family': [myDiaryOn(today)],
      },
    );

    // 今日の日記は書いたので、明日の日記の分（暦では明後日の1時）から予約する。
    expect(times.first, DateTime(today.year, today.month, today.day + 2, 1));
    expect(times.any((time) => diaryDateOf(time) == today), isFalse);
  });
}
