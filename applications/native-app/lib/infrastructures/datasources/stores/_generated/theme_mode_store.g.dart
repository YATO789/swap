// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../theme_mode_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themeModeStore)
final themeModeStoreProvider = ThemeModeStoreProvider._();

final class ThemeModeStoreProvider
    extends $FunctionalProvider<ThemeModeStore, ThemeModeStore, ThemeModeStore>
    with $Provider<ThemeModeStore> {
  ThemeModeStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeStoreHash();

  @$internal
  @override
  $ProviderElement<ThemeModeStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeModeStore create(Ref ref) {
    return themeModeStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeModeStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeModeStore>(value),
    );
  }
}

String _$themeModeStoreHash() => r'a8a02ee5a6b327bd26564edd4cb504cb99c56e65';
