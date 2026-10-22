import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/remote_config_datasource.g.dart';

const _updateInfoKey = 'update_info';

@riverpod
RemoteConfigDatasource remoteConfigDatasource(Ref ref) {
  return RemoteConfigDatasource(FirebaseRemoteConfig.instance);
}

class RemoteConfigDatasource {
  const RemoteConfigDatasource(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  /// 最新の値を取ってきて使えるようにする。
  ///
  /// 取りに行くのは前に取ってから一定の時間がたったときだけで、それまでは端末に残した値を使う。
  /// 開発中は Remote Config を変えてすぐ試せるよう、毎回取りに行く。
  Future<void> fetch() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  /// アップデートの案内。Remote Config に置いていなければ null。
  Map<String, dynamic>? readUpdateInfo() {
    final value = _remoteConfig.getString(_updateInfoKey);
    if (value.isEmpty) return null;
    return jsonDecode(value) as Map<String, dynamic>;
  }
}
