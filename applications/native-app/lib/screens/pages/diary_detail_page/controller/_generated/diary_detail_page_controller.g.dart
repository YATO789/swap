// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_detail_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。

@ProviderFor(DiaryDetailPageController)
final diaryDetailPageControllerProvider = DiaryDetailPageControllerFamily._();

/// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。
final class DiaryDetailPageControllerProvider
    extends
        $AsyncNotifierProvider<
          DiaryDetailPageController,
          DiaryDetailPageState
        > {
  /// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。
  DiaryDetailPageControllerProvider._({
    required DiaryDetailPageControllerFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'diaryDetailPageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryDetailPageControllerHash();

  @override
  String toString() {
    return r'diaryDetailPageControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DiaryDetailPageController create() => DiaryDetailPageController();

  @override
  bool operator ==(Object other) {
    return other is DiaryDetailPageControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryDetailPageControllerHash() =>
    r'7139345c893daac86c789a185e8e9c2ab73192dc';

/// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。

final class DiaryDetailPageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryDetailPageController,
          AsyncValue<DiaryDetailPageState>,
          DiaryDetailPageState,
          FutureOr<DiaryDetailPageState>,
          (String, DateTime)
        > {
  DiaryDetailPageControllerFamily._()
    : super(
        retry: null,
        name: r'diaryDetailPageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。

  DiaryDetailPageControllerProvider call(String diaryBookId, DateTime date) =>
      DiaryDetailPageControllerProvider._(
        argument: (diaryBookId, date),
        from: this,
      );

  @override
  String toString() => r'diaryDetailPageControllerProvider';
}

/// 日記の詳細ページで、[diaryBookId] の日記帳の [date] の日記を読む。

abstract class _$DiaryDetailPageController
    extends $AsyncNotifier<DiaryDetailPageState> {
  late final _$args = ref.$arg as (String, DateTime);
  String get diaryBookId => _$args.$1;
  DateTime get date => _$args.$2;

  FutureOr<DiaryDetailPageState> build(String diaryBookId, DateTime date);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DiaryDetailPageState>, DiaryDetailPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DiaryDetailPageState>,
                DiaryDetailPageState
              >,
              AsyncValue<DiaryDetailPageState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
