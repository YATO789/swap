// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../authentication_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。

@ProviderFor(AuthenticationHelper)
final authenticationProvider = AuthenticationHelperProvider._();

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
final class AuthenticationHelperProvider
    extends $NotifierProvider<AuthenticationHelper, Authentication> {
  /// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
  AuthenticationHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationHelperHash();

  @$internal
  @override
  AuthenticationHelper create() => AuthenticationHelper();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Authentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Authentication>(value),
    );
  }
}

String _$authenticationHelperHash() =>
    r'944717984e314776092e4e455861c0f5661a6ed6';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。

abstract class _$AuthenticationHelper extends $Notifier<Authentication> {
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
