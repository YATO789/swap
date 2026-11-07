// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../local_notification_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 通知のタップを受け取る口を一つにしたいので、一度作ったら破棄しない。

@ProviderFor(localNotificationDatasource)
final localNotificationDatasourceProvider =
    LocalNotificationDatasourceProvider._();

/// 通知のタップを受け取る口を一つにしたいので、一度作ったら破棄しない。

final class LocalNotificationDatasourceProvider
    extends
        $FunctionalProvider<
          LocalNotificationDatasource,
          LocalNotificationDatasource,
          LocalNotificationDatasource
        >
    with $Provider<LocalNotificationDatasource> {
  /// 通知のタップを受け取る口を一つにしたいので、一度作ったら破棄しない。
  LocalNotificationDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localNotificationDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationDatasourceHash();

  @$internal
  @override
  $ProviderElement<LocalNotificationDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalNotificationDatasource create(Ref ref) {
    return localNotificationDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalNotificationDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalNotificationDatasource>(value),
    );
  }
}

String _$localNotificationDatasourceHash() =>
    r'88c7341218c16189a54b38551d79ce9db442dcda';
