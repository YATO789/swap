// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../authentication_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authenticationDatasource)
final authenticationDatasourceProvider = AuthenticationDatasourceProvider._();

final class AuthenticationDatasourceProvider
    extends
        $FunctionalProvider<
          AuthenticationDatasource,
          AuthenticationDatasource,
          AuthenticationDatasource
        >
    with $Provider<AuthenticationDatasource> {
  AuthenticationDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationDatasourceHash();

  @$internal
  @override
  $ProviderElement<AuthenticationDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthenticationDatasource create(Ref ref) {
    return authenticationDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticationDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticationDatasource>(value),
    );
  }
}

String _$authenticationDatasourceHash() =>
    r'13795aef4d83e2754a19b7c67eabffb0d53e2a35';
