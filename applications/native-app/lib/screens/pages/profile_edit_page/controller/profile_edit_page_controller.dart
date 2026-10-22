import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helpers/profile_helper.dart';

part '_generated/profile_edit_page_controller.g.dart';

/// プロフィール編集ページの保存処理を受け持つ。状態は保存の進み具合。
@riverpod
class ProfileEditPageController extends _$ProfileEditPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 表示名とアイコンの色を保存し、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> save({required String name, required int? avatarColor}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(profileProvider.notifier)
          .save(displayName: name, avatarColor: avatarColor),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('プロフィールを保存できませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
