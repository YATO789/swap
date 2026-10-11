import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/domains/diary/diary.dart';

part '_generated/diary_datasource.g.dart';

@riverpod
DiaryDatasource diaryDatasource(Ref ref) {
  return DiaryDatasource(Supabase.instance.client);
}

/// Supabase の diaries テーブルから日記を読む。
class DiaryDatasource {
  const DiaryDatasource(this._client);

  final SupabaseClient _client;

  /// [diaryBookId] の日記帳に書かれた [date] の日記を、書いた時刻の新しい順に返す。
  /// 本文（diary_contents）は RLS で読めるものだけが返り、読めない日記は本文が null になる。
  Future<List<Diary>> fetchOn(String diaryBookId, DateTime date) async {
    final rows = await _client
        .from('diaries')
        .select('id, author_id, date, written_at, diary_contents(title, body)')
        .eq('diary_book_id', diaryBookId)
        .eq('date', _toDateString(date))
        .order('written_at', ascending: false);
    return rows.map(_toDiary).toList();
  }

  /// [diaryBookId] の日記帳に、[from] から [to] まで（両端を含む）の間で誰かが日記を書いた日。
  Future<Set<DateTime>> fetchDatesIn(
    String diaryBookId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('diaries')
        .select('date')
        .eq('diary_book_id', diaryBookId)
        .gte('date', _toDateString(from))
        .lte('date', _toDateString(to));
    return {for (final row in rows) DateTime.parse(row['date'] as String)};
  }

  /// [diaryBookId] の日記帳に書かれた日記の数。
  Future<int> countIn(String diaryBookId) async {
    final response = await _client
        .from('diaries')
        .select('id')
        .eq('diary_book_id', diaryBookId)
        .count(CountOption.exact);
    return response.count;
  }

  /// 自分が [date] に書いた日記を、日記帳の id ごとに返す。
  Future<Map<String, Diary>> fetchMineOn(DateTime date) async {
    final rows = await _client
        .from('diaries')
        .select(
          'id, diary_book_id, author_id, date, written_at, '
          'diary_contents(title, body)',
        )
        .eq('author_id', _client.auth.currentUser!.id)
        .eq('date', _toDateString(date));
    return {
      for (final row in rows) row['diary_book_id'] as String: _toDiary(row),
    };
  }

  /// [diaryBookId] の日記帳に自分の [date] の日記を書く。
  /// もう書いていればタイトルと本文を書き換える（書いた時刻は変えない）。
  Future<void> save({
    required String diaryBookId,
    required DateTime date,
    required String title,
    required String body,
  }) async {
    await _client.rpc<String>(
      'save_diary',
      params: {
        'p_diary_book_id': diaryBookId,
        'p_date': _toDateString(date),
        'p_title': title,
        'p_body': body,
      },
    );
  }

  /// 自分の日記を消す。本文（diary_contents）も一緒に消える。
  Future<void> delete(String diaryId) async {
    await _client.from('diaries').delete().eq('id', diaryId);
  }

  Diary _toDiary(Map<String, dynamic> row) {
    // diary_id が主キーなので1対1になり、読めれば Map、読めなければ null が入る。
    final content = row['diary_contents'] as Map<String, dynamic>?;
    return Diary(
      id: row['id'] as String,
      authorId: row['author_id'] as String,
      date: DateTime.parse(row['date'] as String),
      writtenAt: DateTime.parse(row['written_at'] as String).toLocal(),
      title: content?['title'] as String?,
      body: content?['body'] as String?,
    );
  }

  String _toDateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
