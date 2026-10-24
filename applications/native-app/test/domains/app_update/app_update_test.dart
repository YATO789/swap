import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/app_update/app_update.dart';

AppVersion _version(String value) => AppVersion.tryParse(value)!;

final _now = DateTime(2026, 10, 20, 12);

UpdateInfo _info({
  String latest = '1.2.0',
  String required = '1.1.0',
  DateTime? enabledAt,
}) => UpdateInfo(
  latestVersion: _version(latest),
  requiredVersion: _version(required),
  enabledAt: enabledAt ?? DateTime(2026, 10, 20, 10),
);

void main() {
  group('AppVersion', () {
    test('桁ごとに数字として比べる', () {
      expect(_version('1.10.0').compareTo(_version('1.9.0')), 1);
      expect(_version('2.0.0').compareTo(_version('1.99.99')), 1);
    });

    test('足りない桁は 0 とみなし、ビルド番号は見ない', () {
      expect(_version('1.2').compareTo(_version('1.2.0')), 0);
      expect(_version('1.2.0+5').compareTo(_version('1.2.0')), 0);
    });

    test('数字でなければ読めない', () {
      expect(AppVersion.tryParse('1.x.0'), isNull);
      expect(AppVersion.tryParse(''), isNull);
    });
  });

  group('UpdateInfo.evaluate', () {
    test('必須のバージョンより古ければ、アップデートするまで使えない', () {
      expect(
        _info().evaluate(current: _version('1.0.9'), now: _now),
        AppUpdate.required,
      );
    });

    test('最新より古いだけなら、促すだけにする', () {
      expect(
        _info().evaluate(current: _version('1.1.0'), now: _now),
        AppUpdate.optional,
      );
    });

    test('最新なら促さない', () {
      expect(
        _info().evaluate(current: _version('1.2.0'), now: _now),
        AppUpdate.none,
      );
    });

    test('案内を出す日時より前なら、必須でも促さない', () {
      expect(
        _info(
          enabledAt: DateTime(2026, 10, 21),
        ).evaluate(current: _version('1.0.0'), now: _now),
        AppUpdate.none,
      );
    });

    test('あとでにした後に出した案内だけを出す', () {
      final info = _info();

      expect(
        info.evaluate(
          current: _version('1.1.0'),
          now: _now,
          skippedAt: DateTime(2026, 10, 20, 11),
        ),
        AppUpdate.none,
      );
      expect(
        info.evaluate(
          current: _version('1.1.0'),
          now: _now,
          skippedAt: DateTime(2026, 10, 19),
        ),
        AppUpdate.optional,
      );
    });

    test('あとでにしていても、必須なら使えなくする', () {
      expect(
        _info().evaluate(
          current: _version('1.0.0'),
          now: _now,
          skippedAt: DateTime(2026, 10, 20, 11),
        ),
        AppUpdate.required,
      );
    });
  });
}
