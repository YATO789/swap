import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructures/datasources/stores/preferences_store.dart';

part '_generated/diary_book_grid_helper.g.dart';

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。
@Riverpod(name: 'diaryBookGridProvider')
class DiaryBookGridHelper extends _$DiaryBookGridHelper {
  PreferencesStore get _store {
    return ref.read(preferencesStoreProvider);
  }

  @override
  bool build() {
    return _store.readDiaryBookGrid();
  }

  /// グリッドで出すかを [grid] にして保存する。
  Future<void> save(bool grid) async {
    state = grid;
    await _store.saveDiaryBookGrid(grid);
  }
}
