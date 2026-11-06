// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../push_token_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに FCM トークンを保存し、トークンが替わったら保存し直す。
/// 通知の許可は聞かない（オンボーディングとホームで聞く）。許可がなくてもトークンは取れるので、
/// あとから端末の設定で通知をオンにすれば、保存したトークンにそのまま届く。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

@ProviderFor(PushTokenNotifier)
final pushTokenProvider = PushTokenNotifierProvider._();

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに FCM トークンを保存し、トークンが替わったら保存し直す。
/// 通知の許可は聞かない（オンボーディングとホームで聞く）。許可がなくてもトークンは取れるので、
/// あとから端末の設定で通知をオンにすれば、保存したトークンにそのまま届く。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
final class PushTokenNotifierProvider
    extends $AsyncNotifierProvider<PushTokenNotifier, void> {
  /// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
  ///
  /// サインインのたびに FCM トークンを保存し、トークンが替わったら保存し直す。
  /// 通知の許可は聞かない（オンボーディングとホームで聞く）。許可がなくてもトークンは取れるので、
  /// あとから端末の設定で通知をオンにすれば、保存したトークンにそのまま届く。
  /// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
  /// サインイン状態を追い続けるので、一度読んだら破棄しない。
  PushTokenNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$pushTokenNotifierHash();

  @$internal
  @override
  PushTokenNotifier create() => PushTokenNotifier();
}

String _$pushTokenNotifierHash() => r'79432f746095f867f9099d5056f663205dfdadd1';

/// サインインしている間、この端末を自分のプッシュ通知の送り先にしておく。
///
/// サインインのたびに FCM トークンを保存し、トークンが替わったら保存し直す。
/// 通知の許可は聞かない（オンボーディングとホームで聞く）。許可がなくてもトークンは取れるので、
/// あとから端末の設定で通知をオンにすれば、保存したトークンにそのまま届く。
/// サインアウトしたらトークンも無効にして、前のアカウントの通知が届かないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

abstract class _$PushTokenNotifier extends $AsyncNotifier<void> {
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
