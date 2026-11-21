import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';

part '_generated/save_diary_usecase.g.dart';

@riverpod
SaveDiaryUseCase saveDiaryUseCase(Ref ref) {
  return SaveDiaryUseCase(ref.watch(diaryRepositoryProvider));
}

/// [diaryBookIds] の日記帳それぞれに、自分の [date] の日記として同じ内容を書く。
/// もう書いている日記帳では、タイトルと本文を書き換える。
///
/// 写真は、[newPhoto]（JPEG か PNG）があればその写真を1回だけ上げて、書いた日記すべてに付ける。
/// なければ [photoPath] の写真を付ける（今の写真のまま）。どちらも null なら写真を外す。
class SaveDiaryUseCase {
  const SaveDiaryUseCase(this._diaryRepository);

  final DiaryRepository _diaryRepository;

  Future<void> call({
    required List<String> diaryBookIds,
    required DateTime date,
    required String title,
    required String body,
    String? photoPath,
    Uint8List? newPhoto,
  }) async {
    // 先に上げておく。上げられなければ日記も書かない。
    final String? path;
    if (newPhoto == null) {
      path = photoPath;
    } else {
      path = await _diaryRepository.uploadPhoto(newPhoto);
    }
    final diaryIds = await Future.wait([
      for (final id in diaryBookIds)
        _diaryRepository.save(
          diaryBookId: id,
          date: date,
          title: title,
          body: body,
        ),
    ]);
    // 一緒に保存した日記すべてに、同じ写真のパスを付ける（写真は R2 に1枚だけ）。
    // save はタイトルと本文しか書かないので、写真はここで書く。
    // 上書きした日記に別の写真が付いていても、この写真にそろえる。
    await _diaryRepository.setPhotoPath(diaryIds, path);
  }
}
