import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap/utils/local_date_time_converter.dart';

part '_generated/post_response.freezed.dart';
part '_generated/post_response.g.dart';

/// posts の1行。
@freezed
abstract class PostResponse with _$PostResponse {
  const factory PostResponse({
    required String id,
    required String authorId,
    required String message,
    @LocalDateTimeConverter() required DateTime postedAt,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}
