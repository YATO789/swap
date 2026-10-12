import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap/infrastructures/datasources/stores/shared_preferences_store.dart';

part '_generated/theme_mode_store.g.dart';

const themeModeKey = 'theme_mode';

@riverpod
ThemeModeStore themeModeStore(Ref ref) {
  return ThemeModeStore(ref.read(sharedPreferencesProvider));
}

/// ライト・ダーク・端末の設定に合わせる、のどれで表示するかを、アプリを終了しても覚えておく。
class ThemeModeStore {
  const ThemeModeStore(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// 選んだテーマ。まだ選んだことがなければ端末の設定に合わせる。
  ThemeMode read() {
    final saved = _preferences.getString(themeModeKey);
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  Future<void> save(ThemeMode mode) {
    return _preferences.setString(themeModeKey, mode.name);
  }
}
