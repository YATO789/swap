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
        isAutoDispose: true,
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

String _$itunesDatasourceHash() => r'18a5a04ce1ae045395f1e8ebee795a92cb9a4bbf';
