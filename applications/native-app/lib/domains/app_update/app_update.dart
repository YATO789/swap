import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/app_update.freezed.dart';

enum AppUpdate {
  none,

  /// アプリを使い続けられる。
  optional,

  /// アップデートするまでアプリを使えない。
  required,
}

@freezed
abstract class UpdateInfo with _$UpdateInfo {
  const UpdateInfo._();

  const factory UpdateInfo({
    /// これより古ければ、アップデートを促す。
    required AppVersion latestVersion,

    /// これより古ければ、アップデートするまで使えなくする。
    required AppVersion requiredVersion,

    /// この日時から案内を出す。ストアの審査が通るのを待ってから出すために使う。
    required DateTime enabledAt,
  }) = _UpdateInfo;

  /// [current] のアプリにアップデートを促すか。
  ///
  /// 促すだけのときは、[skippedAt] に「あとで」を押していれば、
  /// それより後に出した案内だけを出す。
  AppUpdate evaluate({
    required AppVersion current,
    required DateTime now,
    DateTime? skippedAt,
  }) {
    if (enabledAt.isAfter(now)) return AppUpdate.none;
    if (current < requiredVersion) return AppUpdate.required;
    if (current >= latestVersion) return AppUpdate.none;
    if (skippedAt != null && !enabledAt.isAfter(skippedAt)) {
      return AppUpdate.none;
    }
    return AppUpdate.optional;
  }
}

/// `1.2.3` の形のバージョン。足りない桁は 0 とみなす。
@freezed
abstract class AppVersion with _$AppVersion implements Comparable<AppVersion> {
  const AppVersion._();

  const factory AppVersion(List<int> parts) = _AppVersion;

  /// 数字をドットでつないだ形でなければ null。`+` より後のビルド番号は見ない。
  static AppVersion? tryParse(String value) {
    final parts = value.split('+').first.split('.').map(int.tryParse).toList();
    if (parts.isEmpty || parts.contains(null)) return null;
    return AppVersion(parts.cast<int>());
  }

  @override
  int compareTo(AppVersion other) {
    final length = parts.length > other.parts.length
        ? parts.length
        : other.parts.length;
    for (var i = 0; i < length; i++) {
      final a = i < parts.length ? parts[i] : 0;
      final b = i < other.parts.length ? other.parts[i] : 0;
      if (a != b) return a.compareTo(b);
    }
    return 0;
  }

  bool operator <(AppVersion other) => compareTo(other) < 0;

  bool operator >=(AppVersion other) => compareTo(other) >= 0;

  @override
  String toString() => parts.join('.');
}
