import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/diary_book.freezed.dart';

/// 友達と記録や日記を見せ合うグループ。
@freezed
abstract class DiaryBook with _$DiaryBook {
  const factory DiaryBook({
    required String id,
    required String name,
    required String inviteCode,
    required int memberCount,

    /// 参加できる人数の上限。作った人が 1〜[maxDiaryBookMembers] 人で変えられる。
    @Default(maxDiaryBookMembers) int memberLimit,

    /// 日記帳を作った人の id。メンバーを外したり人数の上限を変えたりできるのはこの人だけ。
    /// アカウントを消していれば null。
    String? createdBy,
    int? coverColor,
  }) = _DiaryBook;
}

/// 日記帳の名前の最大文字数。DB の diary_books.name の制約と合わせる。
const maxDiaryBookNameLength = 15;

/// 日記帳の人数の上限として選べる最大の人数。DB の diary_books.member_limit の制約と合わせる。
const maxDiaryBookMembers = 8;

/// 招待コードの文字数。DB の create_diary_book が作るコードと合わせる。大文字と小文字は区別する。
const inviteCodeLength = 7;
