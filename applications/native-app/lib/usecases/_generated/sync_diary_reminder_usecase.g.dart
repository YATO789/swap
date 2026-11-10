// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sync_diary_reminder_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncDiaryReminderUseCase)
final syncDiaryReminderUseCaseProvider = SyncDiaryReminderUseCaseProvider._();

final class SyncDiaryReminderUseCaseProvider
    extends
        $FunctionalProvider<
          SyncDiaryReminderUseCase,
          SyncDiaryReminderUseCase,
          SyncDiaryReminderUseCase
        >
    with $Provider<SyncDiaryReminderUseCase> {
  SyncDiaryReminderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncDiaryReminderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncDiaryReminderUseCaseHash();

  @$internal
  @override
  $ProviderElement<SyncDiaryReminderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SyncDiaryReminderUseCase create(Ref ref) {
    return syncDiaryReminderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncDiaryReminderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncDiaryReminderUseCase>(value),
    );
  }
}

String _$syncDiaryReminderUseCaseHash() =>
    r'005030f8737b44c6e26f39ae578efa62dd876d51';
