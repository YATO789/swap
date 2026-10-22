// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_hint_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。

@ProviderFor(PostHintHelper)
final postHintProvider = PostHintHelperProvider._();

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
final class PostHintHelperProvider
    extends $NotifierProvider<PostHintHelper, bool> {
  /// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
  PostHintHelperProvider._()
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
  String debugGetCreateSourceHash() => _$postHintHelperHash();

  @$internal
  @override
  PostHintHelper create() => PostHintHelper();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$postHintHelperHash() => r'30057d0021fa46279a81998a4223852a02bf817f';

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。

abstract class _$PostHintHelper extends $Notifier<bool> {
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
