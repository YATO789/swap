import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/push_token_repository.dart';

part '_generated/sign_out_usecase.g.dart';

@riverpod
SignOutUseCase signOutUseCase(Ref ref) => SignOutUseCase(ref);

/// この端末をプッシュ通知の送り先から外してから、サインアウトする。
class SignOutUseCase {
  const SignOutUseCase(this._ref);

  final Ref _ref;

  Future<void> call() async {
    // await のあいだにこの provider が破棄されると ref を使えないので、先に取り出しておく。
    final pushTokenRepository = _ref.read(pushTokenRepositoryProvider.notifier);
    final authenticationRepository = _ref.read(
      authenticationRepositoryProvider.notifier,
    );

    // 送り先から外すにはサインインしている必要があるので、サインアウトより先にやる。
    // 外せなくてもサインアウトは止めない。サインアウト後にトークンは無効になり、
    // 残った行は通知を送ったときに Edge Function が消す。
    try {
      await pushTokenRepository.unregister();
    } on Object catch (e, stackTrace) {
      debugPrint('プッシュ通知の送り先を外せませんでした: $e\n$stackTrace');
    }
    await authenticationRepository.signOut();
  }
}
