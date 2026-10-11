import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/profile_repository.dart';

part '_generated/onboarding_page_controller.g.dart';

/// オンボーディング画面の保存処理を受け持つ。状態は保存の進み具合。
@riverpod
class OnboardingPageController extends _$OnboardingPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 表示名を保存し、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> saveName(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider.notifier).saveDisplayName(name),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('名前を保存できませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
