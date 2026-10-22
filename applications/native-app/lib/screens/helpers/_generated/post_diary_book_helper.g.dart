// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_diary_book_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。

@ProviderFor(PostDiaryBookHelper)
final postDiaryBookProvider = PostDiaryBookHelperProvider._();

/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。
final class PostDiaryBookHelperProvider
    extends $NotifierProvider<PostDiaryBookHelper, Set<String>> {
  /// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
  /// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。
  PostDiaryBookHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postDiaryBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postDiaryBookHelperHash();

  @$internal
  @override
  PostDiaryBookHelper create() => PostDiaryBookHelper();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$postDiaryBookHelperHash() =>
    r'5875ca37107560fcaa7273740b2bc5d99b10bbaa';

/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。

abstract class _$PostDiaryBookHelper extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
