// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_update_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。

@ProviderFor(AppUpdateHelper)
final appUpdateProvider = AppUpdateHelperProvider._();

/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
final class AppUpdateHelperProvider
    extends $AsyncNotifierProvider<AppUpdateHelper, AppUpdate> {
  /// アップデートを促すか。ルーターとホームが見る。
  ///
  /// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
  AppUpdateHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateHelperHash();

  @$internal
  @override
  AppUpdateHelper create() => AppUpdateHelper();
}

String _$appUpdateHelperHash() => r'80298b426a69c84217731ecb4e344053d19ed2c1';

/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。

abstract class _$AppUpdateHelper extends $AsyncNotifier<AppUpdate> {
  FutureOr<AppUpdate> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppUpdate>, AppUpdate>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppUpdate>, AppUpdate>,
              AsyncValue<AppUpdate>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
