import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/profile/profile.dart';
import '../../infrastructures/repositories/profile_repository.dart';
import 'authentication_notifier.dart';

part '_generated/profile_notifier.g.dart';

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。
@Riverpod(name: 'profileProvider')
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<Profile?> build() async {
    if (!ref.watch(authenticationProvider).isSignedIn) return null;
    return ref.read(profileRepositoryProvider).fetchMine();
  }

  /// 表示名を保存する。まだプロフィールがなければ作る。
  /// [newAvatar] があればアイコンの画像を替え、[removesAvatar] が true なら外す。
  Future<void> save({
    required String displayName,
    Uint8List? newAvatar,
    bool removesAvatar = false,
  }) async {
    final profile = await ref
        .read(profileRepositoryProvider)
        .save(
          displayName: displayName,
          newAvatar: newAvatar,
          removesAvatar: removesAvatar,
        );
    state = AsyncData(profile);
  }
}
