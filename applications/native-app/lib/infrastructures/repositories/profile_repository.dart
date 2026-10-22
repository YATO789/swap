import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/supabase/profile/models/profile_response.dart';
import 'package:swap/infrastructures/datasources/supabase/profile/profile_datasource.dart';

part '_generated/profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(ref.watch(profileDatasourceProvider));
}

/// 自分のプロフィールを読み書きする。
class ProfileRepository {
  const ProfileRepository(this._datasource);

  final ProfileDatasource _datasource;

  /// 自分のプロフィール。まだ作っていなければ null。
  Future<Profile?> fetchMine() async {
    final response = await _datasource.fetchMine();
    return response == null ? null : _toProfile(response);
  }

  /// 表示名とアイコンの色を保存し、保存したプロフィールを返す。まだプロフィールがなければ作る。
  Future<Profile> save({
    required String displayName,
    required int? avatarColor,
  }) async {
    final response = await _datasource.saveMine(
      displayName: displayName,
      avatarColor: avatarColor,
    );
    return _toProfile(response);
  }

  Profile _toProfile(ProfileResponse response) {
    return Profile(
      id: response.id,
      displayName: response.displayName,
      avatarColor: response.avatarColor,
    );
  }
}
