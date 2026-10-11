import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/post/post.dart';

part '_generated/post_datasource.g.dart';

@riverpod
PostDatasource postDatasource(Ref ref) {
  return PostDatasource(Supabase.instance.client);
}

/// Supabase の posts テーブルに記録（「今なにしてる？」）を書く。
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
}
