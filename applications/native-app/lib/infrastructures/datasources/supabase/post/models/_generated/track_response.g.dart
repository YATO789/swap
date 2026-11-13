// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../track_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackResponse _$TrackResponseFromJson(Map<String, dynamic> json) =>
    _TrackResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      durationMs: (json['duration_ms'] as num).toInt(),
      storeUrl: json['store_url'] as String,
      artworkUrl: json['artwork_url'] as String?,
      previewUrl: json['preview_url'] as String?,
    );

Map<String, dynamic> _$TrackResponseToJson(_TrackResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'album': instance.album,
      'duration_ms': instance.durationMs,
      'store_url': instance.storeUrl,
      'artwork_url': instance.artworkUrl,
      'preview_url': instance.previewUrl,
    };
