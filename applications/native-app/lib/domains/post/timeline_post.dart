import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/timeline_post.freezed.dart';

/// 日記帳のタイムラインに並ぶ、誰かが書いた記録（「今なにしてる？」）。
@freezed
abstract class TimelinePost with _$TimelinePost {
  const TimelinePost._();

  const factory TimelinePost({
    required String id,
    required String authorId,
    required String message,
    required DateTime postedAt,

    /// この日記帳で付いたリアクション。付けた順。1人1つ。
    @Default([]) List<PostReaction> reactions,
  }) = _TimelinePost;

  /// [userId] の人が付けた絵文字。付けていなければ null。
  String? reactionOf(String? userId) {
    for (final reaction in reactions) {
      if (reaction.userId == userId) return reaction.emoji;
    }
    return null;
  }

  /// [userId] の人のリアクションを [emoji] にした記録。同じ絵文字なら取り消す。
  /// 付け替えたときは並びの最後に回す。
  TimelinePost reactedBy(String userId, String emoji) {
    final previous = reactionOf(userId);
    return copyWith(
      reactions: [
        for (final reaction in reactions)
          if (reaction.userId != userId) reaction,
        if (previous != emoji) PostReaction(userId: userId, emoji: emoji),
      ],
    );
  }
}

/// 記録に付いた絵文字のリアクション。
@freezed
abstract class PostReaction with _$PostReaction {
  const factory PostReaction({required String userId, required String emoji}) =
      _PostReaction;
}
