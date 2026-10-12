import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../domains/post/timeline_post.dart';
import '../../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../../infrastructures/repositories/diary_repository.dart';
import '../../../../infrastructures/repositories/post_repository.dart';

part '_generated/diary_book_page_controller.freezed.dart';
part '_generated/diary_book_page_controller.g.dart';

/// 日記帳のページに出す、ある日の内容。
@freezed
abstract class DiaryBookPageState with _$DiaryBookPageState {
  const factory DiaryBookPageState({
    /// 日記帳に参加している人。参加した順。
    required List<DiaryBookMember> members,

    /// その日の日記。書いた時刻の新しい順。
    required List<Diary> diaries,

    /// その日（朝4時区切り）の記録。古い順。
    required List<TimelinePost> posts,
  }) = _DiaryBookPageState;
}

/// もうこの日記帳に入っていない（ほかの人に外された）ときに、読み込みが投げる。
class RemovedFromDiaryBookException implements Exception {
  const RemovedFromDiaryBookException();
}

/// カレンダーで印を付ける日。
typedef MarkedDates = ({Set<DateTime> diaryDates, Set<DateTime> postDates});

/// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。
/// もう参加していなければ [RemovedFromDiaryBookException] で失敗する。
@riverpod
class DiaryBookPageController extends _$DiaryBookPageController {
  @override
  Future<DiaryBookPageState> build(String diaryBookId, DateTime date) async {
    final (members, diaries, posts) = await (
      ref.read(diaryBookRepositoryProvider.notifier).fetchMembers(diaryBookId),
      ref.read(diaryRepositoryProvider).fetchOn(diaryBookId, date),
      ref.read(postRepositoryProvider).fetchInDiaryBook(diaryBookId, date),
    ).wait;
    // メンバーは参加している日記帳の分しか読めず、参加していれば自分は必ず入っている。
    // 誰もいなければ、開いている間に外されて読めなくなっている。
    if (members.isEmpty) throw const RemovedFromDiaryBookException();
    return DiaryBookPageState(members: members, diaries: diaries, posts: posts);
  }

  /// 全部読み直す。読み直している間も、今の内容を出したままにする。
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } catch (_) {
      // 失敗したことは状態に入り、画面に出る。
    }
  }

  /// 記録だけ読み直す。記録したあとに呼ぶ。
  Future<void> reloadPosts() async {
    final current = state.value;
    if (current == null) return refresh();
    final result = await AsyncValue.guard(
      () =>
          ref.read(postRepositoryProvider).fetchInDiaryBook(diaryBookId, date),
    );
    state = result.whenData((posts) => current.copyWith(posts: posts));
  }

  /// 自分の [post] をこの日記帳から消し、タイムラインからも外す。消せたら true。
  /// ほかの日記帳に出した分は残る。
  Future<bool> deletePost(TimelinePost post) async {
    try {
      await ref
          .read(postRepositoryProvider)
          .removeFromDiaryBook(post.id, diaryBookId);
    } catch (error, stackTrace) {
      debugPrint('記録を消せませんでした: $error\n$stackTrace');
      return false;
    }
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          posts: [
            for (final other in current.posts)
              if (other.id != post.id) other,
          ],
        ),
      );
    }
    return true;
  }

  /// [month] の月で、日記がある日と記録がある日。カレンダーの印に使う。
  Future<MarkedDates> fetchMarkedDates(DateTime month) async {
    final (diaryDates, postDates) = await (
      ref.read(diaryRepositoryProvider).fetchDatesIn(diaryBookId, month),
      ref
          .read(postRepositoryProvider)
          .fetchDatesInDiaryBook(diaryBookId, month),
    ).wait;
    return (diaryDates: diaryDates, postDates: postDates);
  }
}
