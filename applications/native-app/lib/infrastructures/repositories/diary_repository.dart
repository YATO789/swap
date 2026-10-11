import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/infrastructures/datasources/diary_datasource.dart';

part '_generated/diary_repository.g.dart';

@Riverpod(keepAlive: true)
DiaryRepository diaryRepository(Ref ref) {
  return DiaryRepository(ref.read(diaryDatasourceProvider));
}

/// 日記を読み書きする。
class DiaryRepository {
  const DiaryRepository(this._datasource);

  final DiaryDatasource _datasource;

  /// [diaryBookId] の日記帳に書かれた [date] の日記を、書いた時刻の新しい順に返す。
  Future<List<Diary>> fetchOn(String diaryBookId, DateTime date) {
    return _datasource.fetchOn(diaryBookId, date);
  }

  /// [diaryBookId] の日記帳に、[month] の月の間で誰かが日記を書いた日。
  Future<Set<DateTime>> fetchDatesIn(String diaryBookId, DateTime month) {
    return _datasource.fetchDatesIn(
      diaryBookId,
      from: DateTime(month.year, month.month),
      to: DateTime(month.year, month.month + 1, 0),
    );
  }

  /// [diaryBookId] の日記帳に書かれた日記の数。
  Future<int> countIn(String diaryBookId) {
    return _datasource.countIn(diaryBookId);
  }

  /// 自分が [date] に書いた日記を、日記帳の id ごとに返す。
  Future<Map<String, Diary>> fetchMineOn(DateTime date) {
    return _datasource.fetchMineOn(date);
  }

  /// [diaryBookIds] の日記帳それぞれに、自分の [date] の日記として同じ内容を書く。
  /// もう書いている日記帳では、タイトルと本文を書き換える。
  Future<void> save({
    required List<String> diaryBookIds,
    required DateTime date,
    required String title,
    required String body,
  }) async {
    await Future.wait([
      for (final id in diaryBookIds)
        _datasource.save(diaryBookId: id, date: date, title: title, body: body),
    ]);
  }

  /// 自分の日記を消す。
  Future<void> delete(String diaryId) {
    return _datasource.delete(diaryId);
  }
}
