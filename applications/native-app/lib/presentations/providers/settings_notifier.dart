import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/settings/settings.dart';
import '../../infrastructures/datasources/stores/preferences_store.dart';

part '_generated/settings_notifier.g.dart';

/// 設定画面で切り替える設定を持ち、変えたら端末に保存する。
/// 使う側は select で必要な項目だけを見る。
@Riverpod(name: 'settingsProvider')
class SettingsNotifier extends _$SettingsNotifier {
  PreferencesStore get _store {
    return ref.read(preferencesStoreProvider);
  }

  @override
  Settings build() {
    return Settings(
      diaryBookPaged: _store.readDiaryBookPaged(),
      postHintVisible: _store.readPostHintVisible(),
      themeMode: _store.readThemeMode(),
      diaryReminderEnabled: _store.readDiaryReminderEnabled(),
      diaryReminderTime: _store.readDiaryReminderTime(),
    );
  }

  /// 日記帳を1冊ずつ出すかを [paged] にして保存する。
  Future<void> saveDiaryBookPaged(bool paged) async {
    state = state.copyWith(diaryBookPaged: paged);
    await _store.saveDiaryBookPaged(paged);
  }

  /// 説明を出すかを [visible] にして保存する。
  Future<void> savePostHintVisible(bool visible) async {
    state = state.copyWith(postHintVisible: visible);
    await _store.savePostHintVisible(visible);
  }

  /// テーマを [mode] にして保存する。
  Future<void> saveThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _store.saveThemeMode(mode);
  }

  /// 日記のリマインダーを出すかを [enabled] にして保存する。
  Future<void> saveDiaryReminderEnabled(bool enabled) async {
    state = state.copyWith(diaryReminderEnabled: enabled);
    await _store.saveDiaryReminderEnabled(enabled);
  }

  /// 日記のリマインダーを出す時刻を [time] にして保存する。
  Future<void> saveDiaryReminderTime(TimeOfDay time) async {
    state = state.copyWith(diaryReminderTime: time);
    await _store.saveDiaryReminderTime(time);
  }
}
