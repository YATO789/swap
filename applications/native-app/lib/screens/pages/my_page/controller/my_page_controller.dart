import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/authentication_repository.dart';

part '_generated/my_page_controller.g.dart';

/// マイページのログアウト処理を受け持つ。状態はログアウトの進み具合。
@riverpod
class MyPageController extends _$MyPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// ログアウトし、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      ref.read(authenticationRepositoryProvider.notifier).signOut,
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('ログアウトできませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
