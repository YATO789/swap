import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/profile.freezed.dart';

/// 日記帳のメンバーに見せる自分の情報。オンボーディングで名前を決めたときに作る。
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String displayName,

    /// アイコンの色（0xAARRGGBB）。null なら決まった色。
    int? avatarColor,
  }) = _Profile;
}

/// 表示名の最大文字数。DB の profiles.display_name の制約と合わせる。
const maxDisplayNameLength = 15;
