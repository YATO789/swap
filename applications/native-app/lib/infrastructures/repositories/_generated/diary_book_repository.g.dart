// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。

@ProviderFor(DiaryBookRepository)
final diaryBookRepositoryProvider = DiaryBookRepositoryProvider._();

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。
final class DiaryBookRepositoryProvider
    extends $AsyncNotifierProvider<DiaryBookRepository, List<DiaryBook>> {
  /// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
  ///
  /// サインイン・サインアウトのたびに読み直す。
  DiaryBookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookRepositoryHash();

  @$internal
  @override
  DiaryBookRepository create() => DiaryBookRepository();
}

String _$diaryBookRepositoryHash() =>
    r'9fff5dfaabaf6586e6f43d7e69d2dc5ef1b46ef6';

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。

abstract class _$DiaryBookRepository extends $AsyncNotifier<List<DiaryBook>> {
  FutureOr<List<DiaryBook>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<DiaryBook>>, List<DiaryBook>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DiaryBook>>, List<DiaryBook>>,
              AsyncValue<List<DiaryBook>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
