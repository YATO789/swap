import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/post_comment.freezed.dart';

/// 記録に付いたコメント。記録を出した日記帳ごとに分かれ、その日記帳の人にだけ見える。
@freezed
abstract class PostComment with _$PostComment {
  const factory PostComment({
    required String id,
    required String userId,
    required String message,
    required DateTime createdAt,
  }) = _PostComment;
}

/// コメントの最大文字数。DB の post_comments.message の制約と合わせる。
const maxCommentMessageLength = 100;
