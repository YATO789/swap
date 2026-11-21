import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/notification/notification_permission.dart';
import 'package:swap/infrastructures/repositories/diary_reminder_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/notification_permission_repository.dart';

part '_generated/sync_diary_reminder_usecase.g.dart';

@riverpod
SyncDiaryReminderUseCase syncDiaryReminderUseCase(Ref ref) {
  return SyncDiaryReminderUseCase(
    ref.watch(diaryReminderRepositoryProvider),
    ref.watch(diaryRepositoryProvider),
    ref.watch(notificationPermissionRepositoryProvider),
  );
}

/// 日記のリマインダーの予約を、今の設定と今日の日記に合わせ直す。
///
/// この先 [days] 日分を1日1件ずつ予約する。今日の日記をどれか1冊にでも書いていれば、今日の分は予約しない。
/// しばらくアプリを開かなければ、予約が尽きて知らせなくなる。
class SyncDiaryReminderUseCase {
  const SyncDiaryReminderUseCase(
    this._reminderRepository,
    this._diaryRepository,
    this._permissionRepository,
  );

  final DiaryReminderRepository _reminderRepository;
  final DiaryRepository _diaryRepository;
  final NotificationPermissionRepository _permissionRepository;

  static const days = 14;

  /// [enabled] でなければ予約を取り消す。[enabled] なら毎日 [time] に [body] の文面で知らせるよう予約し直す。
  Future<void> call({
    required bool enabled,
    required TimeOfDay time,
    required String body,
  }) async {
    if (!enabled ||
        await _permissionRepository.fetch() != NotificationPermission.granted) {
      await _reminderRepository.cancelAll();
      return;
    }

    final today = diaryToday();
    final now = DateTime.now();
    final wroteToday = await _wroteOn(today);
    final times = [
      for (var i = wroteToday ? 1 : 0; i < days; i++)
        _reminderTimeOf(DateTime(today.year, today.month, today.day + i), time),
    ].where((at) => at.isAfter(now)).toList();
    await _reminderRepository.replace(times, body: body);
  }

  /// 自分が [date] の日記をどれか1冊にでも書いたか。確かめられなければ書いていないことにする。
  Future<bool> _wroteOn(DateTime date) async {
    try {
      return await _diaryRepository.wroteOn(date);
    } on Object catch (e, stackTrace) {
      debugPrint('今日の日記があるか確かめられませんでした: $e\n$stackTrace');
      return false;
    }
  }

  /// [date] の日記のリマインダーを出す時刻。
  /// 日付は朝4時に切り替わるので、それより前の時刻は暦の上では翌日になる。
  DateTime _reminderTimeOf(DateTime date, TimeOfDay time) {
    final day = time.hour < diaryDayStartHour ? date.day + 1 : date.day;
    return DateTime(date.year, date.month, day, time.hour, time.minute);
  }
}
