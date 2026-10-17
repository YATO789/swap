/// アップデートを促すか。
enum AppUpdate {
  /// 促さない。
  none,

  /// 促すが、あとでにしてアプリを使い続けられる。
  optional,

  /// アップデートするまでアプリを使えない。
  required,
}

/// Remote Config の `update_info` に置く、アップデートの案内。
///
/// ```json
/// {
///   "latestVersion": "1.2.0",
///   "requiredVersion": "1.1.0",
///   "enabledAt": "2026-10-20T10:00:00+09:00"
/// }
/// ```
class UpdateInfo {
  const UpdateInfo({
    required this.latestVersion,
    required this.requiredVersion,
    required this.enabledAt,
  });

  /// 書き方がおかしい項目があれば null。
  static UpdateInfo? tryParse(Map<String, dynamic> json) {
    final latest = AppVersion.tryParse(json['latestVersion']);
    final required = AppVersion.tryParse(json['requiredVersion']);
    final enabledAt = DateTime.tryParse(json['enabledAt'] as String? ?? '');
    if (latest == null || required == null || enabledAt == null) return null;
    return UpdateInfo(
      latestVersion: latest,
      requiredVersion: required,
      enabledAt: enabledAt,
    );
  }

  /// これより古ければ、アップデートを促す。
  final AppVersion latestVersion;

  /// これより古ければ、アップデートするまで使えなくする。
  final AppVersion requiredVersion;

  /// この日時から案内を出す。ストアの審査が通るのを待ってから出すために使う。
  final DateTime enabledAt;

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
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.parts);

  /// 数字をドットでつないだ形でなければ null。`+` より後のビルド番号は見ない。
  static AppVersion? tryParse(Object? value) {
    if (value is! String) return null;
    final parts = value.split('+').first.split('.').map(int.tryParse).toList();
    if (parts.isEmpty || parts.contains(null)) return null;
    return AppVersion(parts.cast<int>());
  }

  final List<int> parts;

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
