// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryBook _$DiaryBookFromJson(Map<String, dynamic> json) => _DiaryBook(
  id: json['id'] as String,
  name: json['name'] as String,
  inviteCode: json['invite_code'] as String,
  memberCount: (json['member_count'] as num).toInt(),
  memberLimit: (json['member_limit'] as num?)?.toInt() ?? maxDiaryBookMembers,
  createdBy: json['created_by'] as String?,
  coverColor: (json['cover_color'] as num?)?.toInt(),
);

Map<String, dynamic> _$DiaryBookToJson(_DiaryBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'invite_code': instance.inviteCode,
      'member_count': instance.memberCount,
      'member_limit': instance.memberLimit,
      'created_by': instance.createdBy,
      'cover_color': instance.coverColor,
    };
