import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap/infrastructures/datasources/stores/shared_preferences_store.dart';

part '_generated/post_hint_store.g.dart';

const postHintVisibleKey = 'post_hint_visible';

@riverpod
PostHintStore postHintStore(Ref ref) {
  return PostHintStore(ref.read(sharedPreferencesProvider));
}

/// ホームの書き込みバーに添える手書きの説明を出すかを、アプリを終了しても覚えておく。
class PostHintStore {
  const PostHintStore(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// 説明を出すか。まだ切り替えたことがなければ出す。
  bool read() => _preferences.getBool(postHintVisibleKey) ?? true;

  Future<void> save(bool visible) =>
      _preferences.setBool(postHintVisibleKey, visible);
}
