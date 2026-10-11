import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part '_generated/shared_preferences_store.g.dart';

/// 端末に保存する値の読み書きに使う SharedPreferences。
/// 読み込みを待ってから使いたいので、main で作ったものに差し替える。
@Riverpod(keepAlive: true)
SharedPreferencesWithCache sharedPreferences(Ref ref) {
  throw UnimplementedError('main で sharedPreferencesProvider を差し替えてください');
}
