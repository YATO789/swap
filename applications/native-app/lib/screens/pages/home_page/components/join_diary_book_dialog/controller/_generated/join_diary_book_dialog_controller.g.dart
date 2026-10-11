// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../join_diary_book_dialog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 招待コードで参加するダイアログの、確認と参加の処理を受け持つ。状態は処理の進み具合。

@ProviderFor(JoinDiaryBookDialogController)
final joinDiaryBookDialogControllerProvider =
    JoinDiaryBookDialogControllerProvider._();

/// 招待コードで参加するダイアログの、確認と参加の処理を受け持つ。状態は処理の進み具合。
final class JoinDiaryBookDialogControllerProvider
    extends $NotifierProvider<JoinDiaryBookDialogController, AsyncValue<void>> {
  /// 招待コードで参加するダイアログの、確認と参加の処理を受け持つ。状態は処理の進み具合。
  JoinDiaryBookDialogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'joinDiaryBookDialogControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$joinDiaryBookDialogControllerHash();

  @$internal
  @override
  JoinDiaryBookDialogController create() => JoinDiaryBookDialogController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$joinDiaryBookDialogControllerHash() =>
    r'abf24f56ebe68c70fe33f21bb13113a40063c21d';

/// 招待コードで参加するダイアログの、確認と参加の処理を受け持つ。状態は処理の進み具合。

abstract class _$JoinDiaryBookDialogController
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
