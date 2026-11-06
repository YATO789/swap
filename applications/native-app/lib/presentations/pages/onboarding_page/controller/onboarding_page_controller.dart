import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/push_token_repository.dart';
import '../../../providers/profile_notifier.dart';

part '_generated/onboarding_page_controller.g.dart';

/// オンボーディング画面の保存処理を受け持つ。状態は保存の進み具合。
@riverpod
class OnboardingPageController extends _$OnboardingPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 表示名を保存し、保存できたかを返す。失敗したときは状態にエラーが入る。
  /// [requestsNotification] が true なら、保存する前に通知の許可を聞く。
  ///
  /// 名前を保存するとルーターがホームへ切り替えるので、許可は先に聞いておく。
  Future<bool> start(String name, {required bool requestsNotification}) async {
    state = const AsyncLoading();
    // 「通知を許可」なら許可ダイアログを出す。「あとで」なら、ホームでも聞かないように覚えておく。
    // 断られたり失敗したりしても、そのまま始められるようにする。
    // この端末を送り先にするのは、許可とは別にホームで行う（pushTokenProvider）。
    try {
      final pushTokens = ref.read(pushTokenRepositoryProvider);
      if (requestsNotification) {
        await pushTokens.requestPermission();
      } else {
        await pushTokens.skipPermission();
      }
    } on Object catch (e, stackTrace) {
      debugPrint('通知の許可を聞けませんでした: $e\n$stackTrace');
    }
    state = await AsyncValue.guard(
      () => ref.read(profileProvider.notifier).save(displayName: name),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('名前を保存できませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
