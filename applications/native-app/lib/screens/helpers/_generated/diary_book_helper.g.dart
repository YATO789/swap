// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。

@ProviderFor(DiaryBookHelper)
final diaryBookProvider = DiaryBookHelperProvider._();

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。
final class DiaryBookHelperProvider
    extends $AsyncNotifierProvider<DiaryBookHelper, List<DiaryBook>> {
  /// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
  ///
  /// サインイン・サインアウトのたびに読み直す。
  DiaryBookHelperProvider._()
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
  String debugGetCreateSourceHash() => _$diaryBookHelperHash();

  @$internal
  @override
  DiaryBookHelper create() => DiaryBookHelper();
}

String _$diaryBookHelperHash() => r'5c213d9b02ac73dae9da71906f9bbe748bd093c5';

/// 自分が参加している日記帳の一覧を持つ。サインインしていなければ空。
///
/// サインイン・サインアウトのたびに読み直す。

abstract class _$DiaryBookHelper extends $AsyncNotifier<List<DiaryBook>> {
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
