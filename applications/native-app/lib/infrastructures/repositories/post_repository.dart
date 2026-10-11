import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/infrastructures/datasources/post_datasource.dart';

part '_generated/post_repository.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(Ref ref) {
  return PostRepository(ref.read(postDatasourceProvider));
}

/// 記録（「今なにしてる？」）を書く。
class PostRepository {
  const PostRepository(this._datasource);

  final PostDatasource _datasource;

  /// [post] を書いて日記帳に出す。
  Future<void> create(Post post) async {
    await _datasource.create(post);
  }
}
