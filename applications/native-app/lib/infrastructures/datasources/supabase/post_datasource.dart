import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/timeline_post.dart';

part '_generated/post_datasource.g.dart';

@riverpod
PostDatasource postDatasource(Ref ref) {
  return PostDatasource(Supabase.instance.client);
}

/// Supabase の posts テーブルに記録（「今なにしてる？」）を読み書きする。
class PostDatasource {
  const PostDatasource(this._client);

  final SupabaseClient _client;

  /// [post] を書いて日記帳に出し、記録の id を返す。書いた時刻は DB が決める。
  Future<String> create(Post post) {
    return _client.rpc<String>(
      'create_post',
      params: {
        'p_message': post.message,
        'p_diary_book_ids': post.diaryBookIds,
      },
    );
  }

  /// 自分の記録を [diaryBookId] の日記帳から外す。ほかの日記帳に出した分は残る。
  /// どの日記帳にも出ていなくなったら、記録も消える。
  Future<void> removeFromDiaryBook(String postId, String diaryBookId) async {
    await _client.rpc<void>(
      'remove_post_from_diary_book',
      params: {'p_post_id': postId, 'p_diary_book_id': diaryBookId},
    );
  }

  /// [diaryBookId] の日記帳に出された、[from] 以降 [to] より前の記録を古い順に返す。
  Future<List<TimelinePost>> fetchInDiaryBook(
    String diaryBookId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('posts')
        .select(
          'id, author_id, message, posted_at, '
          'post_diary_books!inner(diary_book_id)',
        )
        .eq('post_diary_books.diary_book_id', diaryBookId)
        .gte('posted_at', from.toUtc().toIso8601String())
        .lt('posted_at', to.toUtc().toIso8601String())
        // Dart の order は既定が降順なので、古い順を明示する。
        .order('posted_at', ascending: true);
    return rows.map(_toTimelinePost).toList();
  }

  /// [authorIds] の人が [from] 以降 [to] より前に書いた記録を古い順に返す。
  /// 自分の記録と、自分の入っている日記帳に出た記録だけが RLS で返る。
  Future<List<TimelinePost>> fetchByAuthors(
    List<String> authorIds, {
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('posts')
        .select('id, author_id, message, posted_at')
        .inFilter('author_id', authorIds)
        .gte('posted_at', from.toUtc().toIso8601String())
        .lt('posted_at', to.toUtc().toIso8601String())
        .order('posted_at');
    return rows.map(_toTimelinePost).toList();
  }

  TimelinePost _toTimelinePost(Map<String, dynamic> row) => TimelinePost(
    id: row['id'] as String,
    authorId: row['author_id'] as String,
    message: row['message'] as String,
    postedAt: DateTime.parse(row['posted_at'] as String).toLocal(),
  );

  /// [diaryBookId] の日記帳に出された、[from] 以降 [to] より前の記録の書いた時刻。
  Future<List<DateTime>> fetchPostedTimesInDiaryBook(
    String diaryBookId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('posts')
        .select('posted_at, post_diary_books!inner(diary_book_id)')
        .eq('post_diary_books.diary_book_id', diaryBookId)
        .gte('posted_at', from.toUtc().toIso8601String())
        .lt('posted_at', to.toUtc().toIso8601String());
    return [
      for (final row in rows)
        DateTime.parse(row['posted_at'] as String).toLocal(),
    ];
  }
}
