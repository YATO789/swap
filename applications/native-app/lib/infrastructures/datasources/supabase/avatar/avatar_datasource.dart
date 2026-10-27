import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part '_generated/avatar_datasource.g.dart';

@riverpod
AvatarDatasource avatarDatasource(Ref ref) {
  return AvatarDatasource(Supabase.instance.client);
}

/// Supabase Storage の avatars バケットに、アイコンの画像を置く・消す。
///
/// 画像は `{ユーザー ID}/{ミリ秒の時刻}.jpg` に置き、上書きはしない。
/// 名前が変わればキャッシュに古い画像が残らないので、1年キャッシュさせる。
class AvatarDatasource {
  const AvatarDatasource(this._client);

  final SupabaseClient _client;

  /// [bytes] の画像を自分のフォルダに置き、バケットの中のパスを返す。
  /// JPEG か PNG であること。
  Future<String> upload(Uint8List bytes) async {
    final isPng = _isPng(bytes);
    final path =
        '$_userId/${DateTime.now().millisecondsSinceEpoch}.${isPng ? 'png' : 'jpg'}';
    await _bucket.uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(
        contentType: isPng ? 'image/png' : 'image/jpeg',
        cacheControl: '31536000',
      ),
    );
    return path;
  }

  /// バケットの中の [path] の画像を消す。
  Future<void> remove(String path) async {
    await _bucket.remove([path]);
  }

  /// 自分のフォルダの画像をすべて消す。アカウントを消す前に呼ぶ。
  Future<void> removeMine() async {
    final userId = _userId;
    final files = await _bucket.list(path: userId);
    if (files.isEmpty) return;
    await _bucket.remove([for (final file in files) '$userId/${file.name}']);
  }

  /// バケットの中の [path] の画像の URL。
  String publicUrl(String path) {
    return _bucket.getPublicUrl(path);
  }

  StorageFileApi get _bucket => _client.storage.from('avatars');

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('サインインしていません');
    return user.id;
  }

  /// PNG のファイルの先頭の印（0x89 'P' 'N' 'G'）があるか。
  static bool _isPng(Uint8List bytes) {
    return bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
  }
}
