import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../domains/post/timeline_post.dart';
import '../../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../../infrastructures/repositories/diary_repository.dart';
import '../../../../infrastructures/repositories/post_repository.dart';
import '../../../helpers/profile_helper.dart';

part '_generated/diary_detail_page_controller.freezed.dart';
part '_generated/diary_detail_page_controller.g.dart';

/// 日記の詳細ページに出す内容。
@freezed
abstract class DiaryDetailPageState with _$DiaryDetailPageState {
  const factory DiaryDetailPageState({
    /// 読める日記。自分の日記を先頭に、あとは書いた時刻の新しい順。この順にページをめくる。
    required List<Diary> diaries,

    /// 日記帳のメンバー。user id ごと。
    required Map<String, DiaryBookMember> members,

    /// 日記を書いた人ごとの、その日（朝4時区切り）の記録。古い順。
    required Map<String, List<TimelinePost>> posts,
  }) = _DiaryDetailPageState;
}

/// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。
@riverpod
class DiaryDetailPageController extends _$DiaryDetailPageController {
  @override
  Future<DiaryDetailPageState> build(String diaryBookId, DateTime date) async {
    final (diaries, members, profile) = await (
      ref.read(diaryRepositoryProvider).fetchOn(diaryBookId, date),
      ref.read(diaryBookRepositoryProvider).fetchMembers(diaryBookId),
      ref.read(profileProvider.future),
    ).wait;
    final myId = profile?.id;
    // 伏せてある日記はめくっても読めないので、ページにしない。
    final readable = [
      ...diaries.where((diary) => diary.authorId == myId),
      ...diaries.where((diary) => diary.authorId != myId && !diary.isLocked),
    ];
    final posts = await ref.read(postRepositoryProvider).fetchByAuthorsOn([
      for (final diary in readable) diary.authorId,
    ], date);
    return DiaryDetailPageState(
      diaries: readable,
      members: {for (final member in members) member.userId: member},
      posts: {
        for (final diary in readable)
          diary.authorId: [
            for (final post in posts)
              if (post.authorId == diary.authorId) post,
          ],
      },
    );
  }

  /// 読み直す。編集から戻ったときに呼ぶ。読み直している間も、今の内容を出したままにする。
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } catch (_) {
      // 失敗したことは状態に入り、画面に出る。
    }
  }

  /// 自分の [diary] を消す。消せたら true。
  Future<bool> delete(Diary diary) async {
    try {
      await ref.read(diaryRepositoryProvider).delete(diary.id);
      return true;
    } catch (error, stackTrace) {
      debugPrint('日記を消せませんでした: $error\n$stackTrace');
      return false;
    }
  }
}
