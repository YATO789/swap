// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Diary _$DiaryFromJson(Map<String, dynamic> json) => _Diary(
  id: json['id'] as String,
  authorId: json['author_id'] as String,
  date: DateTime.parse(json['date'] as String),
  writtenAt: const LocalDateTimeConverter().fromJson(
    json['written_at'] as String,
  ),
  title: json['title'] as String?,
  body: json['body'] as String?,
);

Map<String, dynamic> _$DiaryToJson(_Diary instance) => <String, dynamic>{
  'id': instance.id,
  'author_id': instance.authorId,
  'date': instance.date.toIso8601String(),
  'written_at': const LocalDateTimeConverter().toJson(instance.writtenAt),
  'title': instance.title,
  'body': instance.body,
};
