// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../invited_diary_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvitedDiaryBook {

 String get id; String get name; List<String> get memberNames;/// 自分がもう参加しているか。
 bool get alreadyJoined;/// 参加できる人数の上限。
 int get memberLimit; int? get coverColor;
/// Create a copy of InvitedDiaryBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitedDiaryBookCopyWith<InvitedDiaryBook> get copyWith => _$InvitedDiaryBookCopyWithImpl<InvitedDiaryBook>(this as InvitedDiaryBook, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InvitedDiaryBook;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitedDiaryBook&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.memberNames, _this.memberNames)&&(identical(other.alreadyJoined, _this.alreadyJoined) || other.alreadyJoined == _this.alreadyJoined)&&(identical(other.memberLimit, _this.memberLimit) || other.memberLimit == _this.memberLimit)&&(identical(other.coverColor, _this.coverColor) || other.coverColor == _this.coverColor));
}


@override
int get hashCode {
  final _this = this as InvitedDiaryBook;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.memberNames),_this.alreadyJoined,_this.memberLimit,_this.coverColor);
}

@override
String toString() {
  final _this = this as InvitedDiaryBook;
  return 'InvitedDiaryBook(id: ${_this.id}, name: ${_this.name}, memberNames: ${_this.memberNames}, alreadyJoined: ${_this.alreadyJoined}, memberLimit: ${_this.memberLimit}, coverColor: ${_this.coverColor})';
}


}

/// @nodoc
abstract mixin class $InvitedDiaryBookCopyWith<$Res>  {
  factory $InvitedDiaryBookCopyWith(InvitedDiaryBook value, $Res Function(InvitedDiaryBook) _then) = _$InvitedDiaryBookCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> memberNames, bool alreadyJoined, int memberLimit, int? coverColor
});




}
/// @nodoc
class _$InvitedDiaryBookCopyWithImpl<$Res>
    implements $InvitedDiaryBookCopyWith<$Res> {
  _$InvitedDiaryBookCopyWithImpl(this._self, this._then);

  final InvitedDiaryBook _self;
  final $Res Function(InvitedDiaryBook) _then;

/// Create a copy of InvitedDiaryBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? memberNames = null,Object? alreadyJoined = null,Object? memberLimit = null,Object? coverColor = freezed,}) {
  return _then(InvitedDiaryBook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberNames: null == memberNames ? _self.memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,alreadyJoined: null == alreadyJoined ? _self.alreadyJoined : alreadyJoined // ignore: cast_nullable_to_non_nullable
as bool,memberLimit: null == memberLimit ? _self.memberLimit : memberLimit // ignore: cast_nullable_to_non_nullable
as int,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitedDiaryBook].
extension InvitedDiaryBookPatterns on InvitedDiaryBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitedDiaryBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitedDiaryBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitedDiaryBook value)  $default,){
final _that = this;
switch (_that) {
case _InvitedDiaryBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitedDiaryBook value)?  $default,){
final _that = this;
switch (_that) {
case _InvitedDiaryBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> memberNames,  bool alreadyJoined,  int memberLimit,  int? coverColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitedDiaryBook() when $default != null:
return $default(_that.id,_that.name,_that.memberNames,_that.alreadyJoined,_that.memberLimit,_that.coverColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> memberNames,  bool alreadyJoined,  int memberLimit,  int? coverColor)  $default,) {final _that = this;
switch (_that) {
case _InvitedDiaryBook():
return $default(_that.id,_that.name,_that.memberNames,_that.alreadyJoined,_that.memberLimit,_that.coverColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> memberNames,  bool alreadyJoined,  int memberLimit,  int? coverColor)?  $default,) {final _that = this;
switch (_that) {
case _InvitedDiaryBook() when $default != null:
return $default(_that.id,_that.name,_that.memberNames,_that.alreadyJoined,_that.memberLimit,_that.coverColor);case _:
  return null;

}
}

}

/// @nodoc


class _InvitedDiaryBook extends InvitedDiaryBook {
  const _InvitedDiaryBook({required this.id, required this.name, required  List<String> memberNames, required this.alreadyJoined, this.memberLimit = maxDiaryBookMembers, this.coverColor}): _memberNames = memberNames,super._();
  

@override final  String id;
@override final  String name;
 final  List<String> _memberNames;
@override List<String> get memberNames {
  if (_memberNames is EqualUnmodifiableListView) return _memberNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberNames);
}

/// 自分がもう参加しているか。
@override final  bool alreadyJoined;
/// 参加できる人数の上限。
@override@JsonKey() final  int memberLimit;
@override final  int? coverColor;

/// Create a copy of InvitedDiaryBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitedDiaryBookCopyWith<_InvitedDiaryBook> get copyWith => __$InvitedDiaryBookCopyWithImpl<_InvitedDiaryBook>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitedDiaryBook&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.memberNames, _memberNames)&&(identical(other.alreadyJoined, alreadyJoined) || other.alreadyJoined == alreadyJoined)&&(identical(other.memberLimit, memberLimit) || other.memberLimit == memberLimit)&&(identical(other.coverColor, coverColor) || other.coverColor == coverColor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_memberNames),alreadyJoined,memberLimit,coverColor);
}

@override
String toString() {
    return 'InvitedDiaryBook(id: $id, name: $name, memberNames: $memberNames, alreadyJoined: $alreadyJoined, memberLimit: $memberLimit, coverColor: $coverColor)';
}


}

/// @nodoc
abstract mixin class _$InvitedDiaryBookCopyWith<$Res> implements $InvitedDiaryBookCopyWith<$Res> {
  factory _$InvitedDiaryBookCopyWith(_InvitedDiaryBook value, $Res Function(_InvitedDiaryBook) _then) = __$InvitedDiaryBookCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> memberNames, bool alreadyJoined, int memberLimit, int? coverColor
});




}
/// @nodoc
class __$InvitedDiaryBookCopyWithImpl<$Res>
    implements _$InvitedDiaryBookCopyWith<$Res> {
  __$InvitedDiaryBookCopyWithImpl(this._self, this._then);

  final _InvitedDiaryBook _self;
  final $Res Function(_InvitedDiaryBook) _then;

/// Create a copy of InvitedDiaryBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? memberNames = null,Object? alreadyJoined = null,Object? memberLimit = null,Object? coverColor = freezed,}) {
  return _then(_InvitedDiaryBook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberNames: null == memberNames ? _self._memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,alreadyJoined: null == alreadyJoined ? _self.alreadyJoined : alreadyJoined // ignore: cast_nullable_to_non_nullable
as bool,memberLimit: null == memberLimit ? _self.memberLimit : memberLimit // ignore: cast_nullable_to_non_nullable
as int,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
