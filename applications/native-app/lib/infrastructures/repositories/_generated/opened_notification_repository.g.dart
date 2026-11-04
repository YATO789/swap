// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../opened_notification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openedNotificationRepository)
final openedNotificationRepositoryProvider =
    OpenedNotificationRepositoryProvider._();

final class OpenedNotificationRepositoryProvider
    extends
        $FunctionalProvider<
          OpenedNotificationRepository,
          OpenedNotificationRepository,
          OpenedNotificationRepository
        >
    with $Provider<OpenedNotificationRepository> {
  OpenedNotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openedNotificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openedNotificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<OpenedNotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenedNotificationRepository create(Ref ref) {
    return openedNotificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenedNotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenedNotificationRepository>(value),
    );
  }
}

String _$openedNotificationRepositoryHash() =>
    r'4f19b49b22ef414bd3a5cfd5bcc13d54dce8c9c3';
