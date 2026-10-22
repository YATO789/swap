// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryBookRepository)
final diaryBookRepositoryProvider = DiaryBookRepositoryProvider._();

final class DiaryBookRepositoryProvider
    extends
        $FunctionalProvider<
          DiaryBookRepository,
          DiaryBookRepository,
          DiaryBookRepository
        >
    with $Provider<DiaryBookRepository> {
  DiaryBookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiaryBookRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiaryBookRepository create(Ref ref) {
    return diaryBookRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryBookRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryBookRepository>(value),
    );
  }
}

String _$diaryBookRepositoryHash() =>
    r'5c19a9a215f32346ec53606c19574bde53173f9f';
