// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_diary_book_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。

@ProviderFor(PostDiaryBookRepository)
final postDiaryBookRepositoryProvider = PostDiaryBookRepositoryProvider._();

/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。
final class PostDiaryBookRepositoryProvider
    extends $NotifierProvider<PostDiaryBookRepository, Set<String>> {
  /// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
  /// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。
  PostDiaryBookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postDiaryBookRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postDiaryBookRepositoryHash();

  @$internal
  @override
  PostDiaryBookRepository create() => PostDiaryBookRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$postDiaryBookRepositoryHash() =>
    r'ae56ec1956a14dfe529f8ef4e6d3a4dcd58e5dea';

/// 投稿シートで前に選んだ共有先の日記帳の id を持つ。次に開いたときも選んだままにする。
/// 抜けた日記帳の id が残っていることもあるので、使う側で参加している日記帳と突き合わせる。

abstract class _$PostDiaryBookRepository extends $Notifier<Set<String>> {
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
