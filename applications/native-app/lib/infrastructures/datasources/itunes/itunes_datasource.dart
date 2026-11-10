import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/itunes/models/itunes_track_response.dart';

part '_generated/itunes_datasource.g.dart';

@riverpod
ItunesDatasource itunesDatasource(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return ItunesDatasource(client);
}

/// iTunes Search API で曲を探す。鍵は要らない。
/// 呼べる回数は IP ごとに決まっているので、サーバーを通さず端末から直接呼ぶ。
class ItunesDatasource {
  const ItunesDatasource(this._client);

  final http.Client _client;

  /// 一度に返す曲の数。
  static const _limit = 20;

  /// 電波が悪いときに探し中のままにならないよう、これを過ぎたら失敗にする。
  static const _timeout = Duration(seconds: 10);

  /// 曲名・アーティスト名・アルバム名で、日本のストアの曲を探す。
  Future<List<ItunesTrackResponse>> searchTracks(String query) async {
    final url = Uri.https('itunes.apple.com', '/search', {
      'term': query,
      'media': 'music',
      'entity': 'song',
      'country': 'JP',
      'lang': 'ja_jp',
      'limit': '$_limit',
    });
    final response = await _client.get(url).timeout(_timeout);
    if (response.statusCode != 200) {
      throw http.ClientException(
        'iTunes Search API が ${response.statusCode} を返しました',
        url,
      );
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final results = (body as Map<String, dynamic>)['results'] as List;
    return [
      for (final result in results.cast<Map<String, dynamic>>())
        // 曲以外（ミュージックビデオなど）が混ざることがあるので外す。
        if (result['kind'] == 'song') ItunesTrackResponse.fromJson(result),
    ];
  }
}
