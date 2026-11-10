// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../track_preview_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trackPreviewRepository)
final trackPreviewRepositoryProvider = TrackPreviewRepositoryProvider._();

final class TrackPreviewRepositoryProvider
    extends
        $FunctionalProvider<
          TrackPreviewRepository,
          TrackPreviewRepository,
          TrackPreviewRepository
        >
    with $Provider<TrackPreviewRepository> {
  TrackPreviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackPreviewRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackPreviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<TrackPreviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrackPreviewRepository create(Ref ref) {
    return trackPreviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackPreviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackPreviewRepository>(value),
    );
  }
}

String _$trackPreviewRepositoryHash() =>
    r'f378c1acb0f9d084044e1b1f77a23c7416add0b6';
