import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap/utils/local_date_time_converter.dart';

part '_generated/timeline_post.freezed.dart';
part '_generated/timeline_post.g.dart';

/// 日記帳のタイムラインに並ぶ、誰かが書いた記録（「今なにしてる？」）。
@freezed
abstract class TimelinePost with _$TimelinePost {
  const factory TimelinePost({
    required String id,
    required String authorId,
    required String message,
    @LocalDateTimeConverter() required DateTime postedAt,
  }) = _TimelinePost;

  factory TimelinePost.fromJson(Map<String, dynamic> json) =>
      _$TimelinePostFromJson(json);
}
