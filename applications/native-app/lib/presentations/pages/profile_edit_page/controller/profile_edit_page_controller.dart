import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/profile_notifier.dart';

part '_generated/profile_edit_page_controller.g.dart';

/// プロフィール編集ページの保存処理を受け持つ。状態は保存の進み具合。
@riverpod
class ProfileEditPageController extends _$ProfileEditPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 表示名とアイコンの画像を保存し、成功したかを返す。失敗したときは状態にエラーが入る。
  /// [newAvatar] があれば画像を替え、[removesAvatar] が true なら外す。
  Future<bool> save({
    required String name,
    required Uint8List? newAvatar,
    required bool removesAvatar,
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
