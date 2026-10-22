// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    _ProfileResponse(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      avatarColor: (json['avatar_color'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileResponseToJson(_ProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'avatar_color': instance.avatarColor,
    };
