import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../providers/diary_book_notifier.dart';

part '_generated/create_diary_book_page_controller.g.dart';

/// 日記帳を作るページの作成処理を受け持つ。状態は作成の進み具合。
@riverpod
class CreateDiaryBookPageController extends _$CreateDiaryBookPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 日記帳を作り、作った日記帳を返す。失敗したら null を返し、状態にエラーが入る。
  Future<DiaryBook?> create(String name, {int? coverColor}) async {
    state = const AsyncLoading();
    DiaryBook? diaryBook;
    state = await AsyncValue.guard(() async {
      diaryBook = await ref
          .read(diaryBookProvider.notifier)
          .create(name, coverColor: coverColor);
    });
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('日記帳を作れませんでした: $error\n$stackTrace');
      return null;
    }
    return diaryBook;
  }
}
