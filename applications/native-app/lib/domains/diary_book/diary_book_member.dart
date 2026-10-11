import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book_member.freezed.dart';

/// 日記帳に参加している人。
@freezed
abstract class DiaryBookMember with _$DiaryBookMember {
  const factory DiaryBookMember({
    required String userId,
    required String displayName,
  }) = _DiaryBookMember;
}
