// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../invited_diary_book_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvitedDiaryBookResponse _$InvitedDiaryBookResponseFromJson(
  Map<String, dynamic> json,
) => _InvitedDiaryBookResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  memberLimit: (json['member_limit'] as num).toInt(),
  memberNames: (json['member_names'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  memberAvatarPaths:
      (json['member_avatar_paths'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList() ??
      const [],
  alreadyJoined: json['already_joined'] as bool,
  coverColor: (json['cover_color'] as num?)?.toInt(),
);

Map<String, dynamic> _$InvitedDiaryBookResponseToJson(
  _InvitedDiaryBookResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'member_limit': instance.memberLimit,
  'member_names': instance.memberNames,
  'member_avatar_paths': instance.memberAvatarPaths,
  'already_joined': instance.alreadyJoined,
  'cover_color': instance.coverColor,
};
