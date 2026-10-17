// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_update_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// このアプリにアップデートを促すか。Remote Config の `update_info` と今のバージョンを比べる。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。

@ProviderFor(AppUpdateRepository)
final appUpdateRepositoryProvider = AppUpdateRepositoryProvider._();

/// このアプリにアップデートを促すか。Remote Config の `update_info` と今のバージョンを比べる。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
final class AppUpdateRepositoryProvider
    extends $AsyncNotifierProvider<AppUpdateRepository, AppUpdate> {
  /// このアプリにアップデートを促すか。Remote Config の `update_info` と今のバージョンを比べる。
  ///
  /// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
  AppUpdateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateRepositoryHash();

  @$internal
  @override
  AppUpdateRepository create() => AppUpdateRepository();
}

String _$appUpdateRepositoryHash() =>
    r'b1f5d471cdd9ca9df957edd9e275baf755779868';

/// このアプリにアップデートを促すか。Remote Config の `update_info` と今のバージョンを比べる。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。

abstract class _$AppUpdateRepository extends $AsyncNotifier<AppUpdate> {
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
