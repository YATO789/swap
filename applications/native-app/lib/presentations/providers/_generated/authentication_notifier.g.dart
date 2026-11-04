// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../authentication_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。

@ProviderFor(AuthenticationNotifier)
final authenticationProvider = AuthenticationNotifierProvider._();

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
final class AuthenticationNotifierProvider
    extends $NotifierProvider<AuthenticationNotifier, Authentication> {
  /// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
  AuthenticationNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$authenticationNotifierHash();

  @$internal
  @override
  AuthenticationNotifier create() => AuthenticationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Authentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Authentication>(value),
    );
  }
}

String _$authenticationNotifierHash() =>
    r'f2630c596686ff30a5d3f39b0260e3cdd2e543f0';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。

abstract class _$AuthenticationNotifier extends $Notifier<Authentication> {
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
