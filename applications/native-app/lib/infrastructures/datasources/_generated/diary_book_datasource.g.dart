// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryBookDatasource)
final diaryBookDatasourceProvider = DiaryBookDatasourceProvider._();

final class DiaryBookDatasourceProvider
    extends
        $FunctionalProvider<
          DiaryBookDatasource,
          DiaryBookDatasource,
          DiaryBookDatasource
        >
    with $Provider<DiaryBookDatasource> {
  DiaryBookDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookDatasourceHash();

  @$internal
  @override
  $ProviderElement<DiaryBookDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiaryBookDatasource create(Ref ref) {
    return diaryBookDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryBookDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryBookDatasource>(value),
    );
  }
}

String _$diaryBookDatasourceHash() =>
    r'bc6b1a42332fd1dfe2b89d9475b59d6876e07a6b';
