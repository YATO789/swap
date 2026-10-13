// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_hint_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの書き込みバーに添える手書きの説明のうち、どれを出すか。
/// 使い方が分かれば要らないので、記録したら入力欄の説明を、
/// 日記を書くページを開いたらペンの説明を、それぞれ消す。

@ProviderFor(PostHintRepository)
final postHintRepositoryProvider = PostHintRepositoryProvider._();

/// ホームの書き込みバーに添える手書きの説明のうち、どれを出すか。
/// 使い方が分かれば要らないので、記録したら入力欄の説明を、
/// 日記を書くページを開いたらペンの説明を、それぞれ消す。
final class PostHintRepositoryProvider
    extends $NotifierProvider<PostHintRepository, ({bool diary, bool post})> {
  /// ホームの書き込みバーに添える手書きの説明のうち、どれを出すか。
  /// 使い方が分かれば要らないので、記録したら入力欄の説明を、
  /// 日記を書くページを開いたらペンの説明を、それぞれ消す。
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
  Override overrideWithValue(({bool diary, bool post}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({bool diary, bool post})>(value),
    );
  }
}

String _$postHintRepositoryHash() =>
    r'add2a7a37af9b5ea2c8babe7d624a2b3c6d4f90a';

/// ホームの書き込みバーに添える手書きの説明のうち、どれを出すか。
/// 使い方が分かれば要らないので、記録したら入力欄の説明を、
/// 日記を書くページを開いたらペンの説明を、それぞれ消す。

abstract class _$PostHintRepository
    extends $Notifier<({bool diary, bool post})> {
  ({bool diary, bool post}) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<({bool diary, bool post}), ({bool diary, bool post})>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<({bool diary, bool post}), ({bool diary, bool post})>,
              ({bool diary, bool post}),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
