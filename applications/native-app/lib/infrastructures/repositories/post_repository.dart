import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/infrastructures/datasources/post_datasource.dart';

part '_generated/post_repository.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(Ref ref) {
  return PostRepository(ref.read(postDatasourceProvider));
}

/// 記録（「今なにしてる？」）を読み書きする。
class PostRepository {
  const PostRepository(this._datasource);

  final PostDatasource _datasource;

  /// [post] を書いて日記帳に出す。
  Future<void> create(Post post) async {
    await _datasource.create(post);
  }

  /// [diaryBookId] の日記帳に出された、日記の [date]（朝4時区切り）に当たる記録を古い順に返す。
  Future<List<TimelinePost>> fetchInDiaryBook(
    String diaryBookId,
    DateTime date,
  ) {
    final start = diaryDayStartOf(date);
    return _datasource.fetchInDiaryBook(
      diaryBookId,
      from: start,
      to: diaryDayStartOf(DateTime(date.year, date.month, date.day + 1)),
    );
  }

  /// [diaryBookId] の日記帳に、[month] の月の間で記録が出された日（朝4時区切り）。
  Future<Set<DateTime>> fetchDatesInDiaryBook(
    String diaryBookId,
    DateTime month,
  ) async {
    final times = await _datasource.fetchPostedTimesInDiaryBook(
      diaryBookId,
      from: diaryDayStartOf(DateTime(month.year, month.month)),
      to: diaryDayStartOf(DateTime(month.year, month.month + 1)),
    );
    return {for (final time in times) diaryDateOf(time)};
  }
}
