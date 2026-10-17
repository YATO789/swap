import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/app_update/app_update.dart';
import 'package:swap/infrastructures/datasources/firebase/remote_config_datasource.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

part '_generated/app_update_repository.g.dart';

/// このアプリにアップデートを促すか。Remote Config の `update_info` と今のバージョンを比べる。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
@Riverpod(keepAlive: true)
class AppUpdateRepository extends _$AppUpdateRepository {
  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  @override
  Future<AppUpdate> build() async {
    final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
    ref.onDispose(listener.dispose);

    final datasource = ref.read(remoteConfigDatasourceProvider);
    // 取れなくても、前に取って端末に残した値で確かめる。
    try {
      await datasource.fetch();
    } catch (error, stackTrace) {
      debugPrint('Remote Config を取れませんでした: $error\n$stackTrace');
    }

    final UpdateInfo? info;
    try {
      final json = datasource.readUpdateInfo();
      info = json == null ? null : UpdateInfo.tryParse(json);
    } on FormatException catch (error) {
      debugPrint('update_info が JSON になっていません: $error');
      return AppUpdate.none;
    }
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

  /// 促すだけの案内で「あとで」を押した。次に新しい案内を出すまで出さない。
  Future<void> skip() async {
    state = const AsyncData(AppUpdate.none);
    await _store.saveUpdateSkippedAt(DateTime.now());
  }
}
