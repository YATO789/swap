// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../feedback_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// フィードバックのページの送信を受け持つ。状態は送信の進み具合。

@ProviderFor(FeedbackPageController)
final feedbackPageControllerProvider = FeedbackPageControllerProvider._();

/// フィードバックのページの送信を受け持つ。状態は送信の進み具合。
final class FeedbackPageControllerProvider
    extends $NotifierProvider<FeedbackPageController, AsyncValue<void>> {
  /// フィードバックのページの送信を受け持つ。状態は送信の進み具合。
  FeedbackPageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedbackPageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedbackPageControllerHash();

  @$internal
  @override
  FeedbackPageController create() => FeedbackPageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$feedbackPageControllerHash() =>
    r'4af6125052f54dc72fbeeaefe5988f89c215ed20';

/// フィードバックのページの送信を受け持つ。状態は送信の進み具合。

abstract class _$FeedbackPageController extends $Notifier<AsyncValue<void>> {
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
