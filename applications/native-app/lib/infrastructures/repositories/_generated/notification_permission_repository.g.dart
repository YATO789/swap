// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../notification_permission_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationPermissionRepository)
final notificationPermissionRepositoryProvider =
    NotificationPermissionRepositoryProvider._();

final class NotificationPermissionRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationPermissionRepository,
          NotificationPermissionRepository,
          NotificationPermissionRepository
        >
    with $Provider<NotificationPermissionRepository> {
  NotificationPermissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationPermissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationPermissionRepository create(Ref ref) {
    return notificationPermissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationPermissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationPermissionRepository>(
        value,
      ),
    );
  }
}

String _$notificationPermissionRepositoryHash() =>
    r'5a174ba8d3ecc41987ce56778e83a5297c02ecc3';
