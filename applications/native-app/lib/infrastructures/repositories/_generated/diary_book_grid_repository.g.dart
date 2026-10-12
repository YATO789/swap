// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_grid_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。

@ProviderFor(DiaryBookGridRepository)
final diaryBookGridRepositoryProvider = DiaryBookGridRepositoryProvider._();

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。
final class DiaryBookGridRepositoryProvider
    extends $NotifierProvider<DiaryBookGridRepository, bool> {
  /// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
  /// 設定画面で切り替える。
  DiaryBookGridRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookGridRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookGridRepositoryHash();

  @$internal
  @override
  DiaryBookGridRepository create() => DiaryBookGridRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$diaryBookGridRepositoryHash() =>
    r'5e290f536ecd8c17352be9791c2a5a19dec3eb78';

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。

abstract class _$DiaryBookGridRepository extends $Notifier<bool> {
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
