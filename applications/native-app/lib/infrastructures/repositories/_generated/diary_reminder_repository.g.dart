// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_reminder_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryReminderRepository)
final diaryReminderRepositoryProvider = DiaryReminderRepositoryProvider._();

final class DiaryReminderRepositoryProvider
    extends
        $FunctionalProvider<
          DiaryReminderRepository,
          DiaryReminderRepository,
          DiaryReminderRepository
        >
    with $Provider<DiaryReminderRepository> {
  DiaryReminderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryReminderRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryReminderRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiaryReminderRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiaryReminderRepository create(Ref ref) {
    return diaryReminderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryReminderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryReminderRepository>(value),
    );
  }
}

String _$diaryReminderRepositoryHash() =>
    r'28747c050137961e0aafe5268fa8ccfb90f5266d';
