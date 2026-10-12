import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/stores/diary_book_grid_store.dart';

part '_generated/diary_book_grid_repository.g.dart';

/// ホームの日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
/// 設定画面で切り替える。
@Riverpod(keepAlive: true)
class DiaryBookGridRepository extends _$DiaryBookGridRepository {
  DiaryBookGridStore get _store => ref.read(diaryBookGridStoreProvider);

  @override
  bool build() => _store.read();

  /// グリッドで出すかを [grid] にして保存する。
  Future<void> save(bool grid) async {
    state = grid;
    await _store.save(grid);
  }
}
