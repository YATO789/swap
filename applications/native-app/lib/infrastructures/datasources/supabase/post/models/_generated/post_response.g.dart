// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostResponse _$PostResponseFromJson(Map<String, dynamic> json) =>
    _PostResponse(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      message: json['message'] as String,
      postedAt: const LocalDateTimeConverter().fromJson(
        json['posted_at'] as String,
      ),
    );

Map<String, dynamic> _$PostResponseToJson(_PostResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'message': instance.message,
      'posted_at': const LocalDateTimeConverter().toJson(instance.postedAt),
    };
