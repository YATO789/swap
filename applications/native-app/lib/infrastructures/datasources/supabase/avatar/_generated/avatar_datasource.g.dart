// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../avatar_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(avatarDatasource)
final avatarDatasourceProvider = AvatarDatasourceProvider._();

final class AvatarDatasourceProvider
    extends
        $FunctionalProvider<
          AvatarDatasource,
          AvatarDatasource,
          AvatarDatasource
        >
    with $Provider<AvatarDatasource> {
  AvatarDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarDatasourceHash();

  @$internal
  @override
  $ProviderElement<AvatarDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AvatarDatasource create(Ref ref) {
    return avatarDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarDatasource>(value),
    );
  }
}

String _$avatarDatasourceHash() => r'6d34aad6bd6228f6a7f59b0bdc38b7e3ddb87580';
