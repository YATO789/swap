// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_update_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。

@ProviderFor(AppUpdateNotifier)
final appUpdateProvider = AppUpdateNotifierProvider._();

/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
final class AppUpdateNotifierProvider
    extends $AsyncNotifierProvider<AppUpdateNotifier, AppUpdate> {
  /// アップデートを促すか。ルーターとホームが見る。
  ///
  /// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
  AppUpdateNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$appUpdateNotifierHash();

  @$internal
  @override
  AppUpdateNotifier create() => AppUpdateNotifier();
}

String _$appUpdateNotifierHash() => r'7263c93bd3a3d865b88b55ccc491d7ec5cfb87a2';

/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。

abstract class _$AppUpdateNotifier extends $AsyncNotifier<AppUpdate> {
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
