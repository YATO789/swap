import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/authentication.freezed.dart';

@freezed
abstract class Authentication with _$Authentication {
  const factory Authentication({
    @Default(false) bool isLoginApp,
  }) = _Authentication;
}
