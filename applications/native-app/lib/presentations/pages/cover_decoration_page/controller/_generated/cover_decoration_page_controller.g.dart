// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../cover_decoration_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 表紙の編集ページの保存処理を受け持つ。状態は保存の進み具合。

@ProviderFor(CoverDecorationPageController)
final coverDecorationPageControllerProvider =
    CoverDecorationPageControllerProvider._();

/// 表紙の編集ページの保存処理を受け持つ。状態は保存の進み具合。
final class CoverDecorationPageControllerProvider
    extends $NotifierProvider<CoverDecorationPageController, AsyncValue<void>> {
  /// 表紙の編集ページの保存処理を受け持つ。状態は保存の進み具合。
  CoverDecorationPageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverDecorationPageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverDecorationPageControllerHash();

  @$internal
  @override
  CoverDecorationPageController create() => CoverDecorationPageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$coverDecorationPageControllerHash() =>
    r'bda20934d2f9db74c464965d94dacbc93b15d9dc';

/// 表紙の編集ページの保存処理を受け持つ。状態は保存の進み具合。

abstract class _$CoverDecorationPageController
    extends $Notifier<AsyncValue<void>> {
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
