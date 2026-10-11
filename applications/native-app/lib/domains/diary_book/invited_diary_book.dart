import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/invited_diary_book.freezed.dart';

/// 招待コードで見つけた日記帳。参加する前に、どんな日記帳かを見せるのに使う。
@freezed
abstract class InvitedDiaryBook with _$InvitedDiaryBook {
  const factory InvitedDiaryBook({
    required String id,
    required String name,

    /// アイコンに表示する1文字。
    required String icon,

    /// 参加している人の表示名。参加した順。
    required List<String> memberNames,

    /// 自分がもう参加しているか。
    required bool alreadyJoined,

    /// 日記帳の表紙の色（0xAARRGGBB）。null なら決まったグレーにする。
    int? coverColor,
  }) = _InvitedDiaryBook;
}
