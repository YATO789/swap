import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/profile_response.freezed.dart';
part '_generated/profile_response.g.dart';

/// profiles の1行。
@freezed
abstract class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    required String id,
    required String displayName,
    int? avatarColor,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}
