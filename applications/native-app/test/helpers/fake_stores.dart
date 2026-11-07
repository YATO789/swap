import 'package:flutter/material.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

/// 端末に保存せず、設定をメモリに覚えておく。
class FakePreferencesStore implements PreferencesStore {
  FakePreferencesStore({
    this.diaryBookPaged = true,
    Set<String>? postDiaryBookIds,
    this.postHintVisible = true,
    this.themeMode = ThemeMode.system,
    this.updateSkippedAt,
    this.notificationPermissionSkipped = false,
    this.diaryReminderEnabled = true,
    this.diaryReminderTime = const TimeOfDay(hour: 21, minute: 0),
  }) : postDiaryBookIds = postDiaryBookIds ?? {};

  bool diaryBookPaged;
  bool diaryReminderEnabled;
  TimeOfDay diaryReminderTime;
  bool notificationPermissionSkipped;
  Set<String> postDiaryBookIds;
  bool postHintVisible;
  ThemeMode themeMode;
  DateTime? updateSkippedAt;

  @override
  bool readDiaryBookPaged() => diaryBookPaged;

  @override
  Future<void> saveDiaryBookPaged(bool paged) async {
    diaryBookPaged = paged;
  }

  @override
  Set<String> readPostDiaryBookIds() => postDiaryBookIds;

  @override
  Future<void> savePostDiaryBookIds(Set<String> diaryBookIds) async {
    postDiaryBookIds = diaryBookIds;
  }

  @override
  bool readPostHintVisible() => postHintVisible;

  @override
  Future<void> savePostHintVisible(bool visible) async {
    postHintVisible = visible;
  }

  @override
  ThemeMode readThemeMode() => themeMode;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    themeMode = mode;
  }

  @override
  DateTime? readUpdateSkippedAt() => updateSkippedAt;

  @override
  Future<void> saveUpdateSkippedAt(DateTime skippedAt) async {
    updateSkippedAt = skippedAt;
  }

  @override
  bool readNotificationPermissionSkipped() => notificationPermissionSkipped;

  @override
  Future<void> saveNotificationPermissionSkipped(bool skipped) async {
    notificationPermissionSkipped = skipped;
  }

  @override
  bool readDiaryReminderEnabled() => diaryReminderEnabled;

  @override
  Future<void> saveDiaryReminderEnabled(bool enabled) async {
    diaryReminderEnabled = enabled;
  }

  @override
  TimeOfDay readDiaryReminderTime() => diaryReminderTime;

  @override
  Future<void> saveDiaryReminderTime(TimeOfDay time) async {
    diaryReminderTime = time;
  }
}
