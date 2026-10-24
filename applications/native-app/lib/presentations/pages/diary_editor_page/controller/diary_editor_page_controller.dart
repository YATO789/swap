import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../domains/post/timeline_post.dart';
import '../../../../infrastructures/repositories/diary_repository.dart';
import '../../../../infrastructures/repositories/post_repository.dart';
import '../../../providers/profile_notifier.dart';

part '_generated/diary_editor_page_controller.freezed.dart';
part '_generated/diary_editor_page_controller.g.dart';

/// 日記を書くページに出す内容。
@freezed
abstract class DiaryEditorPageState with _$DiaryEditorPageState {
  const factory DiaryEditorPageState({
    /// その日にもう書いた自分の日記。日記帳の id ごと。
    required Map<String, Diary> diaries,

    /// その日（朝4時区切り）の自分の記録。古い順。
    required List<TimelinePost> posts,
  }) = _DiaryEditorPageState;
}

/// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。
@riverpod
class DiaryEditorPageController extends _$DiaryEditorPageController {
  @override
  Future<DiaryEditorPageState> build(DateTime date) async {
    final myId = (await ref.read(profileProvider.future))?.id;
    final (diaries, posts) = await (
      ref.read(diaryRepositoryProvider).fetchMineOn(date),
      ref.read(postRepositoryProvider).fetchByAuthorsOn([?myId], date),
    ).wait;
    return DiaryEditorPageState(diaries: diaries, posts: posts);
  }

  /// 読み直す。読み直している間も、今の内容を出したままにする。
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } catch (_) {
      // 失敗したことは状態に入り、画面に出る。
    }
  }

  /// [diaryBookIds] の日記帳に、自分の日記として同じ内容を書く。書けたら true。
  Future<bool> save({
    required List<String> diaryBookIds,
    required String title,
    required String body,
  }) async {
    try {
      await ref
          .read(diaryRepositoryProvider)
          .save(
            diaryBookIds: diaryBookIds,
            date: date,
            title: title,
            body: body,
          );
      return true;
    } catch (error, stackTrace) {
      debugPrint('日記を書けませんでした: $error\n$stackTrace');
      return false;
    }
  }
}
