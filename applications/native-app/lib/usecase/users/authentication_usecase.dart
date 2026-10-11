import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';

part '_generated/authentication_usecase.g.dart';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。
@Riverpod(keepAlive: true)
class AuthenticationUsecase extends _$AuthenticationUsecase {
  AuthenticationRepository get _repository =>
      ref.read(authenticationRepositoryProvider);

  @override
  Authentication build() => _repository.current;

  /// 匿名ユーザーとしてサインインする。
  Future<void> signInAnonymously() async {
    state = await _repository.signInAnonymously();
  }

  Future<void> signOut() async {
    state = await _repository.signOut();
  }
}
