import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap/infrastructures/datasources/stores/shared_preferences_store.dart';

part '_generated/post_diary_book_store.g.dart';

const postDiaryBookIdsKey = 'post_diary_book_ids';

@riverpod
PostDiaryBookStore postDiaryBookStore(Ref ref) {
  return PostDiaryBookStore(ref.read(sharedPreferencesProvider));
}

/// 投稿シートで前に選んだ共有先の日記帳を、アプリを終了しても覚えておく。
class PostDiaryBookStore {
  const PostDiaryBookStore(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// 前に選んだ日記帳の id。まだ選んだことがなければ空。
  Set<String> read() {
    return {...?_preferences.getStringList(postDiaryBookIdsKey)};
  }

  Future<void> save(Set<String> diaryBookIds) {
    return _preferences.setStringList(postDiaryBookIdsKey, [...diaryBookIds]);
  }
}
