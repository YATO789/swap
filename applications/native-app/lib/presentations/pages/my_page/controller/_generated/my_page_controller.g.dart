// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../my_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// マイページのログアウトとアカウント削除、日記のリマインダーの切り替えを受け持つ。
/// 状態はログアウトとアカウント削除の進み具合。

@ProviderFor(MyPageController)
final myPageControllerProvider = MyPageControllerProvider._();

/// マイページのログアウトとアカウント削除、日記のリマインダーの切り替えを受け持つ。
/// 状態はログアウトとアカウント削除の進み具合。
final class MyPageControllerProvider
    extends $NotifierProvider<MyPageController, AsyncValue<void>> {
  /// マイページのログアウトとアカウント削除、日記のリマインダーの切り替えを受け持つ。
  /// 状態はログアウトとアカウント削除の進み具合。
  MyPageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPageControllerHash();

  @$internal
  @override
  MyPageController create() => MyPageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$myPageControllerHash() => r'78ea40a40f768c495afc96e240cb74c00c882a1b';

/// マイページのログアウトとアカウント削除、日記のリマインダーの切り替えを受け持つ。
/// 状態はログアウトとアカウント削除の進み具合。

abstract class _$MyPageController extends $Notifier<AsyncValue<void>> {
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
