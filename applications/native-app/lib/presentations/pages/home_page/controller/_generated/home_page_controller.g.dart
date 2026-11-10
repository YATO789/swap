// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../home_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの処理を受け持つ。状態は一覧を読み直す進み具合。

@ProviderFor(HomePageController)
final homePageControllerProvider = HomePageControllerProvider._();

/// ホームの処理を受け持つ。状態は一覧を読み直す進み具合。
final class HomePageControllerProvider
    extends $NotifierProvider<HomePageController, AsyncValue<void>> {
  /// ホームの処理を受け持つ。状態は一覧を読み直す進み具合。
  HomePageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homePageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homePageControllerHash();

  @$internal
  @override
  HomePageController create() => HomePageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$homePageControllerHash() =>
    r'da217934b95cb25174192ad9e2ba2690690cb6af';

/// ホームの処理を受け持つ。状態は一覧を読み直す進み具合。

abstract class _$HomePageController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
