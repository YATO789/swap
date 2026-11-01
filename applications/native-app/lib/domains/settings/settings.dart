import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/settings.freezed.dart';

/// 設定画面で切り替える、端末に保存する設定。
@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    /// ホームの書き込みバーに手書きの説明を出すか。
    required bool postHintVisible,

    /// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。
    required ThemeMode themeMode,
  }) = _Settings;
}
