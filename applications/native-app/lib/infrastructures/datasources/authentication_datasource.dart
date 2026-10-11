import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/authentication/authentication.dart';

part '_generated/authentication_datasource.g.dart';

@riverpod
AuthenticationDatasource authenticationDatasource(Ref ref) {
  return AuthenticationDatasource(Supabase.instance.client);
}

/// Supabase Auth を使ってサインイン状態を読み書きする。
class AuthenticationDatasource {
  const AuthenticationDatasource(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  /// 今のサインイン状態。
  Authentication get current => _toAuthentication(_auth.currentSession);

  /// iOS の Apple サインイン画面を出し、その結果で Supabase にサインインする。
  ///
  /// サインインできたら true、利用者が画面を閉じてやめたら false を返す。
  Future<bool> signInWithApple() async {
    // Apple には SHA-256 したものを渡し、Supabase には元の値を渡して照合させる。
    final rawNonce = _auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
        nonce: hashedNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return false;
      rethrow;
    }

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Apple から ID トークンを受け取れませんでした');
    }
    await _auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    return true;
  }

  /// アカウントを作らずに匿名ユーザーとしてサインインする。開発中の確認用。
  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// アカウントとそのデータをサーバーから消し、端末のセッションも捨てる。
  Future<void> deleteAccount() async {
    await _client.rpc<void>('delete_account');
    // サーバーのセッションはユーザーと一緒に消えているので、端末の分だけ捨てる。
    await _auth.signOut(scope: SignOutScope.local);
  }

  Authentication _toAuthentication(Session? session) {
    return Authentication(isLoginApp: session != null);
  }
}
