import 'package:flutter_test/flutter_test.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/diary_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/models/diary_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_photo/diary_photo_datasource.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';

/// [responses] を、読んだ日記として返す。
class _FakeDiaryDatasource implements DiaryDatasource {
  _FakeDiaryDatasource({this.responses = const []});

  final List<DiaryResponse> responses;

  @override
  Future<List<DiaryResponse>> fetchOn(String diaryBookId, DateTime date) async {
    return responses;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 写真の URL を頼まれた日記の id を覚えておく。
class _FakeDiaryPhotoDatasource implements DiaryPhotoDatasource {
  _FakeDiaryPhotoDatasource({this.failsFetch = false});

  final bool failsFetch;
  final List<List<String>> fetchedIds = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Map<String, String>> fetchUrls(List<String> diaryIds) async {
    fetchedIds.add(diaryIds);
    if (failsFetch) throw Exception('URL をもらえない');
    return {for (final id in diaryIds) id: 'https://r2.example/$id'};
  }
}

DiaryResponse _response(String id, {String? photoPath}) {
  return DiaryResponse(
    id: id,
    diaryBookId: 'book',
    authorId: 'me',
    date: DateTime(2026, 11, 21),
    writtenAt: DateTime(2026, 11, 21, 21),
    title: '',
    photoPath: photoPath,
  );
}

void main() {
  final date = DateTime(2026, 11, 21);

  group('fetchOn', () {
    test('写真のある日記だけ URL をもらって付ける', () async {
      final photoDatasource = _FakeDiaryPhotoDatasource();
      final diaries = await DiaryRepository(
        _FakeDiaryDatasource(
          responses: [
            _response('with-photo', photoPath: 'diaries/me/a.jpg'),
            _response('without-photo'),
          ],
        ),
        photoDatasource,
      ).fetchOn('book', date);

      expect(photoDatasource.fetchedIds, [
        ['with-photo'],
      ]);
      expect(diaries[0].photoPath, 'diaries/me/a.jpg');
      expect(diaries[0].photoUrl, 'https://r2.example/with-photo');
      expect(diaries[1].photoPath, isNull);
      expect(diaries[1].photoUrl, isNull);
    });

    test('写真のある日記がなければ、URL を頼まない', () async {
      final photoDatasource = _FakeDiaryPhotoDatasource();
      await DiaryRepository(
        _FakeDiaryDatasource(responses: [_response('without-photo')]),
        photoDatasource,
      ).fetchOn('book', date);

      expect(photoDatasource.fetchedIds, isEmpty);
    });

    test('URL をもらえなくても、日記は返す', () async {
      final diaries = await DiaryRepository(
        _FakeDiaryDatasource(
          responses: [_response('with-photo', photoPath: 'diaries/me/a.jpg')],
        ),
        _FakeDiaryPhotoDatasource(failsFetch: true),
      ).fetchOn('book', date);

      expect(diaries.single.photoPath, 'diaries/me/a.jpg');
      expect(diaries.single.photoUrl, isNull);
    });
  });
}
