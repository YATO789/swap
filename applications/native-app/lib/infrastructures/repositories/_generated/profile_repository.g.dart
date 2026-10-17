// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。画面の切り替えにも使うので破棄しない。

@ProviderFor(ProfileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。画面の切り替えにも使うので破棄しない。
final class ProfileRepositoryProvider
    extends $AsyncNotifierProvider<ProfileRepository, Profile?> {
  /// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
  ///
  /// サインイン・サインアウトのたびに読み直す。画面の切り替えにも使うので破棄しない。
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  ProfileRepository create() => ProfileRepository();
}

String _$profileRepositoryHash() => r'9b6079d90072c8fcae095c8cca40619c008baa8e';

/// 自分のプロフィールを持つ。サインインしていないか、まだ作っていなければ null。
///
/// サインイン・サインアウトのたびに読み直す。画面の切り替えにも使うので破棄しない。

abstract class _$ProfileRepository extends $AsyncNotifier<Profile?> {
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
