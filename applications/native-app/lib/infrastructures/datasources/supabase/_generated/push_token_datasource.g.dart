// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../push_token_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pushTokenDatasource)
final pushTokenDatasourceProvider = PushTokenDatasourceProvider._();

final class PushTokenDatasourceProvider
    extends
        $FunctionalProvider<
          PushTokenDatasource,
          PushTokenDatasource,
          PushTokenDatasource
        >
    with $Provider<PushTokenDatasource> {
  PushTokenDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenDatasourceHash();

  @$internal
  @override
  $ProviderElement<PushTokenDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushTokenDatasource create(Ref ref) {
    return pushTokenDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushTokenDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushTokenDatasource>(value),
    );
  }
}

String _$pushTokenDatasourceHash() =>
    r'7d2ce5390a7635792e2d91d6843f773a53590ab1';
