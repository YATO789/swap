import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/infrastructures/datasources/supabase/profile/models/profile_response.dart';

part '_generated/profile_datasource.g.dart';

@riverpod
ProfileDatasource profileDatasource(Ref ref) {
  return ProfileDatasource(Supabase.instance.client);
}

/// Supabase の profiles テーブルから自分のプロフィールを読み書きする。
class ProfileDatasource {
  const ProfileDatasource(this._client);

  final SupabaseClient _client;

  /// 自分のプロフィール。まだ作っていなければ null。
  Future<ProfileResponse?> fetchMine() async {
    final row = await _client
        .from('profiles')
        .select(_columns)
        .eq('id', _userId)
        .maybeSingle();
    return row == null ? null : ProfileResponse.fromJson(row);
  }

  /// 自分のプロフィールを作る。もうあれば表示名とアイコンの色を書き換える。
  /// [avatarColor] が null なら決まった色にする。
  Future<ProfileResponse> saveMine({
    required String displayName,
    required int? avatarColor,
  }) async {
    final row = await _client
        .from('profiles')
        .upsert({
          'id': _userId,
          'display_name': displayName,
          'avatar_color': avatarColor,
        })
        .select(_columns)
        .single();
    return ProfileResponse.fromJson(row);
  }

  static const _columns = 'id, display_name, avatar_color';

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('サインインしていません');
    return user.id;
  }
}
