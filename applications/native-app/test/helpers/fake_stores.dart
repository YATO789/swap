import 'package:flutter/material.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

/// 端末に保存せず、設定をメモリに覚えておく。
class FakePreferencesStore implements PreferencesStore {
  FakePreferencesStore({
    Set<String>? postDiaryBookIds,
    this.postHintVisible = true,
    this.themeMode = ThemeMode.system,
    this.updateSkippedAt,
  }) : postDiaryBookIds = postDiaryBookIds ?? {};

  Set<String> postDiaryBookIds;
  bool postHintVisible;
  ThemeMode themeMode;
  DateTime? updateSkippedAt;

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
}
