import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/profile/profile.dart';
import '../../infrastructures/repositories/profile_repository.dart';
import 'authentication_helper.dart';

part '_generated/profile_helper.g.dart';

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。
@Riverpod(name: 'profileProvider')
class ProfileHelper extends _$ProfileHelper {
  @override
  Future<Profile?> build() async {
    if (!ref.watch(authenticationProvider).isSignedIn) return null;
    return ref.read(profileRepositoryProvider).fetchMine();
  }

  /// 表示名とアイコンの色を保存する。まだプロフィールがなければ作る。
  Future<void> save({
    required String displayName,
    required int? avatarColor,
  }) async {
    final profile = await ref
        .read(profileRepositoryProvider)
        .save(displayName: displayName, avatarColor: avatarColor);
    state = AsyncData(profile);
  }
}
