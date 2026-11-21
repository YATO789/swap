import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/usecases/save_diary_usecase.dart';

/// 書いた日記帳、上げた写真、写真を付けた日記を覚えておく。
class _FakeDiaryRepository implements DiaryRepository {
  _FakeDiaryRepository({this.failsUpload = false});

  final bool failsUpload;
  final List<String> savedDiaryBookIds = [];
  final List<Uint8List> uploaded = [];

  /// setPhotoPath に渡された日記の id（カンマでつないだもの）とパス。
  final List<(String, String?)> photoPathCalls = [];

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
  Future<String> uploadPhoto(Uint8List bytes) async {
    if (failsUpload) throw Exception('上げられない');
    uploaded.add(bytes);
    return 'diaries/me/new.jpg';
  }

  @override
  Future<void> setPhotoPath(List<String> diaryIds, String? photoPath) async {
    photoPathCalls.add((diaryIds.join(','), photoPath));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  final date = DateTime(2026, 11, 21);
  final photo = Uint8List.fromList([0xFF, 0xD8, 0xFF]);

  test('新しい写真は1回だけ上げ、書いた日記すべてに同じパスを付ける', () async {
    final repository = _FakeDiaryRepository();
    await SaveDiaryUseCase(repository)(
      diaryBookIds: ['family', 'university'],
      date: date,
      title: '',
      body: '散歩をした',
      photoPath: 'diaries/me/old.jpg',
      newPhoto: photo,
    );

    expect(repository.uploaded, [photo]);
    expect(repository.savedDiaryBookIds, ['family', 'university']);
    expect(repository.photoPathCalls, [
      ('family-diary,university-diary', 'diaries/me/new.jpg'),
    ]);
  });

  test('新しい写真がなければ、今の写真のパスを付ける', () async {
    final repository = _FakeDiaryRepository();
    await SaveDiaryUseCase(repository)(
      diaryBookIds: ['family'],
      date: date,
      title: '',
      body: '散歩をした',
      photoPath: 'diaries/me/old.jpg',
    );

    expect(repository.uploaded, isEmpty);
    expect(repository.photoPathCalls, [('family-diary', 'diaries/me/old.jpg')]);
  });

  test('どちらもなければ写真を外す', () async {
    final repository = _FakeDiaryRepository();
    await SaveDiaryUseCase(repository)(
      diaryBookIds: ['family'],
      date: date,
      title: '',
      body: '散歩をした',
    );

    expect(repository.photoPathCalls, [('family-diary', null)]);
  });

  test('写真を上げられなければ、日記も書かない', () async {
    final repository = _FakeDiaryRepository(failsUpload: true);

    await expectLater(
      SaveDiaryUseCase(repository)(
        diaryBookIds: ['family'],
        date: date,
        title: '',
        body: '散歩をした',
        newPhoto: photo,
      ),
      throwsException,
    );
    expect(repository.savedDiaryBookIds, isEmpty);
    expect(repository.photoPathCalls, isEmpty);
  });
}
