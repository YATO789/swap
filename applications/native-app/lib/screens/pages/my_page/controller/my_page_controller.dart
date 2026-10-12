import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/authentication_repository.dart';
import '../../../../usecases/sign_out_usecase.dart';

part '_generated/my_page_controller.g.dart';

/// マイページのログアウトとアカウント削除を受け持つ。状態はその処理の進み具合。
@riverpod
class MyPageController extends _$MyPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// ログアウトし、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> signOut() => _run(
    ref.read(signOutUseCaseProvider).call,
    failureLog: 'ログアウトできませんでした',
  );

  /// アカウントを消し、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> deleteAccount() => _run(
    ref.read(authenticationRepositoryProvider.notifier).deleteAccount,
    failureLog: 'アカウントを削除できませんでした',
  );

  Future<bool> _run(
    Future<void> Function() action, {
    required String failureLog,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('$failureLog: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
