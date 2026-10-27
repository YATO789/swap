// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_edit_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// プロフィール編集ページの保存処理を受け持つ。状態は保存の進み具合。

@ProviderFor(ProfileEditPageController)
final profileEditPageControllerProvider = ProfileEditPageControllerProvider._();

/// プロフィール編集ページの保存処理を受け持つ。状態は保存の進み具合。
final class ProfileEditPageControllerProvider
    extends $NotifierProvider<ProfileEditPageController, AsyncValue<void>> {
  /// プロフィール編集ページの保存処理を受け持つ。状態は保存の進み具合。
  ProfileEditPageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditPageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditPageControllerHash();

  @$internal
  @override
  ProfileEditPageController create() => ProfileEditPageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$profileEditPageControllerHash() =>
    r'22a3c6bd0a88546d51416ca286fd2a9d9746ea72';

/// プロフィール編集ページの保存処理を受け持つ。状態は保存の進み具合。

abstract class _$ProfileEditPageController extends $Notifier<AsyncValue<void>> {
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
