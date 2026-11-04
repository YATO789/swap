import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap/utils/local_date_time_converter.dart';

part '_generated/diary_response.freezed.dart';
part '_generated/diary_response.g.dart';

/// diaries の1行（タイトルを含む）に、本文（diary_contents）を付けたもの。
@freezed
abstract class DiaryResponse with _$DiaryResponse {
  const factory DiaryResponse({
    required String id,
    required String diaryBookId,
    required String authorId,
    required DateTime date,
    @LocalDateTimeConverter() required DateTime writtenAt,

    /// 空ならタイトルなし。まだ読めない日記でも返る。
    required String title,

    /// diary_id が主キーなので1対1になる。RLS で読めなければ null。
    @JsonKey(name: 'diary_contents') DiaryContentResponse? content,
  }) = _DiaryResponse;

  factory DiaryResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryResponseFromJson(json);
}

/// diary_contents の1行。
@freezed
abstract class DiaryContentResponse with _$DiaryContentResponse {
  const factory DiaryContentResponse({required String body}) =
      _DiaryContentResponse;

  factory DiaryContentResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryContentResponseFromJson(json);
}
