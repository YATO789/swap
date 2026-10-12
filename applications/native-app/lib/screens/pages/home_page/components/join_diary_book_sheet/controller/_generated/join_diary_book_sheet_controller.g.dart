// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../join_diary_book_sheet_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 招待コードで参加するシートの、確認と参加の処理を受け持つ。状態は処理の進み具合。

@ProviderFor(JoinDiaryBookSheetController)
final joinDiaryBookSheetControllerProvider =
    JoinDiaryBookSheetControllerProvider._();

/// 招待コードで参加するシートの、確認と参加の処理を受け持つ。状態は処理の進み具合。
final class JoinDiaryBookSheetControllerProvider
    extends $NotifierProvider<JoinDiaryBookSheetController, AsyncValue<void>> {
  /// 招待コードで参加するシートの、確認と参加の処理を受け持つ。状態は処理の進み具合。
  JoinDiaryBookSheetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'joinDiaryBookSheetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$joinDiaryBookSheetControllerHash();

  @$internal
  @override
  JoinDiaryBookSheetController create() => JoinDiaryBookSheetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$joinDiaryBookSheetControllerHash() =>
    r'aaba88d54a3c29eaf95839c286fb01261255d2f7';

/// 招待コードで参加するシートの、確認と参加の処理を受け持つ。状態は処理の進み具合。

abstract class _$JoinDiaryBookSheetController
    extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
