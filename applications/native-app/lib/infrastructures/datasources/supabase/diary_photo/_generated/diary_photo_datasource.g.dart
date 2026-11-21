// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_photo_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryPhotoDatasource)
final diaryPhotoDatasourceProvider = DiaryPhotoDatasourceProvider._();

final class DiaryPhotoDatasourceProvider
    extends
        $FunctionalProvider<
          DiaryPhotoDatasource,
          DiaryPhotoDatasource,
          DiaryPhotoDatasource
        >
    with $Provider<DiaryPhotoDatasource> {
  DiaryPhotoDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryPhotoDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryPhotoDatasourceHash();

  @$internal
  @override
  $ProviderElement<DiaryPhotoDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiaryPhotoDatasource create(Ref ref) {
    return diaryPhotoDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryPhotoDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryPhotoDatasource>(value),
    );
  }
}

String _$diaryPhotoDatasourceHash() =>
    r'7bcb51b659d57d36a2d98b7fdb6591e18fc7fd69';
