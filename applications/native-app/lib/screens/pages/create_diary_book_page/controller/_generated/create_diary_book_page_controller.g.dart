// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_diary_book_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 日記帳を作るページの作成処理を受け持つ。状態は作成の進み具合。

@ProviderFor(CreateDiaryBookPageController)
final createDiaryBookPageControllerProvider =
    CreateDiaryBookPageControllerProvider._();

/// 日記帳を作るページの作成処理を受け持つ。状態は作成の進み具合。
final class CreateDiaryBookPageControllerProvider
    extends $NotifierProvider<CreateDiaryBookPageController, AsyncValue<void>> {
  /// 日記帳を作るページの作成処理を受け持つ。状態は作成の進み具合。
  CreateDiaryBookPageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createDiaryBookPageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createDiaryBookPageControllerHash();

  @$internal
  @override
  CreateDiaryBookPageController create() => CreateDiaryBookPageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$createDiaryBookPageControllerHash() =>
    r'257d57de3b49f8331361fc6af40ed533865114d0';

/// 日記帳を作るページの作成処理を受け持つ。状態は作成の進み具合。

abstract class _$CreateDiaryBookPageController
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
