// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../messaging_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messagingDatasource)
final messagingDatasourceProvider = MessagingDatasourceProvider._();

final class MessagingDatasourceProvider
    extends
        $FunctionalProvider<
          MessagingDatasource,
          MessagingDatasource,
          MessagingDatasource
        >
    with $Provider<MessagingDatasource> {
  MessagingDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagingDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagingDatasourceHash();

  @$internal
  @override
  $ProviderElement<MessagingDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessagingDatasource create(Ref ref) {
    return messagingDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagingDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagingDatasource>(value),
    );
  }
}

String _$messagingDatasourceHash() =>
    r'aa6a5af1129b98b1beec3ef25f0636b3458f4450';
