import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/post/track.dart';
import '../../infrastructures/repositories/post_repository.dart';

part '_generated/popular_tracks_notifier.g.dart';

/// 曲を探すシートで、何も打つ前に並べる人気の曲を持つ。
///
/// 人気の曲のフィードはときどき返るのが遅いので、一度取れたらアプリを閉じるまで持ち続け、
/// シートを開くたびには取りに行かない。
@Riverpod(name: 'popularTracksProvider', keepAlive: true)
class PopularTracksNotifier extends _$PopularTracksNotifier {
  @override
  Future<List<Track>> build() async {
    try {
      return await ref.read(postRepositoryProvider).fetchPopularTracks();
    } catch (error, stackTrace) {
      debugPrint('人気の曲を取れませんでした: $error\n$stackTrace');
      rethrow;
    }
  }

  /// まだ取っていなければ取りに行く。前に取れなかったなら取り直す。
  /// 曲を探すシートを開く前に呼んでおくと、開いたときには並べられる。
  void prefetch() {
    if (state.hasError && !state.isLoading) ref.invalidateSelf();
  }
}
