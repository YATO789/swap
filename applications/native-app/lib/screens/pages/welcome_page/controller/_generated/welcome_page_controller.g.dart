// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../welcome_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。

@ProviderFor(WelcomePageController)
final welcomePageControllerProvider = WelcomePageControllerProvider._();

/// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。
final class WelcomePageControllerProvider
    extends $NotifierProvider<WelcomePageController, AsyncValue<void>> {
  /// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。
  WelcomePageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomePageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomePageControllerHash();

  @$internal
  @override
  WelcomePageController create() => WelcomePageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$welcomePageControllerHash() =>
    r'73b00059e2fffb7168d0f937fdd10bb4a55a0405';

/// ウェルカム画面のサインイン処理を受け持つ。状態はサインインの進み具合。

abstract class _$WelcomePageController extends $Notifier<AsyncValue<void>> {
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
