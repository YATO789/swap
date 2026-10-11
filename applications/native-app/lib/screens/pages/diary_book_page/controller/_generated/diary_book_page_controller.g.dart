// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。

@ProviderFor(DiaryBookPageController)
final diaryBookPageControllerProvider = DiaryBookPageControllerFamily._();

/// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。
final class DiaryBookPageControllerProvider
    extends
        $AsyncNotifierProvider<DiaryBookPageController, DiaryBookPageState> {
  /// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。
  DiaryBookPageControllerProvider._({
    required DiaryBookPageControllerFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'diaryBookPageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryBookPageControllerHash();

  @override
  String toString() {
    return r'diaryBookPageControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DiaryBookPageController create() => DiaryBookPageController();

  @override
  bool operator ==(Object other) {
    return other is DiaryBookPageControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryBookPageControllerHash() =>
    r'dbbfcd647143498175da85e68964b35f01665e7f';

/// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。

final class DiaryBookPageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryBookPageController,
          AsyncValue<DiaryBookPageState>,
          DiaryBookPageState,
          FutureOr<DiaryBookPageState>,
          (String, DateTime)
        > {
  DiaryBookPageControllerFamily._()
    : super(
        retry: null,
        name: r'diaryBookPageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。

  DiaryBookPageControllerProvider call(String diaryBookId, DateTime date) =>
      DiaryBookPageControllerProvider._(
        argument: (diaryBookId, date),
        from: this,
      );

  @override
  String toString() => r'diaryBookPageControllerProvider';
}

/// 日記帳のページで、[diaryBookId] の日記帳の [date] の日記と記録を読む。

abstract class _$DiaryBookPageController
    extends $AsyncNotifier<DiaryBookPageState> {
  late final _$args = ref.$arg as (String, DateTime);
  String get diaryBookId => _$args.$1;
  DateTime get date => _$args.$2;

  FutureOr<DiaryBookPageState> build(String diaryBookId, DateTime date);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DiaryBookPageState>, DiaryBookPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiaryBookPageState>, DiaryBookPageState>,
              AsyncValue<DiaryBookPageState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
