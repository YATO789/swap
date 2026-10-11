import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../domains/diary_book/diary_book.dart';
import '../../../../../../domains/diary_book/invited_diary_book.dart';
import '../../../../../../infrastructures/repositories/diary_book_repository.dart';

part '_generated/join_diary_book_dialog_controller.g.dart';

/// 招待コードで参加するダイアログの、確認と参加の処理を受け持つ。状態は処理の進み具合。
@riverpod
class JoinDiaryBookDialogController extends _$JoinDiaryBookDialogController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 招待コード [code] の日記帳を探す。見つからなければ null。
  /// 通信などで失敗したときも null を返し、状態にエラーが入る。
  Future<InvitedDiaryBook?> check(String code) async {
    state = const AsyncLoading();
    InvitedDiaryBook? found;
    state = await AsyncValue.guard(() async {
      found = await ref
          .read(diaryBookRepositoryProvider.notifier)
          .findByCode(code);
    });
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('招待コードを確かめられませんでした: $error\n$stackTrace');
      return null;
    }
    return found;
  }

  /// 招待コード [code] の日記帳に参加し、参加した日記帳を返す。
  /// 参加できなかったら null を返し、状態にエラーが入る。
  Future<DiaryBook?> join(String code) async {
    state = const AsyncLoading();
    DiaryBook? diaryBook;
    state = await AsyncValue.guard(() async {
      diaryBook = await ref
          .read(diaryBookRepositoryProvider.notifier)
          .join(code);
      if (diaryBook == null) throw StateError('招待コードの日記帳が見つかりません');
    });
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('日記帳に参加できませんでした: $error\n$stackTrace');
      return null;
    }
    return diaryBook;
  }
}
