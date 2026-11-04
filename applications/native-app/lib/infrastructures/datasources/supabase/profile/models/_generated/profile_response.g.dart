// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    _ProfileResponse(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      avatarPath: json['avatar_path'] as String?,
    );

Map<String, dynamic> _$ProfileResponseToJson(_ProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'avatar_path': instance.avatarPath,
    };
