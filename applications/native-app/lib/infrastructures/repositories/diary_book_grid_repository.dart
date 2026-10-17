import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';

part '_generated/diary_book_grid_repository.g.dart';

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。
@Riverpod(keepAlive: true)
class DiaryBookGridRepository extends _$DiaryBookGridRepository {
  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  @override
  bool build() => _store.readDiaryBookGrid();

  /// グリッドで出すかを [grid] にして保存する。
  Future<void> save(bool grid) async {
    state = grid;
    await _store.saveDiaryBookGrid(grid);
  }
}
