// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../feedback_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(feedbackDatasource)
final feedbackDatasourceProvider = FeedbackDatasourceProvider._();

final class FeedbackDatasourceProvider
    extends
        $FunctionalProvider<
          FeedbackDatasource,
          FeedbackDatasource,
          FeedbackDatasource
        >
    with $Provider<FeedbackDatasource> {
  FeedbackDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedbackDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedbackDatasourceHash();

  @$internal
  @override
  $ProviderElement<FeedbackDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeedbackDatasource create(Ref ref) {
    return feedbackDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedbackDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedbackDatasource>(value),
    );
  }
}

String _$feedbackDatasourceHash() =>
    r'9beb865b2983c6d6f2e29a658b3b13a5f17a7bea';
