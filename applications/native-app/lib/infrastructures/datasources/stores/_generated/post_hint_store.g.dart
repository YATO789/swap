// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_hint_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postHintStore)
final postHintStoreProvider = PostHintStoreProvider._();

final class PostHintStoreProvider
    extends $FunctionalProvider<PostHintStore, PostHintStore, PostHintStore>
    with $Provider<PostHintStore> {
  PostHintStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postHintStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postHintStoreHash();

  @$internal
  @override
  $ProviderElement<PostHintStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostHintStore create(Ref ref) {
    return postHintStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostHintStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostHintStore>(value),
    );
  }
}

String _$postHintStoreHash() => r'73e9ce85f4ef2983418f184f886e87c8136c258b';
