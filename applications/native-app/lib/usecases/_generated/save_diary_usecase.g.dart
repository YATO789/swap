// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../save_diary_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(saveDiaryUseCase)
final saveDiaryUseCaseProvider = SaveDiaryUseCaseProvider._();

final class SaveDiaryUseCaseProvider
    extends
        $FunctionalProvider<
          SaveDiaryUseCase,
          SaveDiaryUseCase,
          SaveDiaryUseCase
        >
    with $Provider<SaveDiaryUseCase> {
  SaveDiaryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveDiaryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveDiaryUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveDiaryUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaveDiaryUseCase create(Ref ref) {
    return saveDiaryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveDiaryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveDiaryUseCase>(value),
    );
  }
}

String _$saveDiaryUseCaseHash() => r'96507b3c514291877cd714def64a34792bd93cd1';
