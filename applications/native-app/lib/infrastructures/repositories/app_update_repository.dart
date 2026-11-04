import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/app_update/app_update.dart';
import 'package:swap/infrastructures/datasources/firebase/models/update_info_response.dart';
import 'package:swap/infrastructures/datasources/firebase/remote_config_datasource.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

part '_generated/app_update_repository.g.dart';

@riverpod
AppUpdateRepository appUpdateRepository(Ref ref) {
  return AppUpdateRepository(
    ref.watch(remoteConfigDatasourceProvider),
    ref.watch(preferencesStoreProvider),
  );
}

/// このアプリにアップデートを促すか。Remote Config の `update_info` と今のバージョンを比べる。
class AppUpdateRepository {
  const AppUpdateRepository(this._remoteConfig, this._store);

  final RemoteConfigDatasource _remoteConfig;
  final PreferencesStore _store;

  /// Remote Config の案内を取ってきて、アップデートを促すかを返す。
  Future<AppUpdate> fetch() async {
    // 取れなくても、前に取って端末に残した値で確かめる。
    try {
      await _remoteConfig.fetch();
    } catch (error, stackTrace) {
      debugPrint('Remote Config を取れませんでした: $error\n$stackTrace');
    }

    final UpdateInfoResponse? response;
    try {
      response = _remoteConfig.readUpdateInfo();
    } catch (error) {
      debugPrint('update_info を読めません: $error');
      return AppUpdate.none;
    }
    if (response == null) return AppUpdate.none;
    final info = _toUpdateInfo(response);
    if (info == null) return AppUpdate.none;

    final packageInfo = await PackageInfo.fromPlatform();
    final current = AppVersion.tryParse(packageInfo.version);
    if (current == null) return AppUpdate.none;

    return info.evaluate(
      current: current,
      now: DateTime.now(),
      skippedAt: _store.readUpdateSkippedAt(),
    );
  }

  /// 促すだけの案内で「あとで」を押したことを覚えておく。次に新しい案内を出すまで出さない。
  Future<void> skip() {
    return _store.saveUpdateSkippedAt(DateTime.now());
  }

  /// バージョンの書き方がおかしければ null。
  UpdateInfo? _toUpdateInfo(UpdateInfoResponse response) {
    final latest = AppVersion.tryParse(response.latestVersion);
    final required = AppVersion.tryParse(response.requiredVersion);
    if (latest == null || required == null) return null;
    return UpdateInfo(
      latestVersion: latest,
      requiredVersion: required,
      enabledAt: response.enabledAt,
    );
  }
}
