import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/profile/profile.dart';

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
  Future<Profile?> fetchMine() async {
    final row = await _client
        .from('profiles')
        .select(_columns)
        .eq('id', _userId)
        .maybeSingle();
    return row == null ? null : _toProfile(row);
  }

  /// 自分のプロフィールを作る。もうあれば表示名を書き換える。
  Future<Profile> saveMine(String displayName) async {
    final row = await _client
        .from('profiles')
        .upsert({'id': _userId, 'display_name': displayName})
        .select(_columns)
        .single();
    return _toProfile(row);
  }

  /// 自分のプロフィールの表示名とアイコンの色を書き換える。
  /// [avatarColor] が null なら決まった色に戻す。
  Future<Profile> updateMine({
    required String displayName,
    required int? avatarColor,
  }) async {
    final row = await _client
        .from('profiles')
        .update({'display_name': displayName, 'avatar_color': avatarColor})
        .eq('id', _userId)
        .select(_columns)
        .single();
    return _toProfile(row);
  }

  static const _columns = 'id, display_name, avatar_color';

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('サインインしていません');
    return user.id;
  }

  Profile _toProfile(Map<String, dynamic> row) {
    return Profile(
      id: row['id'] as String,
      displayName: row['display_name'] as String,
      avatarColor: row['avatar_color'] as int?,
    );
  }
}
