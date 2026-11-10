// freezed では factory に付けた @JsonSerializable が生成コードに渡るが、analyzer はそれを知らずに警告する。
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/itunes_track_response.freezed.dart';
part '_generated/itunes_track_response.g.dart';

/// iTunes Search API の検索結果の1曲のうち、使うぶんだけ。
/// iTunes のキーは camelCase なので、build.yaml の snake_case への読み替えを外す。
@freezed
abstract class ItunesTrackResponse with _$ItunesTrackResponse {
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory ItunesTrackResponse({
    required int trackId,
    required String trackName,
    required String artistName,
    required String collectionName,
    required String trackViewUrl,
    int? trackTimeMillis,
    String? artworkUrl100,
    String? previewUrl,
  }) = _ItunesTrackResponse;

  factory ItunesTrackResponse.fromJson(Map<String, dynamic> json) =>
      _$ItunesTrackResponseFromJson(json);
}
