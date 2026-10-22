import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book_member.freezed.dart';
part '_generated/diary_book_member.g.dart';

/// 日記帳に参加している人。
@freezed
abstract class DiaryBookMember with _$DiaryBookMember {
  const factory DiaryBookMember({
    required String userId,
    required String displayName,

    /// アイコンの色（0xAARRGGBB）。null なら決まった色。
    int? avatarColor,
  }) = _DiaryBookMember;

  factory DiaryBookMember.fromJson(Map<String, dynamic> json) =>
      _$DiaryBookMemberFromJson(json);
}
