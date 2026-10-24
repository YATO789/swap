// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_info_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
/// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
/// 日記帳から抜けたりする。

@ProviderFor(DiaryBookInfoPageController)
final diaryBookInfoPageControllerProvider =
    DiaryBookInfoPageControllerFamily._();

/// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
/// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
/// 日記帳から抜けたりする。
final class DiaryBookInfoPageControllerProvider
    extends
        $AsyncNotifierProvider<
          DiaryBookInfoPageController,
          DiaryBookInfoPageState
        > {
  /// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
  /// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
  /// 日記帳から抜けたりする。
  DiaryBookInfoPageControllerProvider._({
    required DiaryBookInfoPageControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'diaryBookInfoPageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryBookInfoPageControllerHash();

  @override
  String toString() {
    return r'diaryBookInfoPageControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiaryBookInfoPageController create() => DiaryBookInfoPageController();

  @override
  bool operator ==(Object other) {
    return other is DiaryBookInfoPageControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryBookInfoPageControllerHash() =>
    r'9dc0d345189189985ceee69537f09da13f5505c5';

/// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
/// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
/// 日記帳から抜けたりする。

final class DiaryBookInfoPageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryBookInfoPageController,
          AsyncValue<DiaryBookInfoPageState>,
          DiaryBookInfoPageState,
          FutureOr<DiaryBookInfoPageState>,
          String
        > {
  DiaryBookInfoPageControllerFamily._()
    : super(
        retry: null,
        name: r'diaryBookInfoPageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
  /// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
  /// 日記帳から抜けたりする。

  DiaryBookInfoPageControllerProvider call(String diaryBookId) =>
      DiaryBookInfoPageControllerProvider._(argument: diaryBookId, from: this);

  @override
  String toString() => r'diaryBookInfoPageControllerProvider';
}

/// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
/// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
/// 日記帳から抜けたりする。

abstract class _$DiaryBookInfoPageController
    extends $AsyncNotifier<DiaryBookInfoPageState> {
  late final _$args = ref.$arg as String;
  String get diaryBookId => _$args;

  FutureOr<DiaryBookInfoPageState> build(String diaryBookId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DiaryBookInfoPageState>, DiaryBookInfoPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DiaryBookInfoPageState>,
                DiaryBookInfoPageState
              >,
              AsyncValue<DiaryBookInfoPageState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
