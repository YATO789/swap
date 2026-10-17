import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

part '_generated/post_diary_book_repository.g.dart';

/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。
@Riverpod(keepAlive: true)
class PostDiaryBookRepository extends _$PostDiaryBookRepository {
  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  @override
  Set<String> build() => _store.readPostDiaryBookIds();

  /// 選んだ日記帳を [diaryBookIds] にして保存する。
  Future<void> save(Set<String> diaryBookIds) async {
    state = diaryBookIds;
    await _store.savePostDiaryBookIds(diaryBookIds);
  }
}
