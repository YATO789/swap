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

  /// 一覧を読み直す。ほかの人が変えた名前や表紙、人数も映る。
  /// 読み直している間も今の一覧を出したままにし、失敗したら一覧はそのままで投げる。
  Future<void> refresh() async {
    if (!ref.read(authenticationRepositoryProvider).isLoginApp) return;
    state = AsyncData(await _datasource.fetchJoined());
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

  /// [diaryBookId] の日記帳の名前を [name] にし、一覧にも映す。
  Future<void> rename(String diaryBookId, String name) async {
    await _datasource.rename(diaryBookId, name);
    // アイコンは DB が名前の1文字目から作るので、同じように作る。
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(
        name: name,
        icon: String.fromCharCodes(name.runes.take(1)),
      ),
    );
  }

  /// [diaryBookId] の日記帳の表紙の色を [coverColor] にし、一覧にも映す。
  Future<void> setCoverColor(String diaryBookId, int? coverColor) async {
    await _datasource.setCoverColor(diaryBookId, coverColor);
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(coverColor: coverColor),
    );
  }

  /// [diaryBookId] の日記帳の招待コードを作り直し、一覧にも映す。
  Future<void> regenerateInviteCode(String diaryBookId) async {
    final inviteCode = await _datasource.regenerateInviteCode(diaryBookId);
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(inviteCode: inviteCode),
    );
  }

  /// [diaryBookId] の日記帳から [userId] の人を外す。外した人がまた参加できないように、
  /// 招待コードも作り直される。人数と新しいコードを一覧にも映す。
  Future<void> removeMember(String diaryBookId, String userId) async {
    final inviteCode = await _datasource.removeMember(diaryBookId, userId);
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(
        inviteCode: inviteCode,
        memberCount: diaryBook.memberCount - 1,
      ),
    );
  }

  /// [diaryBookId] の日記帳から抜け、一覧から外す。
  Future<void> leave(String diaryBookId) async {
    await _datasource.leave(diaryBookId);
    final current = state.value;
    if (current == null) return ref.invalidateSelf();
    state = AsyncData([
      for (final diaryBook in current)
        if (diaryBook.id != diaryBookId) diaryBook,
    ]);
  }

  void _replace(String diaryBookId, DiaryBook Function(DiaryBook) update) {
    final current = state.value;
    if (current == null) return ref.invalidateSelf();
    state = AsyncData([
      for (final diaryBook in current)
        diaryBook.id == diaryBookId ? update(diaryBook) : diaryBook,
    ]);
  }
}
