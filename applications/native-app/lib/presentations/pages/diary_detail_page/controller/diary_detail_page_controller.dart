import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../domains/post/timeline_post.dart';
import '../../../../domains/reaction/reaction.dart';
import '../../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../../infrastructures/repositories/diary_repository.dart';
import '../../../../infrastructures/repositories/post_repository.dart';
import '../../../providers/diary_reminder_notifier.dart';
import '../../../providers/profile_notifier.dart';

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
    // 記録はこの日記帳に出されたものだけを出す。ほかの日記帳にだけ出した記録は出さない。
    final (diaries, members, profile, posts) = await (
      ref.read(diaryRepositoryProvider).fetchOn(diaryBookId, date),
      ref.read(diaryBookRepositoryProvider).fetchMembers(diaryBookId),
      ref.read(profileProvider.future),
      ref.read(postRepositoryProvider).fetchInDiaryBook(diaryBookId, date),
    ).wait;
    final myId = profile?.id;
    // 伏せてある日記はめくっても読めないので、ページにしない。
    final readable = [
      ...diaries.where((diary) => diary.authorId == myId),
      ...diaries.where((diary) => diary.authorId != myId && !diary.isLocked),
    ];
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

  /// 自分（[myId]）のリアクションを、[diaryId] の日記に [emoji] で付ける。同じ絵文字なら取り消す。
  /// 待たずにすぐ画面に映し、保存できなかったら元に戻して false を返す。
  Future<bool> react(String diaryId, String myId, String emoji) async {
    final before = _diaryOf(diaryId);
    if (before == null) return false;
    final removing = before.reactionOf(myId) == emoji;
    _replaceDiary(before.reactedBy(myId, emoji));

    final repository = ref.read(diaryRepositoryProvider);
    try {
      if (removing) {
        await repository.removeReaction(diaryId);
      } else {
        await repository.react(diaryId, emoji);
      }
    } catch (error, stackTrace) {
      debugPrint('リアクションを保存できませんでした: $error\n$stackTrace');
      // 待っている間にほかの絵文字を選んでいても、自分のリアクションだけをこの前に戻す。
      final latest = _diaryOf(diaryId);
      if (latest != null) {
        _replaceDiary(
          latest.copyWith(
            reactions: latest.reactions.withReactionOf(myId, before.reactions),
          ),
        );
      }
      return false;
    }
    return true;
  }

  Diary? _diaryOf(String diaryId) {
    return state.value?.diaries
        .where((diary) => diary.id == diaryId)
        .firstOrNull;
  }

  void _replaceDiary(Diary replaced) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        diaries: [
          for (final diary in current.diaries)
            if (diary.id == replaced.id) replaced else diary,
        ],
      ),
    );
  }

  /// 自分の [diary] を消す。消せたら true。
  Future<bool> delete(Diary diary) async {
    try {
      await ref.read(diaryRepositoryProvider).delete(diary.id);
      // 今日の日記がなくなったら、今日のリマインダーを出すようにする。
      ref.read(diaryReminderProvider.notifier).sync();
      return true;
    } catch (error, stackTrace) {
      debugPrint('日記を消せませんでした: $error\n$stackTrace');
      return false;
    }
  }
}
