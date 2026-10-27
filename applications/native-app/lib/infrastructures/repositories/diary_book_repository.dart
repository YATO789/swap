import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/diary_book/invited_diary_book.dart';
import 'package:swap/infrastructures/datasources/supabase/avatar/avatar_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/diary_book_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/diary_book_member_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/diary_book_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/invited_diary_book_response.dart';

part '_generated/diary_book_repository.g.dart';

@riverpod
DiaryBookRepository diaryBookRepository(Ref ref) {
  return DiaryBookRepository(
    ref.watch(diaryBookDatasourceProvider),
    ref.watch(avatarDatasourceProvider),
  );
}

/// 日記帳を読み書きする。
class DiaryBookRepository {
  const DiaryBookRepository(this._datasource, this._avatarDatasource);

  final DiaryBookDatasource _datasource;
  final AvatarDatasource _avatarDatasource;

  /// 自分が参加している日記帳を返す。
  Future<List<DiaryBook>> fetchJoined() async {
    final responses = await _datasource.fetchJoined();
    return [
      for (final response in responses)
        _toDiaryBook(response.diaryBook, memberCount: response.memberCount),
    ];
  }

  /// 日記帳を作り、作った日記帳を返す。
  Future<DiaryBook> create(String name, {int? coverColor}) async {
    final response = await _datasource.create(name, coverColor: coverColor);
    // 作った人だけが入っている。
    return _toDiaryBook(response, memberCount: 1);
  }

  /// 招待コード [code] の日記帳を、参加する前に見せるために探す。見つからなければ null。
  Future<InvitedDiaryBook?> findByCode(String code) async {
    final response = await _datasource.findByCode(code);
    return response == null ? null : _toInvitedDiaryBook(response);
  }

  /// 招待コード [code] の日記帳に参加し、その日記帳の id を返す。コードが違えば null。
  /// もう参加していれば、その日記帳の id を返す。
  Future<String?> join(String code) {
    return _datasource.join(code);
  }

  /// [diaryBookId] の日記帳に参加している人を、参加した順に返す。
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) async {
    final responses = await _datasource.fetchMembers(diaryBookId);
    return responses.map(_toDiaryBookMember).toList();
  }

  /// [diaryBookId] の日記帳の名前を [name] にする。
  Future<void> rename(String diaryBookId, String name) {
    return _datasource.rename(diaryBookId, name);
  }

  /// [diaryBookId] の日記帳の表紙の色を [coverColor] にする。
  Future<void> setCoverColor(String diaryBookId, int? coverColor) {
    return _datasource.setCoverColor(diaryBookId, coverColor);
  }

  /// [diaryBookId] の日記帳に参加できる人数の上限を [memberLimit] 人にする。
  Future<void> setMemberLimit(String diaryBookId, int memberLimit) {
    return _datasource.setMemberLimit(diaryBookId, memberLimit);
  }

  /// [diaryBookId] の日記帳の招待コードを作り直し、新しいコードを返す。
  Future<String> regenerateInviteCode(String diaryBookId) {
    return _datasource.regenerateInviteCode(diaryBookId);
  }

  /// [diaryBookId] の日記帳から [userId] の人を外し、作り直された招待コードを返す。
  /// 外した人がまた参加できないように、招待コードも作り直される。
  Future<String> removeMember(String diaryBookId, String userId) {
    return _datasource.removeMember(diaryBookId, userId);
  }

  /// [diaryBookId] の日記帳から抜ける。
  Future<void> leave(String diaryBookId) {
    return _datasource.leave(diaryBookId);
  }

  DiaryBook _toDiaryBook(
    DiaryBookResponse response, {
    required int memberCount,
  }) {
    return DiaryBook(
      id: response.id,
      name: response.name,
      inviteCode: response.inviteCode,
      memberCount: memberCount,
      memberLimit: response.memberLimit,
      createdBy: response.createdBy,
      coverColor: response.coverColor,
    );
  }

  InvitedDiaryBook _toInvitedDiaryBook(InvitedDiaryBookResponse response) {
    return InvitedDiaryBook(
      id: response.id,
      name: response.name,
      memberNames: response.memberNames,
      memberAvatarUrls: response.memberAvatarPaths.map(_avatarUrl).toList(),
      alreadyJoined: response.alreadyJoined,
      memberLimit: response.memberLimit,
      coverColor: response.coverColor,
    );
  }

  DiaryBookMember _toDiaryBookMember(DiaryBookMemberResponse response) {
    return DiaryBookMember(
      userId: response.userId,
      displayName: response.profile.displayName,
      avatarUrl: _avatarUrl(response.profile.avatarPath),
    );
  }

  String? _avatarUrl(String? avatarPath) {
    return avatarPath == null ? null : _avatarDatasource.publicUrl(avatarPath);
  }
}
