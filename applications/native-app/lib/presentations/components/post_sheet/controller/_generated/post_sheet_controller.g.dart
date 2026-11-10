// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_sheet_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 「ひとこと」の投稿シートの投稿処理を受け持つ。状態は投稿の進み具合。

@ProviderFor(PostSheetController)
final postSheetControllerProvider = PostSheetControllerProvider._();

/// 「ひとこと」の投稿シートの投稿処理を受け持つ。状態は投稿の進み具合。
final class PostSheetControllerProvider
    extends $NotifierProvider<PostSheetController, AsyncValue<void>> {
  /// 「ひとこと」の投稿シートの投稿処理を受け持つ。状態は投稿の進み具合。
  PostSheetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postSheetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postSheetControllerHash();

  @$internal
  @override
  PostSheetController create() => PostSheetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$postSheetControllerHash() =>
    r'a959ba61f28d7f0f3f69f5e37dc2e8e4d0045fb9';

/// 「ひとこと」の投稿シートの投稿処理を受け持つ。状態は投稿の進み具合。

abstract class _$PostSheetController extends $Notifier<AsyncValue<void>> {
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
