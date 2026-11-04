// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryResponse _$DiaryResponseFromJson(Map<String, dynamic> json) =>
    _DiaryResponse(
      id: json['id'] as String,
      diaryBookId: json['diary_book_id'] as String,
      authorId: json['author_id'] as String,
      date: DateTime.parse(json['date'] as String),
      writtenAt: const LocalDateTimeConverter().fromJson(
        json['written_at'] as String,
      ),
      title: json['title'] as String,
      content: json['diary_contents'] == null
          ? null
          : DiaryContentResponse.fromJson(
              json['diary_contents'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DiaryResponseToJson(_DiaryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'diary_book_id': instance.diaryBookId,
      'author_id': instance.authorId,
      'date': instance.date.toIso8601String(),
      'written_at': const LocalDateTimeConverter().toJson(instance.writtenAt),
      'title': instance.title,
      'diary_contents': instance.content,
    };

_DiaryContentResponse _$DiaryContentResponseFromJson(
  Map<String, dynamic> json,
) => _DiaryContentResponse(body: json['body'] as String);

Map<String, dynamic> _$DiaryContentResponseToJson(
  _DiaryContentResponse instance,
) => <String, dynamic>{'body': instance.body};
