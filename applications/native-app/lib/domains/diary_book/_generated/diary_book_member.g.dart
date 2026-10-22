// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryBookMember _$DiaryBookMemberFromJson(Map<String, dynamic> json) =>
    _DiaryBookMember(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      avatarColor: (json['avatar_color'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DiaryBookMemberToJson(_DiaryBookMember instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'display_name': instance.displayName,
      'avatar_color': instance.avatarColor,
    };
