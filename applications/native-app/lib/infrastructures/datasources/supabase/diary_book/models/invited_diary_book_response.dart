import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/invited_diary_book_response.freezed.dart';
part '_generated/invited_diary_book_response.g.dart';

/// find_diary_book_by_code が返す1行。
@freezed
abstract class InvitedDiaryBookResponse with _$InvitedDiaryBookResponse {
  const factory InvitedDiaryBookResponse({
    required String id,
    required String name,
    required int memberLimit,
    required List<String> memberNames,

    /// avatars バケットの中のパス。[memberNames] と同じ順で、画像のない人は null。
    @Default([]) List<String?> memberAvatarPaths,
    required bool alreadyJoined,
    int? coverColor,
  }) = _InvitedDiaryBookResponse;

  factory InvitedDiaryBookResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitedDiaryBookResponseFromJson(json);
}
