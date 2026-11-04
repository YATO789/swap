import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/feedback_datasource.g.dart';

@riverpod
FeedbackDatasource feedbackDatasource(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return FeedbackDatasource(
    client,
    formUrl: const String.fromEnvironment('FEEDBACK_FORM_URL'),
    formKey: const String.fromEnvironment('FEEDBACK_FORM_KEY'),
  );
}

/// フィードバックを Google フォームに回答として送る。
class FeedbackDatasource {
  const FeedbackDatasource(
    this._client, {
    required this.formUrl,
    required this.formKey,
  });

  final http.Client _client;

  /// フォームの送信先（末尾が /formResponse の URL）。
  final String formUrl;

  /// 本文を入れる欄の名前（entry.xxx）。
  final String formKey;

  /// 電波が悪いときに送信中のままにならないよう、これを過ぎたら失敗にする。
  static const _timeout = Duration(seconds: 15);

  /// [body] を送る。送れなかったら例外を投げる。
  Future<void> send(String body) async {
    if (formUrl.isEmpty || formKey.isEmpty) {
      throw StateError('FEEDBACK_FORM_URL か FEEDBACK_FORM_KEY が設定されていません');
    }
    final response = await _client
        .post(Uri.parse(formUrl), body: {formKey: body})
        .timeout(_timeout);
    // フォームの「回答を受け付ける」がオフだと、200 のまま回答は捨てられる。
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'フォームが ${response.statusCode} を返しました',
        Uri.parse(formUrl),
      );
    }
  }
}
