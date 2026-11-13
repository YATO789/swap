import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/track_response.freezed.dart';
part '_generated/track_response.g.dart';

/// 記録に添えた曲。posts.track の中身。
@freezed
abstract class TrackResponse with _$TrackResponse {
  const factory TrackResponse({
    required String id,
    required String title,
    required String artist,
    required String album,
    required int durationMs,
    required String storeUrl,
    String? artworkUrl,
    String? previewUrl,
  }) = _TrackResponse;

  factory TrackResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackResponseFromJson(json);
}
