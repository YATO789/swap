import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/authentication_repository.dart';

part '_generated/welcome_page_controller.g.dart';

/// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。
@riverpod
class WelcomePageController extends _$WelcomePageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// サインインし、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> signIn() async {
    state = const AsyncLoading();
    // TODO: Supabase で Apple サインインする。今は仮に匿名ユーザーとしてサインインする。
    state = await AsyncValue.guard(
      ref.read(authenticationRepositoryProvider.notifier).signInAnonymously,
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('サインインに失敗しました: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
