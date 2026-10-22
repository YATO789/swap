// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryBookMemberResponse _$DiaryBookMemberResponseFromJson(
  Map<String, dynamic> json,
) => _DiaryBookMemberResponse(
  userId: json['user_id'] as String,
  profile: DiaryBookMemberProfileResponse.fromJson(
    json['profiles'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DiaryBookMemberResponseToJson(
  _DiaryBookMemberResponse instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'profiles': instance.profile,
};

_DiaryBookMemberProfileResponse _$DiaryBookMemberProfileResponseFromJson(
  Map<String, dynamic> json,
) => _DiaryBookMemberProfileResponse(
  displayName: json['display_name'] as String,
  avatarColor: (json['avatar_color'] as num?)?.toInt(),
);

Map<String, dynamic> _$DiaryBookMemberProfileResponseToJson(
  _DiaryBookMemberProfileResponse instance,
) => <String, dynamic>{
  'display_name': instance.displayName,
  'avatar_color': instance.avatarColor,
};
