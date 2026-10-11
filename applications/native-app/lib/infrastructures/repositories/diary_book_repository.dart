import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/diary_book/invited_diary_book.dart';
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

  /// 招待コード [code] の日記帳を、参加する前に見せるために探す。見つからなければ null。
  Future<InvitedDiaryBook?> findByCode(String code) {
    return _datasource.findByCode(code);
  }

  /// 招待コード [code] の日記帳に参加し、一覧を読み直して参加した日記帳を返す。
  /// コードが違えば null。もう参加していれば、その日記帳を返す。
  Future<DiaryBook?> join(String code) async {
    final id = await _datasource.join(code);
    if (id == null) return null;
    ref.invalidateSelf();
    final diaryBooks = await future;
    return diaryBooks.where((diaryBook) => diaryBook.id == id).firstOrNull;
  }

  /// [diaryBookId] の日記帳に参加している人を、参加した順に返す。
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) {
    return _datasource.fetchMembers(diaryBookId);
  }
}
