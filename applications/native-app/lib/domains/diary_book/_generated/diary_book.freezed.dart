// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiaryBook {

 String get id; String get name;/// アイコンに表示する1文字。DB が名前の1文字目から作る。
 String get icon;/// 友達をこの日記帳に招待するためのコード。受け取った人が入力すると参加できる。
 String get inviteCode; int get memberCount;/// 日記帳を作った人の id。メンバーを外せるのはこの人だけ。アカウントを消していれば null。
 String? get createdBy;/// 日記帳の表紙の色（0xAARRGGBB）。null なら決まったグレーにする。
 int? get coverColor;
/// Create a copy of DiaryBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookCopyWith<DiaryBook> get copyWith => _$DiaryBookCopyWithImpl<DiaryBook>(this as DiaryBook, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiaryBook;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBook&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.inviteCode, _this.inviteCode) || other.inviteCode == _this.inviteCode)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.coverColor, _this.coverColor) || other.coverColor == _this.coverColor));
}


@override
int get hashCode {
  final _this = this as DiaryBook;
  return Object.hash(runtimeType,_this.id,_this.name,_this.icon,_this.inviteCode,_this.memberCount,_this.createdBy,_this.coverColor);
}

@override
String toString() {
  final _this = this as DiaryBook;
  return 'DiaryBook(id: ${_this.id}, name: ${_this.name}, icon: ${_this.icon}, inviteCode: ${_this.inviteCode}, memberCount: ${_this.memberCount}, createdBy: ${_this.createdBy}, coverColor: ${_this.coverColor})';
}


}

/// @nodoc
abstract mixin class $DiaryBookCopyWith<$Res>  {
  factory $DiaryBookCopyWith(DiaryBook value, $Res Function(DiaryBook) _then) = _$DiaryBookCopyWithImpl;
@useResult
$Res call({
 String id, String name, String icon, String inviteCode, int memberCount, String? createdBy, int? coverColor
});




}
/// @nodoc
class _$DiaryBookCopyWithImpl<$Res>
    implements $DiaryBookCopyWith<$Res> {
  _$DiaryBookCopyWithImpl(this._self, this._then);

  final DiaryBook _self;
  final $Res Function(DiaryBook) _then;

/// Create a copy of DiaryBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? inviteCode = null,Object? memberCount = null,Object? createdBy = freezed,Object? coverColor = freezed,}) {
  return _then(DiaryBook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryBook].
extension DiaryBookPatterns on DiaryBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBook value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBook value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String icon,  String inviteCode,  int memberCount,  String? createdBy,  int? coverColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBook() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.inviteCode,_that.memberCount,_that.createdBy,_that.coverColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String icon,  String inviteCode,  int memberCount,  String? createdBy,  int? coverColor)  $default,) {final _that = this;
switch (_that) {
case _DiaryBook():
return $default(_that.id,_that.name,_that.icon,_that.inviteCode,_that.memberCount,_that.createdBy,_that.coverColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String icon,  String inviteCode,  int memberCount,  String? createdBy,  int? coverColor)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBook() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.inviteCode,_that.memberCount,_that.createdBy,_that.coverColor);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryBook implements DiaryBook {
  const _DiaryBook({required this.id, required this.name, required this.icon, required this.inviteCode, required this.memberCount, this.createdBy, this.coverColor});
  

@override final  String id;
@override final  String name;
/// アイコンに表示する1文字。DB が名前の1文字目から作る。
@override final  String icon;
/// 友達をこの日記帳に招待するためのコード。受け取った人が入力すると参加できる。
@override final  String inviteCode;
@override final  int memberCount;
/// 日記帳を作った人の id。メンバーを外せるのはこの人だけ。アカウントを消していれば null。
@override final  String? createdBy;
/// 日記帳の表紙の色（0xAARRGGBB）。null なら決まったグレーにする。
@override final  int? coverColor;

/// Create a copy of DiaryBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookCopyWith<_DiaryBook> get copyWith => __$DiaryBookCopyWithImpl<_DiaryBook>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBook&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.coverColor, coverColor) || other.coverColor == coverColor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,icon,inviteCode,memberCount,createdBy,coverColor);
}

@override
String toString() {
    return 'DiaryBook(id: $id, name: $name, icon: $icon, inviteCode: $inviteCode, memberCount: $memberCount, createdBy: $createdBy, coverColor: $coverColor)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookCopyWith<$Res> implements $DiaryBookCopyWith<$Res> {
  factory _$DiaryBookCopyWith(_DiaryBook value, $Res Function(_DiaryBook) _then) = __$DiaryBookCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String icon, String inviteCode, int memberCount, String? createdBy, int? coverColor
});




}
/// @nodoc
class __$DiaryBookCopyWithImpl<$Res>
    implements _$DiaryBookCopyWith<$Res> {
  __$DiaryBookCopyWithImpl(this._self, this._then);

  final _DiaryBook _self;
  final $Res Function(_DiaryBook) _then;

/// Create a copy of DiaryBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? inviteCode = null,Object? memberCount = null,Object? createdBy = freezed,Object? coverColor = freezed,}) {
  return _then(_DiaryBook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
