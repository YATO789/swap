import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/update_info_response.freezed.dart';
part '_generated/update_info_response.g.dart';

/// Remote Config の `update_info`。
@freezed
abstract class UpdateInfoResponse with _$UpdateInfoResponse {
  // Remote Config のキーは camelCase なので、snake_case に読み替えない。
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory UpdateInfoResponse({
    required String latestVersion,
    required String requiredVersion,
    required DateTime enabledAt,
  }) = _UpdateInfoResponse;

  factory UpdateInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateInfoResponseFromJson(json);
}
