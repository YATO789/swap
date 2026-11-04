import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book_response.freezed.dart';
part '_generated/diary_book_response.g.dart';

/// diary_books の1行。create_diary_book もこの形で返す。
@freezed
abstract class DiaryBookResponse with _$DiaryBookResponse {
  const factory DiaryBookResponse({
    required String id,
    required String name,
    required String inviteCode,
    required int memberLimit,
    String? createdBy,
    int? coverColor,

    /// 表紙の飾りの JSON。メンバーなら好きな値を書けるので、形は読むときに確かめる。
    Object? coverDecoration,
  }) = _DiaryBookResponse;

  factory DiaryBookResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryBookResponseFromJson(json);
}
