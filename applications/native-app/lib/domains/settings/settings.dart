import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/settings.freezed.dart';

/// 設定画面で切り替える、端末に保存する設定。
@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    /// ホームの日記帳を1冊ずつ画面いっぱいに出し、縦にスワイプして切り替えるか。
    /// false なら表紙を横2列のグリッドで並べる。
    required bool diaryBookPaged,

    /// ホームの書き込みバーに手書きの説明を出すか。
    required bool postHintVisible,

    /// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。
    required ThemeMode themeMode,

    /// 毎日決まった時刻に、日記を書くよう知らせるか。
    required bool diaryReminderEnabled,

    /// 日記のリマインダーを出す時刻。
    required TimeOfDay diaryReminderTime,
  }) = _Settings;
}
