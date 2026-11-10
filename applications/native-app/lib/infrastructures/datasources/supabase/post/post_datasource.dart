import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/infrastructures/datasources/supabase/post/models/post_response.dart';
import 'package:swap/infrastructures/datasources/supabase/post/models/track_response.dart';

part '_generated/post_datasource.g.dart';

@riverpod
PostDatasource postDatasource(Ref ref) {
  return PostDatasource(Supabase.instance.client);
}

/// Supabase の posts テーブルに記録（「ひとこと」）を読み書きする。
class PostDatasource {
  const PostDatasource(this._client);

  final SupabaseClient _client;

  /// [message] を書いて [diaryBookIds] の日記帳に出し、記録の id を返す。書いた時刻は DB が決める。
  /// [track] は記録に添える曲。
  /// 複数のテーブルにまとめて追加したいためRPCを使用。
  Future<String> create({
    required String message,
    required List<String> diaryBookIds,
    TrackResponse? track,
  }) {
    return _client.rpc<String>(
      'create_post',
      params: {
        'p_message': message,
        'p_diary_book_ids': diaryBookIds,
        'p_track': track?.toJson(),
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

  /// 自分のリアクションを、[diaryBookId] の日記帳に出た [postId] の記録に [emoji] で付ける。
  /// もう付けていれば [emoji] に付け替える。付けた時刻は DB が決める。
  Future<void> react(String postId, String diaryBookId, String emoji) async {
    // user_id は DB の既定値（auth.uid()）で入る。
    await _client.from('post_reactions').upsert({
      'post_id': postId,
      'diary_book_id': diaryBookId,
      'emoji': emoji,
    }, onConflict: 'post_id,diary_book_id,user_id');
  }

  /// [diaryBookId] の日記帳に出た [postId] の記録から、自分のリアクションを取り消す。
  Future<void> removeReaction(String postId, String diaryBookId) async {
    // RLS で消せるのは自分のリアクションだけ。
    await _client
        .from('post_reactions')
        .delete()
        .eq('post_id', postId)
        .eq('diary_book_id', diaryBookId);
  }

  /// 自分のコメント [message] を、[diaryBookId] の日記帳に出た [postId] の記録に書き、書いた行を返す。
  /// 書いた時刻は DB が決める。
  Future<PostCommentResponse> addComment(
    String postId,
    String diaryBookId,
    String message,
  ) async {
    // user_id は DB の既定値（auth.uid()）で入る。
    final row = await _client
        .from('post_comments')
        .insert({
          'post_id': postId,
          'diary_book_id': diaryBookId,
          'message': message,
        })
        .select('id, user_id, message, created_at')
        .single();
    return PostCommentResponse.fromJson(row);
  }

  /// 自分のコメント [commentId] を消す。
  Future<void> deleteComment(String commentId) async {
    // RLS で消せるのは自分のコメントだけ。消せなくても例外にならないので、消えた行で確かめる。
    final rows = await _client
        .from('post_comments')
        .delete()
        .eq('id', commentId)
        .select('id');
    if (rows.isEmpty) {
      throw StateError('コメント $commentId を消せませんでした');
    }
  }

  /// [diaryBookId] の日記帳に出された、[from] 以降 [to] より前の記録を古い順に返す。
  /// その日記帳で付いたリアクションとコメントも一緒に返す。
  Future<List<PostResponse>> fetchInDiaryBook(
    String diaryBookId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('posts')
        .select(
          'id, author_id, message, posted_at, track, '
          'post_diary_books!inner(diary_book_id, '
          'post_reactions(user_id, emoji, created_at), '
          'post_comments(id, user_id, message, created_at))',
        )
        .eq('post_diary_books.diary_book_id', diaryBookId)
        .gte('posted_at', from.toUtc().toIso8601String())
        .lt('posted_at', to.toUtc().toIso8601String())
        // Dart の order は既定が降順なので、古い順を明示する。
        .order('posted_at', ascending: true);
    return rows.map(PostResponse.fromJson).toList();
  }

  /// [authorIds] の人が [from] 以降 [to] より前に書いた記録を古い順に返す。
  /// 自分の記録と、自分の入っている日記帳に出た記録だけが RLS で返る。
  Future<List<PostResponse>> fetchByAuthors(
    List<String> authorIds, {
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('posts')
        .select('id, author_id, message, posted_at, track')
        .inFilter('author_id', authorIds)
        .gte('posted_at', from.toUtc().toIso8601String())
        .lt('posted_at', to.toUtc().toIso8601String())
        // Dart の order は既定が降順なので、古い順を明示する。
        .order('posted_at', ascending: true);
    return rows.map(PostResponse.fromJson).toList();
  }

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
