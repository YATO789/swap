// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_grid_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。

@ProviderFor(DiaryBookGridHelper)
final diaryBookGridProvider = DiaryBookGridHelperProvider._();

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。
final class DiaryBookGridHelperProvider
    extends $NotifierProvider<DiaryBookGridHelper, bool> {
  /// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
  /// 設定画面で切り替える。
  DiaryBookGridHelperProvider._()
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
  String debugGetCreateSourceHash() => _$diaryBookGridHelperHash();

  @$internal
  @override
  DiaryBookGridHelper create() => DiaryBookGridHelper();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$diaryBookGridHelperHash() =>
    r'2a6f5535133cdbeeae5a9e1db445b426cd83a590';

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。

abstract class _$DiaryBookGridHelper extends $Notifier<bool> {
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
