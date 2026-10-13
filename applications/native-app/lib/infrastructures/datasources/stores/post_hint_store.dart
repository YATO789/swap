import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap/infrastructures/datasources/stores/shared_preferences_store.dart';

part '_generated/post_hint_store.g.dart';

const postHintPostedKey = 'post_hint_posted';
const postHintDiaryOpenedKey = 'post_hint_diary_opened';

@riverpod
PostHintStore postHintStore(Ref ref) {
  return PostHintStore(ref.read(sharedPreferencesProvider));
}

/// ホームの書き込みバーに添える手書きの説明を、もう出さなくてよいかを覚えておく。
class PostHintStore {
  const PostHintStore(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// 「今なにしてる？」で一度でも記録したか。
  bool readPosted() => _preferences.getBool(postHintPostedKey) ?? false;

  /// ペンから日記を書くページを一度でも開いたか。
  bool readDiaryOpened() =>
      _preferences.getBool(postHintDiaryOpenedKey) ?? false;

  Future<void> savePosted() => _preferences.setBool(postHintPostedKey, true);

  Future<void> saveDiaryOpened() =>
      _preferences.setBool(postHintDiaryOpenedKey, true);
}
