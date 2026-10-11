import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book.freezed.dart';

/// 友達と記録や日記を見せ合うグループ。
@freezed
abstract class DiaryBook with _$DiaryBook {
  const factory DiaryBook({
    required String id,
    required String name,

    /// アイコンに表示する1文字。DB が名前の1文字目から作る。
    required String icon,

    /// 友達をこの日記帳に招待するためのコード。受け取った人が入力すると参加できる。
    required String inviteCode,
    required int memberCount,

    /// 日記帳の表紙の色（0xAARRGGBB）。null なら決まったグレーにする。
    int? coverColor,
  }) = _DiaryBook;
}
