import 'package:flutter_test/flutter_test.dart';
import 'package:swap/infrastructures/datasources/firebase/models/update_info_response.dart';

void main() {
  test('Remote Config の JSON を読む', () {
    final response = UpdateInfoResponse.fromJson({
      'latestVersion': '1.2.0',
      'requiredVersion': '1.1.0',
      'enabledAt': '2026-10-20T10:00:00+09:00',
    });

    expect(response.latestVersion, '1.2.0');
    expect(response.requiredVersion, '1.1.0');
    expect(response.enabledAt, DateTime.utc(2026, 10, 20, 1));
    expect(response.releaseNotes, isNull);
  });

  test('変わったことを書いていれば読む', () {
    final response = UpdateInfoResponse.fromJson({
      'latestVersion': '1.2.0',
      'requiredVersion': '1.1.0',
      'enabledAt': '2026-10-20T10:00:00+09:00',
      'releaseNotes': '・記録に曲をつけられるように\n・不具合を直しました',
    });

    expect(response.releaseNotes, '・記録に曲をつけられるように\n・不具合を直しました');
  });

  test('足りない項目があれば読めない', () {
    expect(
      () => UpdateInfoResponse.fromJson({
        'latestVersion': '1.2.0',
        'enabledAt': '2026-10-20T10:00:00+09:00',
      }),
      throwsA(anything),
    );
  });
}
