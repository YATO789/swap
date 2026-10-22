// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。

@ProviderFor(ProfileHelper)
final profileProvider = ProfileHelperProvider._();

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。
final class ProfileHelperProvider
    extends $AsyncNotifierProvider<ProfileHelper, Profile?> {
  /// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
  ///
  /// サインイン・サインアウトのたびに読み直す。
  ProfileHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileHelperHash();

  @$internal
  @override
  ProfileHelper create() => ProfileHelper();
}

String _$profileHelperHash() => r'b412f83681dbcbe5e893fe5f190da00de2e6c72e';

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。

abstract class _$ProfileHelper extends $AsyncNotifier<Profile?> {
  FutureOr<Profile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Profile?>, Profile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Profile?>, Profile?>,
              AsyncValue<Profile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
