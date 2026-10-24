// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_grid_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。

@ProviderFor(DiaryBookGridNotifier)
final diaryBookGridProvider = DiaryBookGridNotifierProvider._();

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。
final class DiaryBookGridNotifierProvider
    extends $NotifierProvider<DiaryBookGridNotifier, bool> {
  /// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
  /// 設定画面で切り替える。
  DiaryBookGridNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookGridProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookGridNotifierHash();

  @$internal
  @override
  DiaryBookGridNotifier create() => DiaryBookGridNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$diaryBookGridNotifierHash() =>
    r'3e032ad7d18a37838ca74304c7052b9993842471';

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。

abstract class _$DiaryBookGridNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
