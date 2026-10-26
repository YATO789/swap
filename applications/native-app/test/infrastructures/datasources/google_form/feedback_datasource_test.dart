import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:swap/infrastructures/datasources/google_form/feedback_datasource.dart';

const _formUrl = 'https://docs.google.com/forms/d/e/form-id/formResponse';
const _formKey = 'entry.123';

void main() {
  test('フォームの URL に、本文を欄の名前で POST する', () async {
    late http.Request request;
    final datasource = FeedbackDatasource(
      MockClient((sent) async {
        request = sent;
        return http.Response('', 200);
      }),
      formUrl: _formUrl,
      formKey: _formKey,
    );

    await datasource.send('通知の時間を選びたい');

    expect(request.method, 'POST');
    expect(request.url, Uri.parse(_formUrl));
    expect(request.bodyFields, {_formKey: '通知の時間を選びたい'});
  });

  test('フォームが 200 番台以外を返したら失敗する', () async {
    final datasource = FeedbackDatasource(
      MockClient((_) async => http.Response('', 400)),
      formUrl: _formUrl,
      formKey: _formKey,
    );

    await expectLater(
      datasource.send('本文'),
      throwsA(isA<http.ClientException>()),
    );
  });

  test('URL が設定されていなければ、送らずに失敗する', () async {
    var sent = false;
    final datasource = FeedbackDatasource(
      MockClient((_) async {
        sent = true;
        return http.Response('', 200);
      }),
      formUrl: '',
      formKey: _formKey,
    );

    await expectLater(datasource.send('本文'), throwsStateError);
    expect(sent, isFalse);
  });
}
