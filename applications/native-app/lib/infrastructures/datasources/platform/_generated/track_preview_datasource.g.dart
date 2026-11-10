// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../track_preview_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 同時に鳴らすのは1曲だけにしたいので、プレイヤーは1つにして破棄しない。

@ProviderFor(trackPreviewDatasource)
final trackPreviewDatasourceProvider = TrackPreviewDatasourceProvider._();

/// 同時に鳴らすのは1曲だけにしたいので、プレイヤーは1つにして破棄しない。

final class TrackPreviewDatasourceProvider
    extends
        $FunctionalProvider<
          TrackPreviewDatasource,
          TrackPreviewDatasource,
          TrackPreviewDatasource
        >
    with $Provider<TrackPreviewDatasource> {
  /// 同時に鳴らすのは1曲だけにしたいので、プレイヤーは1つにして破棄しない。
  TrackPreviewDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackPreviewDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackPreviewDatasourceHash();

  @$internal
  @override
  $ProviderElement<TrackPreviewDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrackPreviewDatasource create(Ref ref) {
    return trackPreviewDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackPreviewDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackPreviewDatasource>(value),
    );
  }
}

String _$trackPreviewDatasourceHash() =>
    r'45f3df2ec6105518bf2b590b8c7dad5c259e94f8';
