// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../popular_tracks_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 曲を探すシートで、何も打つ前に並べる人気の曲を持つ。
///
/// 人気の曲のフィードはときどき返るのが遅いので、一度取れたらアプリを閉じるまで持ち続け、
/// シートを開くたびには取りに行かない。

@ProviderFor(PopularTracksNotifier)
final popularTracksProvider = PopularTracksNotifierProvider._();

/// 曲を探すシートで、何も打つ前に並べる人気の曲を持つ。
///
/// 人気の曲のフィードはときどき返るのが遅いので、一度取れたらアプリを閉じるまで持ち続け、
/// シートを開くたびには取りに行かない。
final class PopularTracksNotifierProvider
    extends $AsyncNotifierProvider<PopularTracksNotifier, List<Track>> {
  /// 曲を探すシートで、何も打つ前に並べる人気の曲を持つ。
  ///
  /// 人気の曲のフィードはときどき返るのが遅いので、一度取れたらアプリを閉じるまで持ち続け、
  /// シートを開くたびには取りに行かない。
  PopularTracksNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularTracksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularTracksNotifierHash();

  @$internal
  @override
  PopularTracksNotifier create() => PopularTracksNotifier();
}

String _$popularTracksNotifierHash() =>
    r'f67d77a7538320134f954f415146b0c1fe14f4ba';

/// 曲を探すシートで、何も打つ前に並べる人気の曲を持つ。
///
/// 人気の曲のフィードはときどき返るのが遅いので、一度取れたらアプリを閉じるまで持ち続け、
/// シートを開くたびには取りに行かない。

abstract class _$PopularTracksNotifier extends $AsyncNotifier<List<Track>> {
  FutureOr<List<Track>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Track>>, List<Track>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Track>>, List<Track>>,
              AsyncValue<List<Track>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
