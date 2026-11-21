import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part '_generated/diary_photo_datasource.g.dart';

// 写真を上げる途中でクライアントが閉じられないよう、アプリで1つを持ち続ける。
@Riverpod(keepAlive: true)
DiaryPhotoDatasource diaryPhotoDatasource(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return DiaryPhotoDatasource(Supabase.instance.client, client);
}

/// 日記の写真を Cloudflare R2 に上げたり、見るための URL をもらったりする。
///
/// R2 の鍵はアプリに持たせない。Edge Function（diary-photo-url）に期限付きの URL を出してもらい、
/// その URL で R2 に直接上げる・R2 から直接読む。
/// 写真は書いた人のフォルダ（`diaries/{ユーザー ID}/…`）に置き、DB にはパスだけを持つ。
class DiaryPhotoDatasource {
  const DiaryPhotoDatasource(this._client, this._http);

  final SupabaseClient _client;
  final http.Client _http;

  static const _function = 'diary-photo-url';

  /// Edge Function が一度に URL を出せる日記の数。Edge Function の maxViewDiaries と合わせる。
  static const _maxViewDiaries = 100;

  /// 電波が悪いときに上げ中のままにならないよう、これを過ぎたら失敗にする。
  static const _uploadTimeout = Duration(seconds: 60);

  /// [bytes] の写真（JPEG か PNG）を自分のフォルダに上げ、R2 の中のパスを返す。
  Future<String> upload(Uint8List bytes) async {
    final contentType = _isPng(bytes) ? 'image/png' : 'image/jpeg';
    final response = await _client.functions.invoke(
      _function,
      body: {'action': 'upload', 'content_type': contentType},
    );
    final data = response.data as Map<String, dynamic>;
    //　期限付きURLを取得
    final url = Uri.parse(data['url'] as String);
    // 上げるときの種類が、あとで読むときに R2 が返す種類になる。
    final put = await _http
        .put(url, headers: {'Content-Type': contentType}, body: bytes)
        .timeout(_uploadTimeout);
    if (put.statusCode != 200) {
      throw http.ClientException('写真を上げられませんでした（${put.statusCode}）', url);
    }
    return data['path'] as String;
  }

  /// [diaryIds] の日記のうち、写真があって読める日記の、写真を見るための URL を日記の id ごとに返す。
  /// URL は1時間で切れる。一度に頼める数を超えるときは、分けて頼む。
  Future<Map<String, String>> fetchUrls(List<String> diaryIds) async {
    final urls = <String, String>{};
    for (var start = 0; start < diaryIds.length; start += _maxViewDiaries) {
      final end = (start + _maxViewDiaries).clamp(0, diaryIds.length);
      final response = await _client.functions.invoke(
        _function,
        body: {'action': 'view', 'diary_ids': diaryIds.sublist(start, end)},
      );
      final data = response.data as Map<String, dynamic>;
      urls.addAll(
        (data['urls'] as Map<String, dynamic>).cast<String, String>(),
      );
    }
    return urls;
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
