import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructures/datasources/stores/preferences_store.dart';

part '_generated/post_hint_notifier.g.dart';

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
@Riverpod(name: 'postHintProvider')
class PostHintNotifier extends _$PostHintNotifier {
  PreferencesStore get _store {
    return ref.read(preferencesStoreProvider);
  }

  @override
  bool build() {
    return _store.readPostHintVisible();
  }

  /// 説明を出すかを [visible] にして保存する。
  Future<void> save(bool visible) async {
    state = visible;
    await _store.savePostHintVisible(visible);
  }
}
