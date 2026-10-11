import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/infrastructures/datasources/diary_book_datasource.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';

part '_generated/diary_book_repository.g.dart';

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。
@Riverpod(keepAlive: true)
class DiaryBookRepository extends _$DiaryBookRepository {
  DiaryBookDatasource get _datasource => ref.read(diaryBookDatasourceProvider);

  @override
  Future<List<DiaryBook>> build() async {
    if (!ref.watch(authenticationRepositoryProvider).isLoginApp) return [];
    return _datasource.fetchJoined();
  }

  /// 日記帳を作って一覧の最後に足し、作った日記帳を返す。
  Future<DiaryBook> create(String name, {int? coverColor}) async {
    final diaryBook = await _datasource.create(name, coverColor: coverColor);
    final current = state.value;
    // 読み込み中などで一覧がまだなければ、読み直して作ったものも含める。
    if (current == null) {
      ref.invalidateSelf();
    } else {
      state = AsyncData([...current, diaryBook]);
    }
    return diaryBook;
  }
}
