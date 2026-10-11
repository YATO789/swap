import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/authentication/authentication.dart';

part '_generated/authentication_datasource.g.dart';

@riverpod
AuthenticationDatasource authenticationDatasource(Ref ref) {
  return AuthenticationDatasource(Supabase.instance.client.auth);
}

/// Supabase Auth を使ってサインイン状態を読み書きする。
class AuthenticationDatasource {
  const AuthenticationDatasource(this._auth);

  final GoTrueClient _auth;

  /// 今のサインイン状態。
  Authentication get current => _toAuthentication(_auth.currentSession);

  /// アカウントを作らずに匿名ユーザーとしてサインインする。
  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Authentication _toAuthentication(Session? session) {
    return Authentication(isLoginApp: session != null);
  }
}
