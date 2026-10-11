// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../authentication_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。

@ProviderFor(AuthenticationRepository)
final authenticationRepositoryProvider = AuthenticationRepositoryProvider._();

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。
final class AuthenticationRepositoryProvider
    extends $NotifierProvider<AuthenticationRepository, Authentication> {
  /// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
  ///
  /// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。
  AuthenticationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationRepositoryHash();

  @$internal
  @override
  AuthenticationRepository create() => AuthenticationRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Authentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Authentication>(value),
    );
  }
}

String _$authenticationRepositoryHash() =>
    r'7c6310bee744f8144262748636f9f3e652b9246e';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。

abstract class _$AuthenticationRepository extends $Notifier<Authentication> {
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
