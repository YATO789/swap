import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/stores/theme_mode_store.dart';

part '_generated/theme_mode_repository.g.dart';

/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。
@Riverpod(keepAlive: true)
class ThemeModeRepository extends _$ThemeModeRepository {
  ThemeModeStore get _store => ref.read(themeModeStoreProvider);

  @override
  ThemeMode build() => _store.read();

  /// テーマを [mode] にして保存する。
  Future<void> save(ThemeMode mode) async {
    state = mode;
    await _store.save(mode);
  }
}
