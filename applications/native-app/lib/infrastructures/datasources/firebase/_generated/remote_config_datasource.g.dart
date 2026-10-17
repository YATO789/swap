// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../remote_config_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteConfigDatasource)
final remoteConfigDatasourceProvider = RemoteConfigDatasourceProvider._();

final class RemoteConfigDatasourceProvider
    extends
        $FunctionalProvider<
          RemoteConfigDatasource,
          RemoteConfigDatasource,
          RemoteConfigDatasource
        >
    with $Provider<RemoteConfigDatasource> {
  RemoteConfigDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigDatasourceHash();

  @$internal
  @override
  $ProviderElement<RemoteConfigDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoteConfigDatasource create(Ref ref) {
    return remoteConfigDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfigDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteConfigDatasource>(value),
    );
  }
}

String _$remoteConfigDatasourceHash() =>
    r'9d18fc2af14bcc3ea4814e41800397fd1824bdfa';
