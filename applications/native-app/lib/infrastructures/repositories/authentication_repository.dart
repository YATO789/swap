import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/infrastructures/datasources/authentication_datasource.dart';

part '_generated/authentication_repository.g.dart';

@riverpod
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepository(ref.watch(authenticationDatasourceProvider));
}

/// サインイン状態の取得とサインイン・サインアウトをまとめる。
class AuthenticationRepository {
  const AuthenticationRepository(this._datasource);

  final AuthenticationDatasource _datasource;

  /// 今のサインイン状態。
  Authentication get current => _datasource.current;

  /// 匿名ユーザーとしてサインインし、サインイン後の状態を返す。
  Future<Authentication> signInAnonymously() async {
    await _datasource.signInAnonymously();
    return _datasource.current;
  }

  /// サインアウトし、サインアウト後の状態を返す。
  Future<Authentication> signOut() async {
    await _datasource.signOut();
    return _datasource.current;
  }
}
