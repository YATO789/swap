// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../authentication_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。

@ProviderFor(AuthenticationUsecase)
final authenticationUsecaseProvider = AuthenticationUsecaseProvider._();

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。
final class AuthenticationUsecaseProvider
    extends $NotifierProvider<AuthenticationUsecase, Authentication> {
  /// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
  ///
  /// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。
  AuthenticationUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationUsecaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationUsecaseHash();

  @$internal
  @override
  AuthenticationUsecase create() => AuthenticationUsecase();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Authentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Authentication>(value),
    );
  }
}

String _$authenticationUsecaseHash() =>
    r'07933ce4965b0a4bc1bdcadd526088c77b1bb885';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。

abstract class _$AuthenticationUsecase extends $Notifier<Authentication> {
  Authentication build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Authentication, Authentication>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Authentication, Authentication>,
              Authentication,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
