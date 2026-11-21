import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/diary_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary/models/diary_response.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_photo/diary_photo_datasource.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';

/// 書いた日記と、写真を付けた日記を覚えておく。
class _FakeDiaryDatasource implements DiaryDatasource {
  _FakeDiaryDatasource({this.responses = const []});

  final List<DiaryResponse> responses;
  final List<String> savedDiaryBookIds = [];

  /// setPhotoPath に渡された日記の id（カンマでつないだもの）とパス。
  final List<(String, String?)> photoPathCalls = [];

  @override
  Future<List<DiaryResponse>> fetchOn(String diaryBookId, DateTime date) async {
    return responses;
  }

  @override
  Future<String> save({
    required String diaryBookId,
    required DateTime date,
    required String title,
    required String body,
  }) async {
    savedDiaryBookIds.add(diaryBookId);
    return '$diaryBookId-diary';
  }

  @override
  Future<void> setPhotoPath(List<String> diaryIds, String? photoPath) async {
    photoPathCalls.add((diaryIds.join(','), photoPath));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDiaryPhotoDatasource implements DiaryPhotoDatasource {
  _FakeDiaryPhotoDatasource({
    this.failsUpload = false,
    this.failsFetch = false,
  });

  final bool failsUpload;
  final bool failsFetch;
  final List<Uint8List> uploaded = [];
  final List<List<String>> fetchedIds = [];

  @override
  Future<String> upload(Uint8List bytes) async {
    if (failsUpload) throw Exception('上げられない');
    uploaded.add(bytes);
    return 'diaries/me/new.jpg';
  }

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
  final photo = Uint8List.fromList([0xFF, 0xD8, 0xFF]);

  group('save', () {
    test('新しい写真は1回だけ上げ、書いた日記すべてに同じパスを付ける', () async {
      final datasource = _FakeDiaryDatasource();
      final photoDatasource = _FakeDiaryPhotoDatasource();
      await DiaryRepository(datasource, photoDatasource).save(
        diaryBookIds: ['family', 'university'],
        date: date,
        title: '',
        body: '散歩をした',
        photoPath: 'diaries/me/old.jpg',
        newPhoto: photo,
      );

      expect(photoDatasource.uploaded, [photo]);
      expect(datasource.photoPathCalls, [
        ('family-diary,university-diary', 'diaries/me/new.jpg'),
      ]);
    });

    test('新しい写真がなければ、今の写真のパスを付ける', () async {
      final datasource = _FakeDiaryDatasource();
      final photoDatasource = _FakeDiaryPhotoDatasource();
      await DiaryRepository(datasource, photoDatasource).save(
        diaryBookIds: ['family'],
        date: date,
        title: '',
        body: '散歩をした',
        photoPath: 'diaries/me/old.jpg',
      );

      expect(photoDatasource.uploaded, isEmpty);
      expect(datasource.photoPathCalls, [
        ('family-diary', 'diaries/me/old.jpg'),
      ]);
    });

    test('どちらもなければ写真を外す', () async {
      final datasource = _FakeDiaryDatasource();
      await DiaryRepository(
        datasource,
        _FakeDiaryPhotoDatasource(),
      ).save(diaryBookIds: ['family'], date: date, title: '', body: '散歩をした');

      expect(datasource.photoPathCalls, [('family-diary', null)]);
    });

    test('写真を上げられなければ、日記も書かない', () async {
      final datasource = _FakeDiaryDatasource();
      final repository = DiaryRepository(
        datasource,
        _FakeDiaryPhotoDatasource(failsUpload: true),
      );

      await expectLater(
        repository.save(
          diaryBookIds: ['family'],
          date: date,
          title: '',
          body: '散歩をした',
          newPhoto: photo,
        ),
        throwsException,
      );
      expect(datasource.savedDiaryBookIds, isEmpty);
      expect(datasource.photoPathCalls, isEmpty);
    });
  });

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
