import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/track_preview_datasource.g.dart';

/// 同時に鳴らすのは1曲だけにしたいので、プレイヤーは1つにして破棄しない。
@Riverpod(keepAlive: true)
TrackPreviewDatasource trackPreviewDatasource(Ref ref) {
  final datasource = TrackPreviewDatasource(AudioPlayer());
  ref.onDispose(datasource.dispose);
  return datasource;
}

/// 曲の試聴（30秒ほどの音源）を流す。
class TrackPreviewDatasource {
  TrackPreviewDatasource(this._player);

  final AudioPlayer _player;

  /// [url] の音源を最初から流す。ほかの音源を流していたら止めて切り替える。
  /// 読み込めなかったら例外を投げる。
  Future<void> play(Uri url) async {
    await _player.setUrl(url.toString());
    // play は流し終わるまで返らないので待たない。終わったことは [onCompleted] で知らせる。
    _player.play();
  }

  /// 流している音源を止める。
  Future<void> stop() {
    return _player.stop();
  }

  /// 音源を最後まで流したときに流れる。
  Stream<void> get onCompleted {
    return _player.processingStateStream
        .where((state) => state == ProcessingState.completed)
        .map((_) {});
  }

  void dispose() {
    _player.dispose();
  }
}
