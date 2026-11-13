// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../track_preview_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// いま試聴を流している曲の id を持つ。流していなければ null。
/// どの画面の再生ボタンからでも同じ曲を止められるよう、アプリで1つにする。

@ProviderFor(TrackPreviewNotifier)
final trackPreviewProvider = TrackPreviewNotifierProvider._();

/// いま試聴を流している曲の id を持つ。流していなければ null。
/// どの画面の再生ボタンからでも同じ曲を止められるよう、アプリで1つにする。
final class TrackPreviewNotifierProvider
    extends $NotifierProvider<TrackPreviewNotifier, String?> {
  /// いま試聴を流している曲の id を持つ。流していなければ null。
  /// どの画面の再生ボタンからでも同じ曲を止められるよう、アプリで1つにする。
  TrackPreviewNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackPreviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackPreviewNotifierHash();

  @$internal
  @override
  TrackPreviewNotifier create() => TrackPreviewNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$trackPreviewNotifierHash() =>
    r'773e45d3c84cc8c5c723c929ab87402c0dcab144';

/// いま試聴を流している曲の id を持つ。流していなければ null。
/// どの画面の再生ボタンからでも同じ曲を止められるよう、アプリで1つにする。

abstract class _$TrackPreviewNotifier extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
