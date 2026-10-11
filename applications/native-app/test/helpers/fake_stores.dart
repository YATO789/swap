import 'package:swap/infrastructures/datasources/stores/post_diary_book_store.dart';

/// 端末に保存せず、選んだ日記帳をメモリに覚えておく。
class FakePostDiaryBookStore implements PostDiaryBookStore {
  Set<String> _diaryBookIds = {};

  @override
  Set<String> read() => _diaryBookIds;

  @override
  Future<void> save(Set<String> diaryBookIds) async {
    _diaryBookIds = diaryBookIds;
  }
}
