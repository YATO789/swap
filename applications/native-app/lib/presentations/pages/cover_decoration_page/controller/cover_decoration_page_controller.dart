import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../providers/diary_book_notifier.dart';

part '_generated/cover_decoration_page_controller.g.dart';

/// 表紙の編集ページの保存処理を受け持つ。状態は保存の進み具合。
@riverpod
class CoverDecorationPageController extends _$CoverDecorationPageController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  /// 表紙（名前・色・飾り）を [original] から [edited] に変え、保存できたかを返す。
  /// 失敗したときは状態にエラーが入る。
  Future<bool> save(DiaryBook original, DiaryBook edited) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(diaryBookProvider.notifier).updateCover(original, edited),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('表紙を保存できませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
