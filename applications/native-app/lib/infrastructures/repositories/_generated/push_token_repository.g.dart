// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../push_token_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトの前に [unregister] で送り先から外し、サインアウトしたらトークンも無効にして、
/// 前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

@ProviderFor(PushTokenRepository)
final pushTokenRepositoryProvider = PushTokenRepositoryProvider._();

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトの前に [unregister] で送り先から外し、サインアウトしたらトークンも無効にして、
/// 前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
final class PushTokenRepositoryProvider
    extends $AsyncNotifierProvider<PushTokenRepository, void> {
  /// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
  ///
  /// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
  /// サインアウトの前に [unregister] で送り先から外し、サインアウトしたらトークンも無効にして、
  /// 前のアカウントの通知が届かないようにする。
  /// サインイン状態を追い続けるので、一度読んだら破棄しない。
  PushTokenRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenRepositoryHash();

  @$internal
  @override
  PushTokenRepository create() => PushTokenRepository();
}

String _$pushTokenRepositoryHash() =>
    r'bab5b8ef232d53cfb43a9e2f7866cdb0bcb682cf';

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトの前に [unregister] で送り先から外し、サインアウトしたらトークンも無効にして、
/// 前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

abstract class _$PushTokenRepository extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
