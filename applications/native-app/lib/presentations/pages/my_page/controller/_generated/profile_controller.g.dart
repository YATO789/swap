// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 設定画面でのプロフィールの保存を受け持つ。状態は保存の進み具合。

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// 設定画面でのプロフィールの保存を受け持つ。状態は保存の進み具合。
final class ProfileControllerProvider
    extends $NotifierProvider<ProfileController, AsyncValue<void>> {
  /// 設定画面でのプロフィールの保存を受け持つ。状態は保存の進み具合。
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$profileControllerHash() => r'6a2a03b00d63c4354618e947e909fb575231b8e9';

/// 設定画面でのプロフィールの保存を受け持つ。状態は保存の進み具合。

abstract class _$ProfileController extends $Notifier<AsyncValue<void>> {
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
