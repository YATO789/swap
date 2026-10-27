import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/supabase/avatar/avatar_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/profile/models/profile_response.dart';
import 'package:swap/infrastructures/datasources/supabase/profile/profile_datasource.dart';

part '_generated/profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    ref.watch(profileDatasourceProvider),
    ref.watch(avatarDatasourceProvider),
  );
}

/// 自分のプロフィールを読み書きする。
class ProfileRepository {
  const ProfileRepository(this._datasource, this._avatarDatasource);

  final ProfileDatasource _datasource;
  final AvatarDatasource _avatarDatasource;

  /// 自分のプロフィール。まだ作っていなければ null。
  Future<Profile?> fetchMine() async {
    final response = await _datasource.fetchMine();
    return response == null ? null : _toProfile(response);
  }

  /// 表示名を保存し、保存したプロフィールを返す。まだプロフィールがなければ作る。
  ///
  /// [newAvatar] があれば、アイコンの画像をその画像（JPEG か PNG）に替える。
  /// [removesAvatar] が true なら画像を外す。どちらでもなければ今の画像のまま。
  /// 前の画像は、プロフィールを保存できてから消す。
  Future<Profile> save({
    required String displayName,
    Uint8List? newAvatar,
    bool removesAvatar = false,
  }) async {
    final oldPath = (await _datasource.fetchMine())?.avatarPath;
    final newPath = newAvatar == null
        ? null
        : await _avatarDatasource.upload(newAvatar);
    final avatarPath = newPath ?? (removesAvatar ? null : oldPath);

    final ProfileResponse response;
    try {
      response = await _datasource.saveMine(
        displayName: displayName,
        avatarPath: avatarPath,
      );
    } on Object {
      // どこからも指されない画像を残さない。
      if (newPath != null) await _removeAvatar(newPath);
      rethrow;
    }
    if (oldPath != null && oldPath != avatarPath) await _removeAvatar(oldPath);
    return _toProfile(response);
  }

  /// 画像を消す。消せなくても、プロフィールの保存は済んでいるので失敗にしない。
  Future<void> _removeAvatar(String path) async {
    try {
      await _avatarDatasource.remove(path);
    } on Object catch (e, stackTrace) {
      debugPrint('アイコンの画像を消せませんでした: $e\n$stackTrace');
    }
  }

  Profile _toProfile(ProfileResponse response) {
    final avatarPath = response.avatarPath;
    return Profile(
      id: response.id,
      displayName: response.displayName,
      avatarUrl: avatarPath == null
          ? null
          : _avatarDatasource.publicUrl(avatarPath),
    );
  }
}
