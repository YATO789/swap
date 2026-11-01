import 'package:flutter_test/flutter_test.dart';
import 'package:swap/domains/diary_book/cover_decoration.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_cover_field.dart';
import 'package:swap/infrastructures/datasources/supabase/avatar/avatar_datasource.dart';
import 'package:swap/infrastructures/datasources/supabase/diary_book/diary_book_datasource.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';

/// updateCover に渡された列を覚えておく。
class _FakeDiaryBookDatasource implements DiaryBookDatasource {
  final updates = <Map<String, Object?>>[];

  @override
  Future<void> updateCover(
    String diaryBookId,
    Map<String, Object?> values,
  ) async {
    updates.add(values);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _FakeAvatarDatasource implements AvatarDatasource {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

const _diaryBook = DiaryBook(
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
  late _FakeDiaryBookDatasource datasource;
  late DiaryBookRepository repository;

  setUp(() {
    datasource = _FakeDiaryBookDatasource();
    repository = DiaryBookRepository(datasource, _FakeAvatarDatasource());
  });

  group('updateCover', () {
    test('指定した項目の列だけを送る', () async {
      await repository.updateCover(
        _diaryBook.copyWith(coverDecoration: _decoration),
        {DiaryBookCoverField.decoration},
      );

      expect(datasource.updates.single.keys, ['cover_decoration']);
    });

    test('名前と色と飾りを1回で送る', () async {
      await repository.updateCover(
        _diaryBook.copyWith(
          name: '夏休み',
          coverColor: null,
          coverDecoration: _decoration,
        ),
        DiaryBookCoverField.values.toSet(),
      );

      final values = datasource.updates.single;
      expect(values['name'], '夏休み');
      expect(values.containsKey('cover_color'), isTrue);
      expect(values['cover_color'], isNull);
      expect(values['cover_decoration'], isA<Map<String, dynamic>>());
    });

    test('飾りがなければ null を送る', () async {
      await repository.updateCover(_diaryBook, {
        DiaryBookCoverField.decoration,
      });

      final values = datasource.updates.single;
      expect(values.keys, ['cover_decoration']);
      expect(values['cover_decoration'], isNull);
    });

    test('何もない飾りは、何もない飾りとして送る（名前を出さない表紙）', () async {
      await repository.updateCover(
        _diaryBook.copyWith(coverDecoration: const CoverDecoration()),
        {DiaryBookCoverField.decoration},
      );

      final values = datasource.updates.single;
      expect(values['cover_decoration'], {
        'v': coverDecorationVersion,
        'stickers': <Object>[],
        'strokes': <Object>[],
      });
    });
  });
}
