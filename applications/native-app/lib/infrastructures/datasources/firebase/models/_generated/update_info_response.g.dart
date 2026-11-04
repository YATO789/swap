// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../update_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateInfoResponse _$UpdateInfoResponseFromJson(Map<String, dynamic> json) =>
    _UpdateInfoResponse(
      latestVersion: json['latestVersion'] as String,
      requiredVersion: json['requiredVersion'] as String,
      enabledAt: DateTime.parse(json['enabledAt'] as String),
    );

Map<String, dynamic> _$UpdateInfoResponseToJson(_UpdateInfoResponse instance) =>
    <String, dynamic>{
      'latestVersion': instance.latestVersion,
      'requiredVersion': instance.requiredVersion,
      'enabledAt': instance.enabledAt.toIso8601String(),
    };
