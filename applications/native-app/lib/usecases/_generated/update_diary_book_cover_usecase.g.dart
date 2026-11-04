// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../update_diary_book_cover_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updateDiaryBookCoverUseCase)
final updateDiaryBookCoverUseCaseProvider =
    UpdateDiaryBookCoverUseCaseProvider._();

final class UpdateDiaryBookCoverUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateDiaryBookCoverUseCase,
          UpdateDiaryBookCoverUseCase,
          UpdateDiaryBookCoverUseCase
        >
    with $Provider<UpdateDiaryBookCoverUseCase> {
  UpdateDiaryBookCoverUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateDiaryBookCoverUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateDiaryBookCoverUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateDiaryBookCoverUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateDiaryBookCoverUseCase create(Ref ref) {
    return updateDiaryBookCoverUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateDiaryBookCoverUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateDiaryBookCoverUseCase>(value),
    );
  }
}

String _$updateDiaryBookCoverUseCaseHash() =>
    r'a01637611821a41be22c5eeaccafeea8ea3c4f45';
