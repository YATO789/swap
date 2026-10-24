// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../push_token_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

@ProviderFor(PushTokenHelper)
final pushTokenProvider = PushTokenHelperProvider._();

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
final class PushTokenHelperProvider
    extends $AsyncNotifierProvider<PushTokenHelper, void> {
  /// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
  ///
  /// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
  /// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
  /// サインイン状態を追い続けるので、一度読んだら破棄しない。
  PushTokenHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenHelperHash();

  @$internal
  @override
  PushTokenHelper create() => PushTokenHelper();
}

String _$pushTokenHelperHash() => r'c3495538cbe6fdf62620b98e9c717cb4e4ab95f8';

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに通知の許可を聞いて FCM トークンを保存し、トークンが替わったら保存し直す。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

abstract class _$PushTokenHelper extends $AsyncNotifier<void> {
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
