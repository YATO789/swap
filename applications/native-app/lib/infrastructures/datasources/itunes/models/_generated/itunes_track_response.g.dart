// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../itunes_track_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItunesTrackResponse _$ItunesTrackResponseFromJson(Map<String, dynamic> json) =>
    _ItunesTrackResponse(
      trackId: (json['trackId'] as num).toInt(),
      trackName: json['trackName'] as String,
      artistName: json['artistName'] as String,
      collectionName: json['collectionName'] as String,
      trackViewUrl: json['trackViewUrl'] as String,
      trackTimeMillis: (json['trackTimeMillis'] as num?)?.toInt(),
      artworkUrl100: json['artworkUrl100'] as String?,
      previewUrl: json['previewUrl'] as String?,
    );

Map<String, dynamic> _$ItunesTrackResponseToJson(
  _ItunesTrackResponse instance,
) => <String, dynamic>{
  'trackId': instance.trackId,
  'trackName': instance.trackName,
  'artistName': instance.artistName,
  'collectionName': instance.collectionName,
  'trackViewUrl': instance.trackViewUrl,
  'trackTimeMillis': instance.trackTimeMillis,
  'artworkUrl100': instance.artworkUrl100,
  'previewUrl': instance.previewUrl,
};
