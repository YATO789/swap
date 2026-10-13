// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_hint_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。

@ProviderFor(PostHintRepository)
final postHintRepositoryProvider = PostHintRepositoryProvider._();

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
final class PostHintRepositoryProvider
    extends $NotifierProvider<PostHintRepository, bool> {
  /// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
  PostHintRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postHintRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postHintRepositoryHash();

  @$internal
  @override
  PostHintRepository create() => PostHintRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$postHintRepositoryHash() =>
    r'86b480075174ecdccdf9505dc5d1ec7c3facdf7e';

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。

abstract class _$PostHintRepository extends $Notifier<bool> {
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
