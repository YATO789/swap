import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/infrastructures/datasources/diary_datasource.dart';

part '_generated/diary_repository.g.dart';

@Riverpod(keepAlive: true)
DiaryRepository diaryRepository(Ref ref) {
  return DiaryRepository(ref.read(diaryDatasourceProvider));
}

/// 日記を読む。
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
}
