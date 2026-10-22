import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/diary_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/models/diary_response.dart';

part '_generated/diary_repository.g.dart';

@riverpod
DiaryRepository diaryRepository(Ref ref) {
  return DiaryRepository(ref.watch(diaryDatasourceProvider));
}

/// 日記を読み書きする。
class DiaryRepository {
  const DiaryRepository(this._datasource);

  final DiaryDatasource _datasource;

  /// [diaryBookId] の日記帳に書かれた [date] の日記を、書いた時刻の新しい順に返す。
  Future<List<Diary>> fetchOn(String diaryBookId, DateTime date) async {
    final responses = await _datasource.fetchOn(diaryBookId, date);
    return responses.map(_toDiary).toList();
  }

  /// [diaryBookId] の日記帳に、[month] の月の間で誰かが日記を書いた日。
  Future<Set<DateTime>> fetchDatesIn(String diaryBookId, DateTime month) {
    return _datasource.fetchDatesIn(
      diaryBookId,
      from: DateTime(month.year, month.month),
      to: DateTime(month.year, month.month + 1, 0),
    );
  }

  /// 自分が [date] に書いた日記を、日記帳の id ごとに返す。
  Future<Map<String, Diary>> fetchMineOn(DateTime date) async {
    final responses = await _datasource.fetchMineOn(date);
    return {
      for (final response in responses)
        response.diaryBookId: _toDiary(response),
    };
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

  Diary _toDiary(DiaryResponse response) {
    return Diary(
      id: response.id,
      authorId: response.authorId,
      date: response.date,
      writtenAt: response.writtenAt,
      title: response.content?.title,
      body: response.content?.body,
    );
  }
}
