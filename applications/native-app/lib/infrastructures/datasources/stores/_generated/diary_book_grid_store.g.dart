// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_grid_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryBookGridStore)
final diaryBookGridStoreProvider = DiaryBookGridStoreProvider._();

final class DiaryBookGridStoreProvider
    extends
        $FunctionalProvider<
          DiaryBookGridStore,
          DiaryBookGridStore,
          DiaryBookGridStore
        >
    with $Provider<DiaryBookGridStore> {
  DiaryBookGridStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookGridStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookGridStoreHash();

  @$internal
  @override
  $ProviderElement<DiaryBookGridStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiaryBookGridStore create(Ref ref) {
    return diaryBookGridStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryBookGridStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryBookGridStore>(value),
    );
  }
}

String _$diaryBookGridStoreHash() =>
    r'667f72964dc598028a4b7add20591a4a510a3ade';
