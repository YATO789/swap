import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/diary_book/invited_diary_book.dart';

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
  Future<List<DiaryBook>> fetchJoined() async {
    final rows = await _client
        .from('diary_books')
        .select(
          'id, name, cover_color, invite_code, member_limit, created_by, '
          'diary_book_members(count)',
        )
        .order('created_at');
    return rows.map((row) {
      final members = row['diary_book_members'] as List<dynamic>;
      final count = (members.first as Map<String, dynamic>)['count'] as int;
      return _toDiaryBook(row, memberCount: count);
    }).toList();
  }

  /// 日記帳を作って参加する。招待コードは DB が作る。
  Future<DiaryBook> create(String name, {int? coverColor}) async {
    final row = await _client.rpc<Map<String, dynamic>>(
      'create_diary_book',
      params: {'p_name': name, 'p_cover_color': coverColor},
    );
    // 作った人だけが入っている。
    return _toDiaryBook(row, memberCount: 1);
  }

  /// 招待コード [code] の日記帳を、参加する前に見せるために探す。見つからなければ null。
  Future<InvitedDiaryBook?> findByCode(String code) async {
    final rows = await _client.rpc<List<dynamic>>(
      'find_diary_book_by_code',
      params: {'p_code': code},
    );
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return InvitedDiaryBook(
      id: row['id'] as String,
      name: row['name'] as String,
      memberNames: (row['member_names'] as List<dynamic>).cast<String>(),
      memberAvatarColors: (row['member_avatar_colors'] as List<dynamic>)
          .cast<int?>(),
      alreadyJoined: row['already_joined'] as bool,
      memberLimit: row['member_limit'] as int,
      coverColor: row['cover_color'] as int?,
    );
  }

  /// 招待コード [code] の日記帳に参加し、その id を返す。コードが違えば null。
  /// もう参加していれば何もせず、その id を返す。
  Future<String?> join(String code) {
    return _client.rpc<String?>('join_diary_book', params: {'p_code': code});
  }

  /// [diaryBookId] の日記帳に参加している人を、参加した順に返す。
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) async {
    final rows = await _client
        .from('diary_book_members')
        .select('user_id, profiles(display_name, avatar_color)')
        .eq('diary_book_id', diaryBookId)
        .order('joined_at');
    return rows.map((row) {
      final profile = row['profiles'] as Map<String, dynamic>;
      return DiaryBookMember(
        userId: row['user_id'] as String,
        displayName: profile['display_name'] as String,
        avatarColor: profile['avatar_color'] as int?,
      );
    }).toList();
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

  DiaryBook _toDiaryBook(Map<String, dynamic> row, {required int memberCount}) {
    return DiaryBook(
      id: row['id'] as String,
      name: row['name'] as String,
      inviteCode: row['invite_code'] as String,
      memberCount: memberCount,
      memberLimit: row['member_limit'] as int,
      createdBy: row['created_by'] as String?,
      coverColor: row['cover_color'] as int?,
    );
  }
}
