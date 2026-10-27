import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/infrastructures/datasources/supabase/authentication/authentication_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/avatar/avatar_datasource.dart';

part '_generated/authentication_repository.g.dart';

@riverpod
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepository(
    ref.watch(authenticationDatasourceProvider),
    ref.watch(avatarDatasourceProvider),
  );
}

/// サインイン状態を読み、サインイン・サインアウトする。
class AuthenticationRepository {
  const AuthenticationRepository(this._datasource, this._avatarDatasource);

  final AuthenticationDatasource _datasource;
  final AvatarDatasource _avatarDatasource;

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
  ///
  /// アイコンの画像は DB の関数からは消せないので、先にここで消す。
  /// 消せなくても、アカウントの削除は続ける。
  Future<void> deleteAccount() async {
    try {
      await _avatarDatasource.removeMine();
    } on Object catch (e, stackTrace) {
      debugPrint('アイコンの画像を消せませんでした: $e\n$stackTrace');
    }
    await _datasource.deleteAccount();
  }
}
