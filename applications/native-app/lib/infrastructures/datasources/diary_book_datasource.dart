import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/diary_book/diary_book.dart';

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
    return rows.map(_toDiaryBook).toList();
  }

  DiaryBook _toDiaryBook(Map<String, dynamic> row) {
    final members = row['diary_book_members'] as List<dynamic>;
    return DiaryBook(
      id: row['id'] as String,
      name: row['name'] as String,
      icon: row['icon'] as String,
      inviteCode: row['invite_code'] as String,
      memberCount: (members.first as Map<String, dynamic>)['count'] as int,
      coverColor: row['cover_color'] as int?,
    );
  }
}
