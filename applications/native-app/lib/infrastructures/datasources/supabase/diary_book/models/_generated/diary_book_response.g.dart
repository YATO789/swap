// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_book_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryBookResponse _$DiaryBookResponseFromJson(Map<String, dynamic> json) =>
    _DiaryBookResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      inviteCode: json['invite_code'] as String,
      memberLimit: (json['member_limit'] as num).toInt(),
      createdBy: json['created_by'] as String?,
      coverColor: (json['cover_color'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DiaryBookResponseToJson(_DiaryBookResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'invite_code': instance.inviteCode,
      'member_limit': instance.memberLimit,
      'created_by': instance.createdBy,
      'cover_color': instance.coverColor,
    };
