import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap/utils/local_date_time_converter.dart';

import 'track_response.dart';

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
    TrackResponse? track,

    /// 日記帳を絞って読んだときの出し先。その日記帳の1つだけが入る。
    @Default([]) List<PostDiaryBookResponse> postDiaryBooks,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}

/// post_diary_books の1行と、その出し先に付いたリアクションとコメント。
@freezed
abstract class PostDiaryBookResponse with _$PostDiaryBookResponse {
  const factory PostDiaryBookResponse({
    @Default([]) List<PostReactionResponse> postReactions,
    @Default([]) List<PostCommentResponse> postComments,
  }) = _PostDiaryBookResponse;

  factory PostDiaryBookResponse.fromJson(Map<String, dynamic> json) =>
      _$PostDiaryBookResponseFromJson(json);
}

/// post_reactions の1行。
@freezed
abstract class PostReactionResponse with _$PostReactionResponse {
  const factory PostReactionResponse({
    required String userId,
    required String emoji,
    @LocalDateTimeConverter() required DateTime createdAt,
  }) = _PostReactionResponse;

  factory PostReactionResponse.fromJson(Map<String, dynamic> json) =>
      _$PostReactionResponseFromJson(json);
}

/// post_comments の1行。
@freezed
abstract class PostCommentResponse with _$PostCommentResponse {
  const factory PostCommentResponse({
    required String id,
    required String userId,
    required String message,
    @LocalDateTimeConverter() required DateTime createdAt,
  }) = _PostCommentResponse;

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$PostCommentResponseFromJson(json);
}
