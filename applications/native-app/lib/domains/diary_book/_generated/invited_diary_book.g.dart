// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../invited_diary_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvitedDiaryBook _$InvitedDiaryBookFromJson(Map<String, dynamic> json) =>
    _InvitedDiaryBook(
      id: json['id'] as String,
      name: json['name'] as String,
      memberNames: (json['member_names'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      memberAvatarColors:
          (json['member_avatar_colors'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toInt())
              .toList() ??
          const [],
      alreadyJoined: json['already_joined'] as bool,
      memberLimit:
          (json['member_limit'] as num?)?.toInt() ?? maxDiaryBookMembers,
      coverColor: (json['cover_color'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InvitedDiaryBookToJson(_InvitedDiaryBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'member_names': instance.memberNames,
      'member_avatar_colors': instance.memberAvatarColors,
      'already_joined': instance.alreadyJoined,
      'member_limit': instance.memberLimit,
      'cover_color': instance.coverColor,
    };
