import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/platform/track_preview_datasource.dart';

part '_generated/track_preview_repository.g.dart';

@Riverpod(keepAlive: true)
TrackPreviewRepository trackPreviewRepository(Ref ref) {
  return TrackPreviewRepository(ref.watch(trackPreviewDatasourceProvider));
}

/// 記録に添えた曲の試聴を流す。同時に流すのは1曲だけ。
class TrackPreviewRepository {
  const TrackPreviewRepository(this._datasource);

  final TrackPreviewDatasource _datasource;

  /// [url] の試聴を最初から流す。ほかの試聴を流していたら切り替える。
  Future<void> play(Uri url) {
    return _datasource.play(url);
  }

  /// 流している試聴を止める。
  Future<void> stop() {
    return _datasource.stop();
  }

  /// 試聴を最後まで流したときに流れる。
  Stream<void> get onCompleted {
    return _datasource.onCompleted;
  }
}
