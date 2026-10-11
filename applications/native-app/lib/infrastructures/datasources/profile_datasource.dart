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
        .select('id, display_name')
        .eq('id', _userId)
        .maybeSingle();
    return row == null ? null : _toProfile(row);
  }

  /// 自分のプロフィールを作る。もうあれば表示名を書き換える。
  Future<Profile> saveMine(String displayName) async {
    final row = await _client
        .from('profiles')
        .upsert({'id': _userId, 'display_name': displayName})
        .select('id, display_name')
        .single();
    return _toProfile(row);
  }

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('サインインしていません');
    return user.id;
  }

  Profile _toProfile(Map<String, dynamic> row) {
    return Profile(
      id: row['id'] as String,
      displayName: row['display_name'] as String,
    );
  }
}
