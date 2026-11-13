// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../itunes_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(itunesDatasource)
final itunesDatasourceProvider = ItunesDatasourceProvider._();

final class ItunesDatasourceProvider
    extends
        $FunctionalProvider<
          ItunesDatasource,
          ItunesDatasource,
          ItunesDatasource
        >
    with $Provider<ItunesDatasource> {
  ItunesDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itunesDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itunesDatasourceHash();

  @$internal
  @override
  $ProviderElement<ItunesDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ItunesDatasource create(Ref ref) {
    return itunesDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItunesDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItunesDatasource>(value),
    );
  }
}

String _$itunesDatasourceHash() => r'ecb2243ec3488a8e37684d34e706a9c6ce13debe';
