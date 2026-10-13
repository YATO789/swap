import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/infrastructures/datasources/supabase/authentication_datasource.dart';

part '_generated/authentication_repository.g.dart';

/// 今のサインイン状態を持ち、サインイン・サインアウトで更新する。
///
/// サインイン状態はアプリ全体で使うので、誰も見ていなくても破棄しない。
@Riverpod(keepAlive: true)
class AuthenticationRepository extends _$AuthenticationRepository {
  AuthenticationDatasource get _datasource =>
      ref.read(authenticationDatasourceProvider);

  @override
  Authentication build() => _datasource.current;

  /// Apple アカウントでサインインする。利用者がやめたら false を返す。
  Future<bool> signInWithApple() async {
    final signedIn = await _datasource.signInWithApple();
    state = _datasource.current;
    return signedIn;
  }

  /// 匿名ユーザーとしてサインインする。開発中の確認用。
  Future<void> signInAnonymously() async {
    await _datasource.signInAnonymously();
    state = _datasource.current;
  }

  Future<void> signOut() async {
    await _datasource.signOut();
    state = _datasource.current;
  }

  /// アカウントとそのデータを消し、サインアウトした状態にする。
  Future<void> deleteAccount() async {
    await _datasource.deleteAccount();
    state = _datasource.current;
  }
}
