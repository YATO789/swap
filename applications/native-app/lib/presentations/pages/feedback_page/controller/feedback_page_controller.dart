import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/feedback_repository.dart';

part '_generated/feedback_page_controller.g.dart';

/// フィードバックのページの送信を受け持つ。状態は送信の進み具合。
@riverpod
class FeedbackPageController extends _$FeedbackPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// [body] を送り、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> send(String body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(feedbackRepositoryProvider).send(body),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('フィードバックを送れませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
