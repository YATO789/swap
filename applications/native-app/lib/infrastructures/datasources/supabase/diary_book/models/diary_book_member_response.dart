import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book_member_response.freezed.dart';
part '_generated/diary_book_member_response.g.dart';

/// diary_book_members の1行に、参加している人の profiles を付けたもの。
@freezed
abstract class DiaryBookMemberResponse with _$DiaryBookMemberResponse {
  const factory DiaryBookMemberResponse({
    required String userId,
    @JsonKey(name: 'profiles') required DiaryBookMemberProfileResponse profile,
  }) = _DiaryBookMemberResponse;

  factory DiaryBookMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryBookMemberResponseFromJson(json);
}

/// メンバーの profiles のうち、日記帳で見せる列。
@freezed
abstract class DiaryBookMemberProfileResponse
    with _$DiaryBookMemberProfileResponse {
  const factory DiaryBookMemberProfileResponse({
    required String displayName,
    int? avatarColor,
  }) = _DiaryBookMemberProfileResponse;

  factory DiaryBookMemberProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryBookMemberProfileResponseFromJson(json);
}
