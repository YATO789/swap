import 'package:freezed_annotation/freezed_annotation.dart';

import 'diary_book_response.dart';

part '_generated/joined_diary_book_response.freezed.dart';

/// 参加している日記帳の一覧の1行。diary_books の列に `diary_book_members(count)` が付いている。
@freezed
abstract class JoinedDiaryBookResponse with _$JoinedDiaryBookResponse {
  const factory JoinedDiaryBookResponse({
    required DiaryBookResponse diaryBook,
    required int memberCount,
  }) = _JoinedDiaryBookResponse;

  /// 人数は `{"diary_book_members": [{"count": 3}]}` の形で返ってくる。
  factory JoinedDiaryBookResponse.fromJson(Map<String, dynamic> json) {
    final members = json['diary_book_members'] as List<dynamic>;
    return JoinedDiaryBookResponse(
      diaryBook: DiaryBookResponse.fromJson(json),
      memberCount: (members.first as Map<String, dynamic>)['count'] as int,
    );
  }
}
