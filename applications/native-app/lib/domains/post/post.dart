import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/post.freezed.dart';

/// 記録（「今なにしてる？」）。書いた内容と、それを出す日記帳。
@freezed
abstract class Post with _$Post {
  const factory Post({
    required String message,

    /// 記録を出す日記帳の id。1冊以上。
    required List<String> diaryBookIds,
  }) = _Post;
}

/// 記録の最大文字数。DB の posts.message の制約と合わせる。
const maxPostMessageLength = 100;
