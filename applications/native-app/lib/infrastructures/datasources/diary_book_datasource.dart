import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';

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
          'id, name, icon, cover_color, invite_code, diary_book_members(count)',
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

  /// [diaryBookId] の日記帳に参加している人を、参加した順に返す。
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) async {
    final rows = await _client
        .from('diary_book_members')
        .select('user_id, profiles(display_name)')
        .eq('diary_book_id', diaryBookId)
        .order('joined_at');
    return rows.map((row) {
      final profile = row['profiles'] as Map<String, dynamic>;
      return DiaryBookMember(
        userId: row['user_id'] as String,
        displayName: profile['display_name'] as String,
      );
    }).toList();
  }

  DiaryBook _toDiaryBook(Map<String, dynamic> row, {required int memberCount}) {
    return DiaryBook(
      id: row['id'] as String,
      name: row['name'] as String,
      icon: row['icon'] as String,
      inviteCode: row['invite_code'] as String,
      memberCount: memberCount,
      coverColor: row['cover_color'] as int?,
    );
  }
}
