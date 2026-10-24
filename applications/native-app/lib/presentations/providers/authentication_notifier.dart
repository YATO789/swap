import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/authentication/authentication.dart';
import '../../infrastructures/repositories/authentication_repository.dart';
import '../../usecases/sign_out_usecase.dart';

part '_generated/authentication_notifier.g.dart';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
@Riverpod(name: 'authenticationProvider')
class AuthenticationNotifier extends _$AuthenticationNotifier {
  AuthenticationRepository get _repository {
    return ref.read(authenticationRepositoryProvider);
  }

  @override
  Authentication build() {
    return _repository.current;
  }

  /// Apple アカウントでサインインする。利用者がやめたら false を返す。
  Future<bool> signInWithApple() async {
    final repository = _repository;
    final signedIn = await repository.signInWithApple();
    state = repository.current;
    return signedIn;
  }

  /// 匿名ユーザーとしてサインインする。開発中の確認用。
  Future<void> signInAnonymously() async {
    final repository = _repository;
    await repository.signInAnonymously();
    state = repository.current;
  }

  /// この端末をプッシュ通知の送り先から外してから、サインアウトする。
  Future<void> signOut() async {
    final repository = _repository;
    await ref.read(signOutUseCaseProvider).call();
    state = repository.current;
  }

  /// アカウントとそのデータを消し、サインアウトした状態にする。
  Future<void> deleteAccount() async {
    final repository = _repository;
    await repository.deleteAccount();
    state = repository.current;
  }
}
