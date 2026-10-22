import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/infrastructures/datasources/supabase/post/models/post_response.dart';
import 'package:swap/infrastructures/datasources/supabase/post/post_datasource.dart';

part '_generated/post_repository.g.dart';

@riverpod
PostRepository postRepository(Ref ref) {
  return PostRepository(ref.watch(postDatasourceProvider));
}

/// 記録（「今なにしてる？」）を読み書きする。
class PostRepository {
  const PostRepository(this._datasource);

  final PostDatasource _datasource;

  /// [post] を書いて日記帳に出す。
  Future<void> create(Post post) async {
    await _datasource.create(
      message: post.message,
      diaryBookIds: post.diaryBookIds,
    );
  }

  /// 自分の記録を [diaryBookId] の日記帳から外す。ほかの日記帳に出した分は残る。
  Future<void> removeFromDiaryBook(String postId, String diaryBookId) {
    return _datasource.removeFromDiaryBook(postId, diaryBookId);
  }

  /// [diaryBookId] の日記帳に出された、日記の [date]（朝4時区切り）に当たる記録を古い順に返す。
  Future<List<TimelinePost>> fetchInDiaryBook(
    String diaryBookId,
    DateTime date,
  ) async {
    final responses = await _datasource.fetchInDiaryBook(
      diaryBookId,
      from: diaryDayStartOf(date),
      to: diaryDayStartOf(DateTime(date.year, date.month, date.day + 1)),
    );
    return responses.map(_toTimelinePost).toList();
  }

  /// [authorIds] の人が日記の [date]（朝4時区切り）に書いた記録のうち、見られるものを古い順に返す。
  Future<List<TimelinePost>> fetchByAuthorsOn(
    List<String> authorIds,
    DateTime date,
  ) async {
    if (authorIds.isEmpty) return [];
    final responses = await _datasource.fetchByAuthors(
      authorIds,
      from: diaryDayStartOf(date),
      to: diaryDayStartOf(DateTime(date.year, date.month, date.day + 1)),
    );
    return responses.map(_toTimelinePost).toList();
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

  TimelinePost _toTimelinePost(PostResponse response) {
    return TimelinePost(
      id: response.id,
      authorId: response.authorId,
      message: response.message,
      postedAt: response.postedAt,
    );
  }
}
