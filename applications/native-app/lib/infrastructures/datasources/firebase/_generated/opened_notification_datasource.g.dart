// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../opened_notification_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openedNotificationDatasource)
final openedNotificationDatasourceProvider =
    OpenedNotificationDatasourceProvider._();

final class OpenedNotificationDatasourceProvider
    extends
        $FunctionalProvider<
          OpenedNotificationDatasource,
          OpenedNotificationDatasource,
          OpenedNotificationDatasource
        >
    with $Provider<OpenedNotificationDatasource> {
  OpenedNotificationDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openedNotificationDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openedNotificationDatasourceHash();

  @$internal
  @override
  $ProviderElement<OpenedNotificationDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenedNotificationDatasource create(Ref ref) {
    return openedNotificationDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenedNotificationDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenedNotificationDatasource>(value),
    );
  }
}

String _$openedNotificationDatasourceHash() =>
    r'1aa5defe97dd1da2d6aa95c9970ef0aaa130d125';
