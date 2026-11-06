import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part '_generated/preferences_store.g.dart';

const diaryBookPagedKey = 'diary_book_paged';
const postDiaryBookIdsKey = 'post_diary_book_ids';
const postHintVisibleKey = 'post_hint_visible';
const themeModeKey = 'theme_mode';
const updateSkippedAtKey = 'update_skipped_at';
const notificationPermissionSkippedKey = 'notification_permission_skipped';

/// 端末に保存する値の読み書きに使う SharedPreferences。
/// 読み込みを待ってから使いたいので、main で作ったものに差し替える。
@Riverpod(keepAlive: true)
SharedPreferencesWithCache sharedPreferences(Ref ref) {
  throw UnimplementedError('main で sharedPreferencesProvider を差し替えてください');
}

@riverpod
PreferencesStore preferencesStore(Ref ref) {
  return PreferencesStore(ref.read(sharedPreferencesProvider));
}

/// アプリを終了しても覚えておきたい設定を、端末に読み書きする。
class PreferencesStore {
  const PreferencesStore(this._preferences);

  /// 読み書きするキー。SharedPreferencesWithCache の allowList に渡す。
  static const keys = {
    diaryBookPagedKey,
    postDiaryBookIdsKey,
    postHintVisibleKey,
    themeModeKey,
    updateSkippedAtKey,
    notificationPermissionSkippedKey,
  };

  final SharedPreferencesWithCache _preferences;

  /// ホームの日記帳を1冊ずつ縦にスワイプして出すか。まだ選んだことがなければ1冊ずつ。
  bool readDiaryBookPaged() {
    return _preferences.getBool(diaryBookPagedKey) ?? true;
  }

  Future<void> saveDiaryBookPaged(bool paged) {
    return _preferences.setBool(diaryBookPagedKey, paged);
  }

  /// 投稿シートで前に選んだ共有先の日記帳の id。まだ選んだことがなければ空。
  Set<String> readPostDiaryBookIds() {
    return {...?_preferences.getStringList(postDiaryBookIdsKey)};
  }

  Future<void> savePostDiaryBookIds(Set<String> diaryBookIds) {
    return _preferences.setStringList(postDiaryBookIdsKey, [...diaryBookIds]);
  }

  /// ホームの書き込みバーに手書きの説明を出すか。まだ切り替えたことがなければ出す。
  bool readPostHintVisible() {
    return _preferences.getBool(postHintVisibleKey) ?? true;
  }

  Future<void> savePostHintVisible(bool visible) {
    return _preferences.setBool(postHintVisibleKey, visible);
  }

  /// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。
  /// まだ選んだことがなければ端末の設定に合わせる。
  ThemeMode readThemeMode() {
    final saved = _preferences.getString(themeModeKey);
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  Future<void> saveThemeMode(ThemeMode mode) {
    return _preferences.setString(themeModeKey, mode.name);
  }

  /// アップデートの案内で最後に「あとで」を押した日時。まだ押したことがなければ null。
  DateTime? readUpdateSkippedAt() {
    final saved = _preferences.getInt(updateSkippedAtKey);
    return saved == null ? null : DateTime.fromMillisecondsSinceEpoch(saved);
  }

  Future<void> saveUpdateSkippedAt(DateTime skippedAt) {
    return _preferences.setInt(
      updateSkippedAtKey,
      skippedAt.millisecondsSinceEpoch,
    );
  }

  /// オンボーディングで通知の許可を聞かずに「あとで」で始めたか。まだ選んだことがなければ false。
  bool readNotificationPermissionSkipped() {
    return _preferences.getBool(notificationPermissionSkippedKey) ?? false;
  }

  Future<void> saveNotificationPermissionSkipped(bool skipped) {
    return _preferences.setBool(notificationPermissionSkippedKey, skipped);
  }
}
