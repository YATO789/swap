import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/models/diary_response.dart';

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
  /// タイトルは常に返る。本文（diary_contents）は RLS で読めるものだけが返り、読めない日記は本文が null になる。
  Future<List<DiaryResponse>> fetchOn(String diaryBookId, DateTime date) async {
    final rows = await _client
        .from('diaries')
        .select(_columns)
        .eq('diary_book_id', diaryBookId)
        .eq('date', _toDateString(date))
        .order('written_at', ascending: false);
    return rows.map(DiaryResponse.fromJson).toList();
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

  /// 自分が [date] に書いた日記。日記帳ごとに1つずつ。
  Future<List<DiaryResponse>> fetchMineOn(DateTime date) async {
    final rows = await _client
        .from('diaries')
        .select(_columns)
        .eq('author_id', _client.auth.currentUser!.id)
        .eq('date', _toDateString(date));
    return rows.map(DiaryResponse.fromJson).toList();
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

  /// 自分のリアクションを、ほかの人の [diaryId] の日記に [emoji] で付ける。
  /// もう付けていれば [emoji] に付け替える。付けた時刻は DB が決める。
  Future<void> react(String diaryId, String emoji) async {
    // user_id は DB の既定値（auth.uid()）で入る。
    await _client.from('diary_reactions').upsert({
      'diary_id': diaryId,
      'emoji': emoji,
    }, onConflict: 'diary_id,user_id');
  }

  /// [diaryId] の日記から、自分のリアクションを取り消す。
  Future<void> removeReaction(String diaryId) async {
    // RLS で消せるのは自分のリアクションだけ。
    await _client.from('diary_reactions').delete().eq('diary_id', diaryId);
  }

  static const _columns =
      'id, diary_book_id, author_id, date, written_at, title, '
      'diary_contents(body), diary_reactions(user_id, emoji, created_at)';

  String _toDateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
