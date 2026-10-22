import 'package:freezed_annotation/freezed_annotation.dart';

import 'diary_book.dart';

part '_generated/invited_diary_book.freezed.dart';
part '_generated/invited_diary_book.g.dart';

/// 招待コードで見つけた日記帳。参加する前に、どんな日記帳かを見せるのに使う。
@freezed
abstract class InvitedDiaryBook with _$InvitedDiaryBook {
  const factory InvitedDiaryBook({
    required String id,
    required String name,
    required List<String> memberNames,

    /// メンバーのアイコンの色。[memberNames] と同じ順。
    @Default([]) List<int?> memberAvatarColors,

    /// 自分がもう参加しているか。
    required bool alreadyJoined,

    /// 参加できる人数の上限。
    @Default(maxDiaryBookMembers) int memberLimit,
    int? coverColor,
  }) = _InvitedDiaryBook;

  const InvitedDiaryBook._();

  factory InvitedDiaryBook.fromJson(Map<String, dynamic> json) =>
      _$InvitedDiaryBookFromJson(json);

  /// 人数が上限に達していて、新しく参加できないか。もう参加していれば開けるので false。
  bool get isFull => !alreadyJoined && memberNames.length >= memberLimit;
}
