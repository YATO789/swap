import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_cover_field.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/usecases/update_diary_book_cover_usecase.dart';

/// updateCover に渡された日記帳と項目を覚えておく。
class _FakeDiaryBookRepository implements DiaryBookRepository {
  final updates = <(DiaryBook, Set<DiaryBookCoverField>)>[];

  @override
  Future<void> updateCover(
    DiaryBook diaryBook,
    Set<DiaryBookCoverField> fields,
  ) async {
    updates.add((diaryBook, fields));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

const _original = DiaryBook(
  id: 'book',
  name: '旅行',
  inviteCode: 'Ab23456',
  memberCount: 2,
  coverColor: 0xFF9EE6C4,
);

const _decoration = CoverDecoration(
  stickers: [CoverSticker(emoji: '🌻', x: 0.5, y: 0.5, size: 0.2)],
);

void main() {
  late _FakeDiaryBookRepository repository;
  late UpdateDiaryBookCoverUseCase useCase;

  setUp(() {
    repository = _FakeDiaryBookRepository();
    useCase = UpdateDiaryBookCoverUseCase(repository);
  });

  test('変わった項目だけを書く', () async {
    final edited = _original.copyWith(coverDecoration: _decoration);
    await useCase(_original, edited);

    final (diaryBook, fields) = repository.updates.single;
    expect(diaryBook, edited);
    expect(fields, {DiaryBookCoverField.decoration});
  });

  test('名前と色と飾りが変わったら、全部を1回で書く', () async {
    await useCase(
      _original,
      _original.copyWith(
        name: '夏休み',
        coverColor: null,
        coverDecoration: _decoration,
      ),
    );

    expect(repository.updates.single.$2, DiaryBookCoverField.values.toSet());
  });

  test('飾りをなくしたら、飾りを書く', () async {
    await useCase(
      _original.copyWith(coverDecoration: _decoration),
      _original.copyWith(coverDecoration: null),
    );

    expect(repository.updates.single.$2, {DiaryBookCoverField.decoration});
  });

  test('名前も含めて全部はがしたら、飾りを書く（名前を出さない表紙）', () async {
    await useCase(
      _original.copyWith(coverDecoration: _decoration),
      _original.copyWith(coverDecoration: const CoverDecoration()),
    );

    expect(repository.updates.single.$2, {DiaryBookCoverField.decoration});
  });

  test('飾りがないのと v1 で何も飾っていないのは、同じとみなす', () async {
    await useCase(
      _original,
      _original.copyWith(coverDecoration: const CoverDecoration(version: 1)),
    );

    expect(repository.updates, isEmpty);
  });

  test('何も変わっていなければ書かない', () async {
    await useCase(_original, _original);

    expect(repository.updates, isEmpty);
  });
}
