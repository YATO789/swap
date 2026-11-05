import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/reaction.freezed.dart';

/// 記録や日記に付いた絵文字のリアクション。1つの記録や日記に1人1つ。
@freezed
abstract class Reaction with _$Reaction {
  const factory Reaction({required String userId, required String emoji}) =
      _Reaction;
}

/// 付けた順に並んだリアクション。
extension ReactionList on List<Reaction> {
  /// [userId] の人が付けた絵文字。付けていなければ null。
  String? emojiOf(String? userId) {
    for (final reaction in this) {
      if (reaction.userId == userId) return reaction.emoji;
    }
    return null;
  }

  /// [userId] の人のリアクションを [emoji] にした一覧。同じ絵文字なら取り消す。
  /// 付け替えたときは並びの最後に回す。
  List<Reaction> reactedBy(String userId, String emoji) {
    final previous = emojiOf(userId);
    return [
      for (final reaction in this)
        if (reaction.userId != userId) reaction,
      if (previous != emoji) Reaction(userId: userId, emoji: emoji),
    ];
  }

  /// [userId] の人のリアクションだけを [other] のものに戻した一覧。ほかの人のものはそのまま。
  List<Reaction> withReactionOf(String userId, List<Reaction> other) {
    return [
      for (final reaction in this)
        if (reaction.userId != userId) reaction,
      for (final reaction in other)
        if (reaction.userId == userId) reaction,
    ];
  }
}
