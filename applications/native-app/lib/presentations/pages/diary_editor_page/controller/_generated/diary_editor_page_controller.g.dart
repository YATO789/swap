// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_editor_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。

@ProviderFor(DiaryEditorPageController)
final diaryEditorPageControllerProvider = DiaryEditorPageControllerFamily._();

/// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。
final class DiaryEditorPageControllerProvider
    extends
        $AsyncNotifierProvider<
          DiaryEditorPageController,
          DiaryEditorPageState
        > {
  /// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。
  DiaryEditorPageControllerProvider._({
    required DiaryEditorPageControllerFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'diaryEditorPageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryEditorPageControllerHash();

  @override
  String toString() {
    return r'diaryEditorPageControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiaryEditorPageController create() => DiaryEditorPageController();

  @override
  bool operator ==(Object other) {
    return other is DiaryEditorPageControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryEditorPageControllerHash() =>
    r'fabfe91727adac5e18615400cd7cf19f69436554';

/// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。

final class DiaryEditorPageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryEditorPageController,
          AsyncValue<DiaryEditorPageState>,
          DiaryEditorPageState,
          FutureOr<DiaryEditorPageState>,
          DateTime
        > {
  DiaryEditorPageControllerFamily._()
    : super(
        retry: null,
        name: r'diaryEditorPageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。

  DiaryEditorPageControllerProvider call(DateTime date) =>
      DiaryEditorPageControllerProvider._(argument: date, from: this);

  @override
  String toString() => r'diaryEditorPageControllerProvider';
}

/// 日記を書くページで、自分の [date] の日記と記録を読み、日記を書く。

abstract class _$DiaryEditorPageController
    extends $AsyncNotifier<DiaryEditorPageState> {
  late final _$args = ref.$arg as DateTime;
  DateTime get date => _$args;

  FutureOr<DiaryEditorPageState> build(DateTime date);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DiaryEditorPageState>, DiaryEditorPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DiaryEditorPageState>,
                DiaryEditorPageState
              >,
              AsyncValue<DiaryEditorPageState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
