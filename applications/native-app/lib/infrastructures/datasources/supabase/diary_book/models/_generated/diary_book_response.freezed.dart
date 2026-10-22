// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_book_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryBookResponse {

 String get id; String get name; String get inviteCode; int get memberLimit; String? get createdBy; int? get coverColor;
/// Create a copy of DiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookResponseCopyWith<DiaryBookResponse> get copyWith => _$DiaryBookResponseCopyWithImpl<DiaryBookResponse>(this as DiaryBookResponse, _$identity);

  /// Serializes this DiaryBookResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryBookResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBookResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.inviteCode, _this.inviteCode) || other.inviteCode == _this.inviteCode)&&(identical(other.memberLimit, _this.memberLimit) || other.memberLimit == _this.memberLimit)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.coverColor, _this.coverColor) || other.coverColor == _this.coverColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryBookResponse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.inviteCode,_this.memberLimit,_this.createdBy,_this.coverColor);
}

@override
String toString() {
  final _this = this as DiaryBookResponse;
  return 'DiaryBookResponse(id: ${_this.id}, name: ${_this.name}, inviteCode: ${_this.inviteCode}, memberLimit: ${_this.memberLimit}, createdBy: ${_this.createdBy}, coverColor: ${_this.coverColor})';
}


}

/// @nodoc
abstract mixin class $DiaryBookResponseCopyWith<$Res>  {
  factory $DiaryBookResponseCopyWith(DiaryBookResponse value, $Res Function(DiaryBookResponse) _then) = _$DiaryBookResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String inviteCode, int memberLimit, String? createdBy, int? coverColor
});




}
/// @nodoc
class _$DiaryBookResponseCopyWithImpl<$Res>
    implements $DiaryBookResponseCopyWith<$Res> {
  _$DiaryBookResponseCopyWithImpl(this._self, this._then);

  final DiaryBookResponse _self;
  final $Res Function(DiaryBookResponse) _then;

/// Create a copy of DiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? inviteCode = null,Object? memberLimit = null,Object? createdBy = freezed,Object? coverColor = freezed,}) {
  return _then(DiaryBookResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,memberLimit: null == memberLimit ? _self.memberLimit : memberLimit // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryBookResponse].
extension DiaryBookResponsePatterns on DiaryBookResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBookResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBookResponse value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBookResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBookResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String inviteCode,  int memberLimit,  String? createdBy,  int? coverColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBookResponse() when $default != null:
return $default(_that.id,_that.name,_that.inviteCode,_that.memberLimit,_that.createdBy,_that.coverColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String inviteCode,  int memberLimit,  String? createdBy,  int? coverColor)  $default,) {final _that = this;
switch (_that) {
case _DiaryBookResponse():
return $default(_that.id,_that.name,_that.inviteCode,_that.memberLimit,_that.createdBy,_that.coverColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String inviteCode,  int memberLimit,  String? createdBy,  int? coverColor)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBookResponse() when $default != null:
return $default(_that.id,_that.name,_that.inviteCode,_that.memberLimit,_that.createdBy,_that.coverColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryBookResponse implements DiaryBookResponse {
  const _DiaryBookResponse({required this.id, required this.name, required this.inviteCode, required this.memberLimit, this.createdBy, this.coverColor});
  factory _DiaryBookResponse.fromJson(Map<String, dynamic> json) => _$DiaryBookResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String inviteCode;
@override final  int memberLimit;
@override final  String? createdBy;
@override final  int? coverColor;

/// Create a copy of DiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookResponseCopyWith<_DiaryBookResponse> get copyWith => __$DiaryBookResponseCopyWithImpl<_DiaryBookResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryBookResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBookResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.memberLimit, memberLimit) || other.memberLimit == memberLimit)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.coverColor, coverColor) || other.coverColor == coverColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,inviteCode,memberLimit,createdBy,coverColor);
}

@override
String toString() {
    return 'DiaryBookResponse(id: $id, name: $name, inviteCode: $inviteCode, memberLimit: $memberLimit, createdBy: $createdBy, coverColor: $coverColor)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookResponseCopyWith<$Res> implements $DiaryBookResponseCopyWith<$Res> {
  factory _$DiaryBookResponseCopyWith(_DiaryBookResponse value, $Res Function(_DiaryBookResponse) _then) = __$DiaryBookResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String inviteCode, int memberLimit, String? createdBy, int? coverColor
});




}
/// @nodoc
class __$DiaryBookResponseCopyWithImpl<$Res>
    implements _$DiaryBookResponseCopyWith<$Res> {
  __$DiaryBookResponseCopyWithImpl(this._self, this._then);

  final _DiaryBookResponse _self;
  final $Res Function(_DiaryBookResponse) _then;

/// Create a copy of DiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? inviteCode = null,Object? memberLimit = null,Object? createdBy = freezed,Object? coverColor = freezed,}) {
  return _then(_DiaryBookResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,memberLimit: null == memberLimit ? _self.memberLimit : memberLimit // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
