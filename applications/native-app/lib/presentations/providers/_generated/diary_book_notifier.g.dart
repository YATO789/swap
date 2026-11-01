// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。

@ProviderFor(DiaryBookNotifier)
final diaryBookProvider = DiaryBookNotifierProvider._();

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。
final class DiaryBookNotifierProvider
    extends $AsyncNotifierProvider<DiaryBookNotifier, List<DiaryBook>> {
  /// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
  ///
  /// サインイン・サインアウトのたびに読み直す。
  DiaryBookNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookNotifierHash();

  @$internal
  @override
  DiaryBookNotifier create() => DiaryBookNotifier();
}

String _$diaryBookNotifierHash() => r'88cbe73c2b9b7bf95340acecd8c2de442c12ab0c';

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。

abstract class _$DiaryBookNotifier extends $AsyncNotifier<List<DiaryBook>> {
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
