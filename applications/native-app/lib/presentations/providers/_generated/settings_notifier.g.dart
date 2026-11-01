// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 設定画面で切り替える設定を持ち、変えたら端末に保存する。
/// 使う側は select で必要な項目だけを見る。

@ProviderFor(SettingsNotifier)
final settingsProvider = SettingsNotifierProvider._();

/// 設定画面で切り替える設定を持ち、変えたら端末に保存する。
/// 使う側は select で必要な項目だけを見る。
final class SettingsNotifierProvider
    extends $NotifierProvider<SettingsNotifier, Settings> {
  /// 設定画面で切り替える設定を持ち、変えたら端末に保存する。
  /// 使う側は select で必要な項目だけを見る。
  SettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Settings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Settings>(value),
    );
  }
}

String _$settingsNotifierHash() => r'72b150cc2c873d1bf490c3508a9a44b5ed22a4e9';

/// 設定画面で切り替える設定を持ち、変えたら端末に保存する。
/// 使う側は select で必要な項目だけを見る。

abstract class _$SettingsNotifier extends $Notifier<Settings> {
  Settings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Settings, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Settings, Settings>,
              Settings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
