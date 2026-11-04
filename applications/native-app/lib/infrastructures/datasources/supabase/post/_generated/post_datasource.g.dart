// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postDatasource)
final postDatasourceProvider = PostDatasourceProvider._();

final class PostDatasourceProvider
    extends $FunctionalProvider<PostDatasource, PostDatasource, PostDatasource>
    with $Provider<PostDatasource> {
  PostDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postDatasourceHash();

  @$internal
  @override
  $ProviderElement<PostDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostDatasource create(Ref ref) {
    return postDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostDatasource>(value),
    );
  }
}

String _$postDatasourceHash() => r'6450f93840e90c8116d38fc405881e52bdb6b612';
