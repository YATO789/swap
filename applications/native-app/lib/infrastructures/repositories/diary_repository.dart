import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/reaction/reaction.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/diary_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/models/diary_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_photo/diary_photo_datasource.dart';

part '_generated/diary_repository.g.dart';

@riverpod
DiaryRepository diaryRepository(Ref ref) {
  return DiaryRepository(
    ref.watch(diaryDatasourceProvider),
    ref.watch(diaryPhotoDatasourceProvider),
  );
}

/// 日記を読み書きする。
class DiaryRepository {
  const DiaryRepository(this._datasource, this._photoDatasource);

  final DiaryDatasource _datasource;
  final DiaryPhotoDatasource _photoDatasource;

  /// [diaryBookId] の日記帳に書かれた [date] の日記を、書いた時刻の新しい順に返す。
  Future<List<Diary>> fetchOn(String diaryBookId, DateTime date) async {
    final responses = await _datasource.fetchOn(diaryBookId, date);
    return _toDiaries(responses);
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
    final diaries = await _toDiaries(responses);
    return {
      for (final (index, response) in responses.indexed)
        response.diaryBookId: diaries[index],
    };
  }

  /// 自分が [date] の日記をどれか1冊にでも書いたか。
  /// 写真の URL はもらわないので、書いたかどうかだけ知りたいときはこちらを使う。
  Future<bool> wroteOn(DateTime date) {
    return _datasource.wroteOn(date);
  }

  /// [diaryBookIds] の日記帳それぞれに、自分の [date] の日記として同じ内容を書く。
  /// もう書いている日記帳では、タイトルと本文を書き換える。
  ///
  /// 写真は、[newPhoto]（JPEG か PNG）があればその写真を1回だけ上げて、書いた日記すべてに付ける。
  /// なければ [photoPath] の写真を付ける（今の写真のまま）。どちらも null なら写真を外す。
  Future<void> save({
    required List<String> diaryBookIds,
    required DateTime date,
    required String title,
    required String body,
    String? photoPath,
    Uint8List? newPhoto,
  }) async {
    // 先に上げておく。上げられなければ日記も書かない。
    final path = newPhoto == null
        ? photoPath
        : await _photoDatasource.upload(newPhoto);
    final diaryIds = await Future.wait([
      for (final id in diaryBookIds)
        _datasource.save(diaryBookId: id, date: date, title: title, body: body),
    ]);
    // ほかの写真が付いていた日記も、上書きしたので同じ写真にそろえる。
    await _datasource.setPhotoPath(diaryIds, path);
  }

  /// 自分の日記を消す。
  Future<void> delete(String diaryId) {
    return _datasource.delete(diaryId);
  }

  /// 自分のリアクションを、ほかの人の [diaryId] の日記に [emoji] で付ける。もう付けていれば付け替える。
  Future<void> react(String diaryId, String emoji) {
    return _datasource.react(diaryId, emoji);
  }

  /// [diaryId] の日記から、自分のリアクションを取り消す。
  Future<void> removeReaction(String diaryId) {
    return _datasource.removeReaction(diaryId);
  }

  /// 日記にして返す。写真のある日記には、写真を見るための URL を付ける。
  Future<List<Diary>> _toDiaries(List<DiaryResponse> responses) async {
    final photoUrls = await _fetchPhotoUrls([
      for (final response in responses)
        if (response.photoPath != null) response.id,
    ]);
    return [
      for (final response in responses)
        _toDiary(response, photoUrl: photoUrls[response.id]),
    ];
  }

  /// 写真を見るための URL を日記の id ごとに返す。
  /// もらえなくても、日記そのものは出せるので失敗にしない（写真だけが出ない）。
  Future<Map<String, String>> _fetchPhotoUrls(List<String> diaryIds) async {
    if (diaryIds.isEmpty) return const {};
    try {
      return await _photoDatasource.fetchUrls(diaryIds);
    } on Object catch (e, stackTrace) {
      debugPrint('日記の写真の URL をもらえませんでした: $e\n$stackTrace');
      return const {};
    }
  }

  Diary _toDiary(DiaryResponse response, {String? photoUrl}) {
    final reactions = [...response.diaryReactions]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Diary(
      id: response.id,
      authorId: response.authorId,
      date: response.date,
      writtenAt: response.writtenAt,
      title: response.title,
      body: response.content?.body,
      photoPath: response.photoPath,
      photoUrl: photoUrl,
      reactions: [
        for (final reaction in reactions)
          Reaction(userId: reaction.userId, emoji: reaction.emoji),
      ],
    );
  }
}
