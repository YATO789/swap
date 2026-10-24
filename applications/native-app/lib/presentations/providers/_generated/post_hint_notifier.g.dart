// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_hint_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。

@ProviderFor(PostHintNotifier)
final postHintProvider = PostHintNotifierProvider._();

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
final class PostHintNotifierProvider
    extends $NotifierProvider<PostHintNotifier, bool> {
  /// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
  PostHintNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postHintProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postHintNotifierHash();

  @$internal
  @override
  PostHintNotifier create() => PostHintNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$postHintNotifierHash() => r'2633d921fba25c859bff821eeb8727e9e5e289bd';

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。

abstract class _$PostHintNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
