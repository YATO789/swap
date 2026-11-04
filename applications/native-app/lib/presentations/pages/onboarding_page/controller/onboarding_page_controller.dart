import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/profile_notifier.dart';
import '../../../providers/push_token_notifier.dart';

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
    // 通知の許可ダイアログを出し、許可されたらこの端末を送り先にする。
    // 断られたり失敗したりしても、そのまま始められるようにする。
    if (requestsNotification) {
      try {
        await ref.read(pushTokenProvider.future);
      } on Object catch (e, stackTrace) {
        debugPrint('通知の許可を聞けませんでした: $e\n$stackTrace');
      }
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
