import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/diary_book_member_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/diary_book_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/invited_diary_book_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/models/joined_diary_book_response.dart';

part '_generated/diary_book_datasource.g.dart';

@riverpod
DiaryBookDatasource diaryBookDatasource(Ref ref) {
  return DiaryBookDatasource(Supabase.instance.client);
}

/// Supabase の diary_books テーブルから日記帳を読む。
class DiaryBookDatasource {
  const DiaryBookDatasource(this._client);

  final SupabaseClient _client;

  /// 自分が参加している日記帳。RLS で参加しているものだけが返る。
  Future<List<JoinedDiaryBookResponse>> fetchJoined() async {
    final rows = await _client
        .from('diary_books')
        .select(
          'id, name, cover_color, invite_code, member_limit, created_by, '
          'diary_book_members(count)',
        )
        .order('created_at');
    return rows.map(JoinedDiaryBookResponse.fromJson).toList();
  }

  /// 日記帳を作って参加する。招待コードは DB が作る。
  Future<DiaryBookResponse> create(String name, {int? coverColor}) async {
    final row = await _client.rpc<Map<String, dynamic>>(
      'create_diary_book',
      params: {'p_name': name, 'p_cover_color': coverColor},
    );
    return DiaryBookResponse.fromJson(row);
  }

  /// 招待コード [code] の日記帳を、参加する前に見せるために探す。見つからなければ null。
  Future<InvitedDiaryBookResponse?> findByCode(String code) async {
    final rows = await _client.rpc<List<dynamic>>(
      'find_diary_book_by_code',
      params: {'p_code': code},
    );
    if (rows.isEmpty) return null;
    return InvitedDiaryBookResponse.fromJson(
      rows.first as Map<String, dynamic>,
    );
  }

  /// 招待コード [code] の日記帳に参加し、その id を返す。コードが違えば null。
  /// もう参加していれば何もせず、その id を返す。
  Future<String?> join(String code) {
    return _client.rpc<String?>('join_diary_book', params: {'p_code': code});
  }

  /// [diaryBookId] の日記帳に参加している人を、参加した順に返す。
  Future<List<DiaryBookMemberResponse>> fetchMembers(String diaryBookId) async {
    final rows = await _client
        .from('diary_book_members')
        .select('user_id, profiles(display_name, avatar_path)')
        .eq('diary_book_id', diaryBookId)
        .order('joined_at');
    return rows.map(DiaryBookMemberResponse.fromJson).toList();
  }

  /// [diaryBookId] の日記帳の名前を [name] にする。
  Future<void> rename(String diaryBookId, String name) async {
    await _client
        .from('diary_books')
        .update({'name': name})
        .eq('id', diaryBookId);
  }

  /// [diaryBookId] の日記帳の表紙の色を [coverColor] にする。null なら決まったグレーに戻す。
  Future<void> setCoverColor(String diaryBookId, int? coverColor) async {
    await _client
        .from('diary_books')
        .update({'cover_color': coverColor})
        .eq('id', diaryBookId);
  }

  /// [diaryBookId] の日記帳に参加できる人数の上限を [memberLimit] 人にする。
  /// 作った人しか変えられず、今の人数より少なくはできない。
  Future<void> setMemberLimit(String diaryBookId, int memberLimit) async {
    await _client.rpc<void>(
      'set_diary_book_member_limit',
      params: {'p_diary_book_id': diaryBookId, 'p_member_limit': memberLimit},
    );
  }

  /// [diaryBookId] の日記帳の招待コードを作り直し、新しいコードを返す。
  Future<String> regenerateInviteCode(String diaryBookId) {
    return _client.rpc<String>(
      'regenerate_invite_code',
      params: {'p_diary_book_id': diaryBookId},
    );
  }

  /// [diaryBookId] の日記帳から [userId] の人を外し、作り直した招待コードを返す。
  Future<String> removeMember(String diaryBookId, String userId) {
    return _client.rpc<String>(
      'remove_diary_book_member',
      params: {'p_diary_book_id': diaryBookId, 'p_user_id': userId},
    );
  }

  /// [diaryBookId] の日記帳から自分が抜ける。
  Future<void> leave(String diaryBookId) async {
    await _client
        .from('diary_book_members')
        .delete()
        .eq('diary_book_id', diaryBookId)
        .eq('user_id', _client.auth.currentUser!.id);
  }
}
