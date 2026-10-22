// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../theme_mode_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。

@ProviderFor(ThemeModeHelper)
final themeModeProvider = ThemeModeHelperProvider._();

/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。
final class ThemeModeHelperProvider
    extends $NotifierProvider<ThemeModeHelper, ThemeMode> {
  /// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。
  ThemeModeHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHelperHash();

  @$internal
  @override
  ThemeModeHelper create() => ThemeModeHelper();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeHelperHash() => r'3711ad6bf74d0f5c755919fe72acc8127d12bc3f';

/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。設定画面で切り替える。

abstract class _$ThemeModeHelper extends $Notifier<ThemeMode> {
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
