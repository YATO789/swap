import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/stores/post_hint_store.dart';

part '_generated/post_hint_repository.g.dart';

/// ホームの書き込みバーに添える手書きの説明のうち、どれを出すか。
/// 使い方が分かれば要らないので、記録したら入力欄の説明を、
/// 日記を書くページを開いたらペンの説明を、それぞれ消す。
@Riverpod(keepAlive: true)
class PostHintRepository extends _$PostHintRepository {
  PostHintStore get _store => ref.read(postHintStoreProvider);

  @override
  ({bool post, bool diary}) build() =>
      (post: !_store.readPosted(), diary: !_store.readDiaryOpened());

  /// 記録したので、入力欄の説明を消す。
  Future<void> posted() async {
    if (!state.post) return;
    state = (post: false, diary: state.diary);
    await _store.savePosted();
  }

  /// 日記を書くページを開いたので、ペンの説明を消す。
  Future<void> diaryOpened() async {
    if (!state.diary) return;
    state = (post: state.post, diary: false);
    await _store.saveDiaryOpened();
  }
}
