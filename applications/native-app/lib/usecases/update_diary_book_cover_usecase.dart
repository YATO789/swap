import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_cover_field.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';

part '_generated/update_diary_book_cover_usecase.g.dart';

@riverpod
UpdateDiaryBookCoverUseCase updateDiaryBookCoverUseCase(Ref ref) {
  return UpdateDiaryBookCoverUseCase(ref.watch(diaryBookRepositoryProvider));
}

/// 日記帳の表紙（名前・色・飾り）を [original] から [edited] に変える。
///
/// 変わった項目だけを書く。編集しているあいだにほかの人が変えた項目を、
/// 開いたときの値で上書きしないようにするため。何も変わっていなければ何もしない。
class UpdateDiaryBookCoverUseCase {
  const UpdateDiaryBookCoverUseCase(this._diaryBookRepository);

  final DiaryBookRepository _diaryBookRepository;

  Future<void> call(DiaryBook original, DiaryBook edited) async {
    final fields = {
      if (edited.name != original.name) DiaryBookCoverField.name,
      if (edited.coverColor != original.coverColor) DiaryBookCoverField.color,
      if (_normalized(edited.coverDecoration) !=
          _normalized(original.coverDecoration))
        DiaryBookCoverField.decoration,
    };
    if (fields.isEmpty) {
      return;
    }
    await _diaryBookRepository.updateCover(edited, fields);
  }

  /// 飾りがないことと、v1 で何も飾っていないことを同じに扱うため、後者を null にする。
  CoverDecoration? _normalized(CoverDecoration? decoration) {
    if (decoration == null || (decoration.isEmpty && !decoration.placesName)) {
      return null;
    }
    return decoration;
  }
}
