// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../timeline_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelinePost _$TimelinePostFromJson(Map<String, dynamic> json) =>
    _TimelinePost(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      message: json['message'] as String,
      postedAt: const LocalDateTimeConverter().fromJson(
        json['posted_at'] as String,
      ),
    );

Map<String, dynamic> _$TimelinePostToJson(_TimelinePost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'message': instance.message,
      'posted_at': const LocalDateTimeConverter().toJson(instance.postedAt),
    };
