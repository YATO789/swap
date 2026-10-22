import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/timeline_post.freezed.dart';

/// 日記帳のタイムラインに並ぶ、誰かが書いた記録（「今なにしてる？」）。
@freezed
abstract class TimelinePost with _$TimelinePost {
  const factory TimelinePost({
    required String id,
    required String authorId,
    required String message,
    required DateTime postedAt,
  }) = _TimelinePost;
}
