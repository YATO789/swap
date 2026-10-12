import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap/infrastructures/datasources/stores/shared_preferences_store.dart';

part '_generated/diary_book_grid_store.g.dart';

const diaryBookGridKey = 'diary_book_grid';

@riverpod
DiaryBookGridStore diaryBookGridStore(Ref ref) {
  return DiaryBookGridStore(ref.read(sharedPreferencesProvider));
}

/// ホームの日記帳の一覧を表紙のグリッドで出すかを、アプリを終了しても覚えておく。
class DiaryBookGridStore {
  const DiaryBookGridStore(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// グリッドで出すか。まだ選んだことがなければリスト。
  bool read() {
    return _preferences.getBool(diaryBookGridKey) ?? false;
  }

  Future<void> save(bool grid) {
    return _preferences.setBool(diaryBookGridKey, grid);
  }
}
