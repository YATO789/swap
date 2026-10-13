import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/datasources/supabase/profile_datasource.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';

part '_generated/profile_repository.g.dart';

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。画面の切り替えにも使うので破棄しない。
@Riverpod(keepAlive: true)
class ProfileRepository extends _$ProfileRepository {
  ProfileDatasource get _datasource => ref.read(profileDatasourceProvider);

  @override
  Future<Profile?> build() async {
    if (!ref.watch(authenticationRepositoryProvider).isLoginApp) return null;
    return _datasource.fetchMine();
  }

  /// 表示名を保存する。
  Future<void> saveDisplayName(String displayName) async {
    state = AsyncData(await _datasource.saveMine(displayName));
  }
}
