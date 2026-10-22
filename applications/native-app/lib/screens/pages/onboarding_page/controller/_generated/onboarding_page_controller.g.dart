// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../onboarding_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// オンボーディング画面の保存処理を受け持つ。状態は保存の進み具合。

@ProviderFor(OnboardingPageController)
final onboardingPageControllerProvider = OnboardingPageControllerProvider._();

/// オンボーディング画面の保存処理を受け持つ。状態は保存の進み具合。
final class OnboardingPageControllerProvider
    extends $NotifierProvider<OnboardingPageController, AsyncValue<void>> {
  /// オンボーディング画面の保存処理を受け持つ。状態は保存の進み具合。
  OnboardingPageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingPageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingPageControllerHash();

  @$internal
  @override
  OnboardingPageController create() => OnboardingPageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$onboardingPageControllerHash() =>
    r'89e290c7d40dbe63f6138e47dc06d3b538272645';

/// オンボーディング画面の保存処理を受け持つ。状態は保存の進み具合。

abstract class _$OnboardingPageController extends $Notifier<AsyncValue<void>> {
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
