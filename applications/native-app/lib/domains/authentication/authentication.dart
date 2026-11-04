import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/authentication.freezed.dart';

/// サインイン状態。
@freezed
abstract class Authentication with _$Authentication {
  const factory Authentication({
    /// Supabase にサインインしているか。
    @Default(false) bool isSignedIn,
  }) = _Authentication;
}
