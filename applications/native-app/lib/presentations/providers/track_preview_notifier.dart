import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/post/track.dart';
import '../../infrastructures/repositories/track_preview_repository.dart';

part '_generated/track_preview_notifier.g.dart';

/// いま試聴を流している曲の id を持つ。流していなければ null。
/// どの画面の再生ボタンからでも同じ曲を止められるよう、アプリで1つにする。
@Riverpod(name: 'trackPreviewProvider', keepAlive: true)
class TrackPreviewNotifier extends _$TrackPreviewNotifier {
  TrackPreviewRepository get _repository {
    return ref.read(trackPreviewRepositoryProvider);
  }

  @override
  String? build() {
    final subscription = _repository.onCompleted.listen((_) {
      state = null;
    });
    ref.onDispose(subscription.cancel);
    return null;
  }

  /// [track] の試聴を流す。もう流していれば止める。
  /// 読み込めなかったら false を返す。
  Future<bool> toggle(Track track) async {
    final url = track.previewUrl;
    if (url == null) return false;
    if (state == track.id) {
      await stop();
      return true;
    }
    state = track.id;
    try {
      await _repository.play(url);
      return true;
    } on Exception catch (error, stackTrace) {
      debugPrint('試聴を流せませんでした: $error\n$stackTrace');
      // 読み込んでいるあいだにほかの曲に切り替えていたら、そちらはそのままにする。
      if (state == track.id) state = null;
      return false;
    }
  }

  /// 流している試聴を止める。流していなければ何もしない。
  Future<void> stop() async {
    // 画面を閉じた後から呼ばれることがあるので、アプリごと片付けた後なら何もしない。
    if (!ref.mounted || state == null) return;
    state = null;
    await _repository.stop();
  }
}
