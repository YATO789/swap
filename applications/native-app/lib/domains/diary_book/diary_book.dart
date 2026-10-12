import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book.freezed.dart';

/// 友達と記録や日記を見せ合うグループ。
@freezed
abstract class DiaryBook with _$DiaryBook {
  const factory DiaryBook({
    required String id,
    required String name,

    /// 友達をこの日記帳に招待するためのコード。受け取った人が入力すると参加できる。
    required String inviteCode,
    required int memberCount,

    /// 日記帳を作った人の id。メンバーを外せるのはこの人だけ。アカウントを消していれば null。
    String? createdBy,

    /// 日記帳の表紙の色（0xAARRGGBB）。null なら決まったグレーにする。
    int? coverColor,
  }) = _DiaryBook;
}

/// 日記帳の名前の最大文字数。DB の diary_books.name の制約と合わせる。
const maxDiaryBookNameLength = 15;

/// 1冊の日記帳に参加できる最大人数。DB の join_diary_book と合わせる。
const maxDiaryBookMembers = 8;

/// 招待コードの文字数。DB の create_diary_book が作るコードと合わせる。大文字と小文字は区別する。
const inviteCodeLength = 7;
