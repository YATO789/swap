// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_book_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryBookMember {

 String get userId; String get displayName;/// アイコンの色（0xAARRGGBB）。null なら決まった色。
 int? get avatarColor;
/// Create a copy of DiaryBookMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookMemberCopyWith<DiaryBookMember> get copyWith => _$DiaryBookMemberCopyWithImpl<DiaryBookMember>(this as DiaryBookMember, _$identity);

  /// Serializes this DiaryBookMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryBookMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBookMember&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarColor, _this.avatarColor) || other.avatarColor == _this.avatarColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryBookMember;
  return Object.hash(runtimeType,_this.userId,_this.displayName,_this.avatarColor);
}

@override
String toString() {
  final _this = this as DiaryBookMember;
  return 'DiaryBookMember(userId: ${_this.userId}, displayName: ${_this.displayName}, avatarColor: ${_this.avatarColor})';
}


}

/// @nodoc
abstract mixin class $DiaryBookMemberCopyWith<$Res>  {
  factory $DiaryBookMemberCopyWith(DiaryBookMember value, $Res Function(DiaryBookMember) _then) = _$DiaryBookMemberCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName, int? avatarColor
});




}
/// @nodoc
class _$DiaryBookMemberCopyWithImpl<$Res>
    implements $DiaryBookMemberCopyWith<$Res> {
  _$DiaryBookMemberCopyWithImpl(this._self, this._then);

  final DiaryBookMember _self;
  final $Res Function(DiaryBookMember) _then;

/// Create a copy of DiaryBookMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? avatarColor = freezed,}) {
  return _then(DiaryBookMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: freezed == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryBookMember].
extension DiaryBookMemberPatterns on DiaryBookMember {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBookMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBookMember() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBookMember value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBookMember():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBookMember value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBookMember() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName,  int? avatarColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBookMember() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName,  int? avatarColor)  $default,) {final _that = this;
switch (_that) {
case _DiaryBookMember():
return $default(_that.userId,_that.displayName,_that.avatarColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName,  int? avatarColor)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBookMember() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryBookMember implements DiaryBookMember {
  const _DiaryBookMember({required this.userId, required this.displayName, this.avatarColor});
  factory _DiaryBookMember.fromJson(Map<String, dynamic> json) => _$DiaryBookMemberFromJson(json);

@override final  String userId;
@override final  String displayName;
/// アイコンの色（0xAARRGGBB）。null なら決まった色。
@override final  int? avatarColor;

/// Create a copy of DiaryBookMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookMemberCopyWith<_DiaryBookMember> get copyWith => __$DiaryBookMemberCopyWithImpl<_DiaryBookMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryBookMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBookMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,displayName,avatarColor);
}

@override
String toString() {
    return 'DiaryBookMember(userId: $userId, displayName: $displayName, avatarColor: $avatarColor)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookMemberCopyWith<$Res> implements $DiaryBookMemberCopyWith<$Res> {
  factory _$DiaryBookMemberCopyWith(_DiaryBookMember value, $Res Function(_DiaryBookMember) _then) = __$DiaryBookMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName, int? avatarColor
});




}
/// @nodoc
class __$DiaryBookMemberCopyWithImpl<$Res>
    implements _$DiaryBookMemberCopyWith<$Res> {
  __$DiaryBookMemberCopyWithImpl(this._self, this._then);

  final _DiaryBookMember _self;
  final $Res Function(_DiaryBookMember) _then;

/// Create a copy of DiaryBookMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? avatarColor = freezed,}) {
  return _then(_DiaryBookMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: freezed == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
