// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryDatasource)
final diaryDatasourceProvider = DiaryDatasourceProvider._();

final class DiaryDatasourceProvider
    extends
        $FunctionalProvider<DiaryDatasource, DiaryDatasource, DiaryDatasource>
    with $Provider<DiaryDatasource> {
  DiaryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryDatasourceHash();

  @$internal
  @override
  $ProviderElement<DiaryDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiaryDatasource create(Ref ref) {
    return diaryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryDatasource>(value),
    );
  }
}

String _$diaryDatasourceHash() => r'2716b92e087e6d967471b5ed9f4270310533fa48';
