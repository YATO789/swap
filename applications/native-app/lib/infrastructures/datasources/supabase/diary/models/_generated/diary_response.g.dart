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
      photoPath: json['photo_path'] as String?,
      content: json['diary_contents'] == null
          ? null
          : DiaryContentResponse.fromJson(
              json['diary_contents'] as Map<String, dynamic>,
            ),
      diaryReactions:
          (json['diary_reactions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    DiaryReactionResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DiaryResponseToJson(_DiaryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'diary_book_id': instance.diaryBookId,
      'author_id': instance.authorId,
      'date': instance.date.toIso8601String(),
      'written_at': const LocalDateTimeConverter().toJson(instance.writtenAt),
      'title': instance.title,
      'photo_path': instance.photoPath,
      'diary_contents': instance.content,
      'diary_reactions': instance.diaryReactions,
    };

_DiaryContentResponse _$DiaryContentResponseFromJson(
  Map<String, dynamic> json,
) => _DiaryContentResponse(body: json['body'] as String);

Map<String, dynamic> _$DiaryContentResponseToJson(
  _DiaryContentResponse instance,
) => <String, dynamic>{'body': instance.body};

_DiaryReactionResponse _$DiaryReactionResponseFromJson(
  Map<String, dynamic> json,
) => _DiaryReactionResponse(
  userId: json['user_id'] as String,
  emoji: json['emoji'] as String,
  createdAt: const LocalDateTimeConverter().fromJson(
    json['created_at'] as String,
  ),
);

Map<String, dynamic> _$DiaryReactionResponseToJson(
  _DiaryReactionResponse instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'emoji': instance.emoji,
  'created_at': const LocalDateTimeConverter().toJson(instance.createdAt),
};
