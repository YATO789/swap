import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/profile_notifier.dart';

part '_generated/profile_controller.g.dart';

/// 設定画面でのプロフィールの保存を受け持つ。状態は保存の進み具合。
@riverpod
class ProfileController extends _$ProfileController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  /// 表示名とアイコンの画像を保存し、成功したかを返す。失敗したときは状態にエラーが入る。
  /// [newAvatar] があれば画像を替え、[removesAvatar] が true なら外す。
  Future<bool> save({
    required String name,
    Uint8List? newAvatar,
    bool removesAvatar = false,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(profileProvider.notifier)
          .save(
            displayName: name,
            newAvatar: newAvatar,
            removesAvatar: removesAvatar,
          ),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('プロフィールを保存できませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
