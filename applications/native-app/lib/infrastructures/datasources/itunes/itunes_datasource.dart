import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/itunes/models/itunes_track_response.dart';

part '_generated/itunes_datasource.g.dart';

// 使い終わるたびに捨てると、2回続けて呼ぶ途中（人気の曲の ID を取ってから曲を引くまで）で
// クライアントが閉じられて失敗するので、アプリで1つを持ち続ける。
@Riverpod(keepAlive: true)
ItunesDatasource itunesDatasource(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return ItunesDatasource(client);
}

/// iTunes Search API で曲を探したり引いたりする。鍵は要らない。
/// 呼べる回数は IP ごとに決まっているので、サーバーを通さず端末から直接呼ぶ。
class ItunesDatasource {
  const ItunesDatasource(this._client);

  final http.Client _client;

  /// 一度に返す曲の数。
  static const _limit = 20;

  /// 電波が悪いときに探し中のままにならないよう、これを過ぎたら失敗にする。
  static const _timeout = Duration(seconds: 10);

  /// トップソングのフィードを1回で待つ時間と、取る回数。
  static const _feedTimeout = Duration(seconds: 4);
  static const _feedAttempts = 3;

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
    return _fetchTracks(url);
  }

  /// 日本の Apple Music のトップソングの上位 [_limit] 曲の ID を、順位の順に返す。
  /// Apple の RSS フィード（https://rss.marketingtools.apple.com）を使う。鍵は要らない。
  ///
  /// このフィードはふだん1秒ほどで返るが、ときどき30秒近く待たされたり 504 を返したりする
  /// （2026-11-13 に確認）。取り直すとすぐ返ることが多いので、短く待って何度か取り直す。
  Future<List<String>> fetchTopSongIds() async {
    final url = Uri.https(
      'rss.marketingtools.apple.com',
      '/api/v2/jp/music/most-played/$_limit/songs.json',
    );
    Object? body;
    for (var attempt = 1; ; attempt++) {
      try {
        body = await _getJson(url, timeout: _feedTimeout);
        break;
      } on Exception {
        if (attempt >= _feedAttempts) rethrow;
      }
    }
    final results =
        ((body as Map<String, dynamic>)['feed']
                as Map<String, dynamic>)['results']
            as List;
    return [
      for (final result in results.cast<Map<String, dynamic>>())
        result['id'] as String,
    ];
  }

  /// [ids] の曲を、日本のストアから引く。ストアから消えた曲は返らない。順番は [ids] どおりとは限らない。
  Future<List<ItunesTrackResponse>> lookupTracks(List<String> ids) async {
    if (ids.isEmpty) return [];
    final url = Uri.https('itunes.apple.com', '/lookup', {
      'id': ids.join(','),
      'country': 'JP',
      'lang': 'ja_jp',
    });
    return _fetchTracks(url);
  }

  Future<List<ItunesTrackResponse>> _fetchTracks(Uri url) async {
    final body = await _getJson(url);
    final results = (body as Map<String, dynamic>)['results'] as List;
    return [
      for (final result in results.cast<Map<String, dynamic>>())
        // 曲以外（ミュージックビデオなど）が混ざることがあるので外す。
        if (result['kind'] == 'song') ItunesTrackResponse.fromJson(result),
    ];
  }

  Future<Object?> _getJson(Uri url, {Duration timeout = _timeout}) async {
    final response = await _client.get(url).timeout(timeout);
    if (response.statusCode != 200) {
      throw http.ClientException('${response.statusCode} が返りました', url);
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
