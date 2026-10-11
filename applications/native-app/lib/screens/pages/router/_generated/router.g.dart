// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アプリの画面遷移。サインインしていなければウェルカム画面、していればホームを出す。
///
/// サインイン状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// アプリの画面遷移。サインインしていなければウェルカム画面、していればホームを出す。
///
/// サインイン状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// アプリの画面遷移。サインインしていなければウェルカム画面、していればホームを出す。
  ///
  /// サインイン状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'24165541b5bb51709f4ff014501ba0d5e2636c95';
