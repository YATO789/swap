// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../theme_mode_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。

@ProviderFor(ThemeModeRepository)
final themeModeRepositoryProvider = ThemeModeRepositoryProvider._();

/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。
final class ThemeModeRepositoryProvider
    extends $NotifierProvider<ThemeModeRepository, ThemeMode> {
  /// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。
  ThemeModeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeRepositoryHash();

  @$internal
  @override
  ThemeModeRepository create() => ThemeModeRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeRepositoryHash() =>
    r'a1e59b07f9e47015df7d54ce1b64d689bf739846';

/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。

abstract class _$ThemeModeRepository extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
