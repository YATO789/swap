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
      postDiaryBooks:
          (json['post_diary_books'] as List<dynamic>?)
              ?.map(
                (e) =>
                    PostDiaryBookResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PostResponseToJson(_PostResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'message': instance.message,
      'posted_at': const LocalDateTimeConverter().toJson(instance.postedAt),
      'post_diary_books': instance.postDiaryBooks,
    };

_PostDiaryBookResponse _$PostDiaryBookResponseFromJson(
  Map<String, dynamic> json,
) => _PostDiaryBookResponse(
  postReactions:
      (json['post_reactions'] as List<dynamic>?)
          ?.map((e) => PostReactionResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PostDiaryBookResponseToJson(
  _PostDiaryBookResponse instance,
) => <String, dynamic>{'post_reactions': instance.postReactions};

_PostReactionResponse _$PostReactionResponseFromJson(
  Map<String, dynamic> json,
) => _PostReactionResponse(
  userId: json['user_id'] as String,
  emoji: json['emoji'] as String,
  createdAt: const LocalDateTimeConverter().fromJson(
    json['created_at'] as String,
  ),
);

Map<String, dynamic> _$PostReactionResponseToJson(
  _PostReactionResponse instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'emoji': instance.emoji,
  'created_at': const LocalDateTimeConverter().toJson(instance.createdAt),
};
