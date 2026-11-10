import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/track.freezed.dart';

/// 記録に添える1曲。iTunes Search API で探した曲のうち、表示と試聴に使うぶんだけを写して持つ。
/// あとで配信が止まっても表示が崩れないよう、名前や画像の URL も記録に書いておく。
@freezed
abstract class Track with _$Track {
  const factory Track({
    /// iTunes の曲の ID。
    required String id,
    required String title,

    /// アーティスト名。
    required String artist,
    required String album,
    required Duration duration,

    /// Apple Music の曲のページ。
    required Uri storeUrl,

    /// アルバム画像の URL。なければ曲ごとの色で代わりの画像を出す。
    Uri? artworkUrl,

    /// 30秒ほどの試聴の音源。曲によってはない。
    Uri? previewUrl,
  }) = _Track;
}
