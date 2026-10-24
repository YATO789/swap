import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/infrastructures/datasources/supabase/authentication/authentication_datasource.dart';

part '_generated/authentication_repository.g.dart';

@riverpod
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepository(ref.watch(authenticationDatasourceProvider));
}

/// サインイン状態を読み、サインイン・サインアウトする。
class AuthenticationRepository {
  const AuthenticationRepository(this._datasource);

  final AuthenticationDatasource _datasource;

  /// 今のサインイン状態。
  Authentication get current {
    return Authentication(isSignedIn: _datasource.isSignedIn);
  }

  /// Apple アカウントでサインインする。利用者がやめたら false を返す。
  Future<bool> signInWithApple() {
    return _datasource.signInWithApple();
  }

  /// 匿名ユーザーとしてサインインする。開発中の確認用。
  Future<void> signInAnonymously() {
    return _datasource.signInAnonymously();
  }

  Future<void> signOut() {
    return _datasource.signOut();
  }

  /// アカウントとそのデータを消し、サインアウトする。
  Future<void> deleteAccount() {
    return _datasource.deleteAccount();
  }
}
