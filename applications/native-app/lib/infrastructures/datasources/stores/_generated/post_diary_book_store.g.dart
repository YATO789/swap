// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_diary_book_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postDiaryBookStore)
final postDiaryBookStoreProvider = PostDiaryBookStoreProvider._();

final class PostDiaryBookStoreProvider
    extends
        $FunctionalProvider<
          PostDiaryBookStore,
          PostDiaryBookStore,
          PostDiaryBookStore
        >
    with $Provider<PostDiaryBookStore> {
  PostDiaryBookStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postDiaryBookStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postDiaryBookStoreHash();

  @$internal
  @override
  $ProviderElement<PostDiaryBookStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PostDiaryBookStore create(Ref ref) {
    return postDiaryBookStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostDiaryBookStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostDiaryBookStore>(value),
    );
  }
}

String _$postDiaryBookStoreHash() =>
    r'675d72011d50b1b117adbc1104fa6444875e9398';
