import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

part '_generated/post_hint_repository.g.dart';

/// ホームの書き込みバーに手書きの説明を出すか。設定画面で切り替える。
@Riverpod(keepAlive: true)
class PostHintRepository extends _$PostHintRepository {
  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  @override
  bool build() => _store.readPostHintVisible();

  /// 説明を出すかを [visible] にして保存する。
  Future<void> save(bool visible) async {
    state = visible;
    await _store.savePostHintVisible(visible);
  }
}
