// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../invited_diary_book_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvitedDiaryBookResponse {

 String get id; String get name; int get memberLimit; List<String> get memberNames;/// [memberNames] と同じ順。
 List<int?> get memberAvatarColors; bool get alreadyJoined; int? get coverColor;
/// Create a copy of InvitedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitedDiaryBookResponseCopyWith<InvitedDiaryBookResponse> get copyWith => _$InvitedDiaryBookResponseCopyWithImpl<InvitedDiaryBookResponse>(this as InvitedDiaryBookResponse, _$identity);

  /// Serializes this InvitedDiaryBookResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InvitedDiaryBookResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitedDiaryBookResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.memberLimit, _this.memberLimit) || other.memberLimit == _this.memberLimit)&&const DeepCollectionEquality().equals(other.memberNames, _this.memberNames)&&const DeepCollectionEquality().equals(other.memberAvatarColors, _this.memberAvatarColors)&&(identical(other.alreadyJoined, _this.alreadyJoined) || other.alreadyJoined == _this.alreadyJoined)&&(identical(other.coverColor, _this.coverColor) || other.coverColor == _this.coverColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InvitedDiaryBookResponse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.memberLimit,const DeepCollectionEquality().hash(_this.memberNames),const DeepCollectionEquality().hash(_this.memberAvatarColors),_this.alreadyJoined,_this.coverColor);
}

@override
String toString() {
  final _this = this as InvitedDiaryBookResponse;
  return 'InvitedDiaryBookResponse(id: ${_this.id}, name: ${_this.name}, memberLimit: ${_this.memberLimit}, memberNames: ${_this.memberNames}, memberAvatarColors: ${_this.memberAvatarColors}, alreadyJoined: ${_this.alreadyJoined}, coverColor: ${_this.coverColor})';
}


}

/// @nodoc
abstract mixin class $InvitedDiaryBookResponseCopyWith<$Res>  {
  factory $InvitedDiaryBookResponseCopyWith(InvitedDiaryBookResponse value, $Res Function(InvitedDiaryBookResponse) _then) = _$InvitedDiaryBookResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, int memberLimit, List<String> memberNames, List<int?> memberAvatarColors, bool alreadyJoined, int? coverColor
});




}
/// @nodoc
class _$InvitedDiaryBookResponseCopyWithImpl<$Res>
    implements $InvitedDiaryBookResponseCopyWith<$Res> {
  _$InvitedDiaryBookResponseCopyWithImpl(this._self, this._then);

  final InvitedDiaryBookResponse _self;
  final $Res Function(InvitedDiaryBookResponse) _then;

/// Create a copy of InvitedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? memberLimit = null,Object? memberNames = null,Object? memberAvatarColors = null,Object? alreadyJoined = null,Object? coverColor = freezed,}) {
  return _then(InvitedDiaryBookResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberLimit: null == memberLimit ? _self.memberLimit : memberLimit // ignore: cast_nullable_to_non_nullable
as int,memberNames: null == memberNames ? _self.memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,memberAvatarColors: null == memberAvatarColors ? _self.memberAvatarColors : memberAvatarColors // ignore: cast_nullable_to_non_nullable
as List<int?>,alreadyJoined: null == alreadyJoined ? _self.alreadyJoined : alreadyJoined // ignore: cast_nullable_to_non_nullable
as bool,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitedDiaryBookResponse].
extension InvitedDiaryBookResponsePatterns on InvitedDiaryBookResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitedDiaryBookResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitedDiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitedDiaryBookResponse value)  $default,){
final _that = this;
switch (_that) {
case _InvitedDiaryBookResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitedDiaryBookResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InvitedDiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int memberLimit,  List<String> memberNames,  List<int?> memberAvatarColors,  bool alreadyJoined,  int? coverColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitedDiaryBookResponse() when $default != null:
return $default(_that.id,_that.name,_that.memberLimit,_that.memberNames,_that.memberAvatarColors,_that.alreadyJoined,_that.coverColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int memberLimit,  List<String> memberNames,  List<int?> memberAvatarColors,  bool alreadyJoined,  int? coverColor)  $default,) {final _that = this;
switch (_that) {
case _InvitedDiaryBookResponse():
return $default(_that.id,_that.name,_that.memberLimit,_that.memberNames,_that.memberAvatarColors,_that.alreadyJoined,_that.coverColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int memberLimit,  List<String> memberNames,  List<int?> memberAvatarColors,  bool alreadyJoined,  int? coverColor)?  $default,) {final _that = this;
switch (_that) {
case _InvitedDiaryBookResponse() when $default != null:
return $default(_that.id,_that.name,_that.memberLimit,_that.memberNames,_that.memberAvatarColors,_that.alreadyJoined,_that.coverColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitedDiaryBookResponse implements InvitedDiaryBookResponse {
  const _InvitedDiaryBookResponse({required this.id, required this.name, required this.memberLimit, required  List<String> memberNames,  List<int?> memberAvatarColors = const [], required this.alreadyJoined, this.coverColor}): _memberNames = memberNames,_memberAvatarColors = memberAvatarColors;
  factory _InvitedDiaryBookResponse.fromJson(Map<String, dynamic> json) => _$InvitedDiaryBookResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  int memberLimit;
 final  List<String> _memberNames;
@override List<String> get memberNames {
  if (_memberNames is EqualUnmodifiableListView) return _memberNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberNames);
}

/// [memberNames] と同じ順。
 final  List<int?> _memberAvatarColors;
/// [memberNames] と同じ順。
@override@JsonKey() List<int?> get memberAvatarColors {
  if (_memberAvatarColors is EqualUnmodifiableListView) return _memberAvatarColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberAvatarColors);
}

@override final  bool alreadyJoined;
@override final  int? coverColor;

/// Create a copy of InvitedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitedDiaryBookResponseCopyWith<_InvitedDiaryBookResponse> get copyWith => __$InvitedDiaryBookResponseCopyWithImpl<_InvitedDiaryBookResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitedDiaryBookResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitedDiaryBookResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.memberLimit, memberLimit) || other.memberLimit == memberLimit)&&const DeepCollectionEquality().equals(other.memberNames, _memberNames)&&const DeepCollectionEquality().equals(other.memberAvatarColors, _memberAvatarColors)&&(identical(other.alreadyJoined, alreadyJoined) || other.alreadyJoined == alreadyJoined)&&(identical(other.coverColor, coverColor) || other.coverColor == coverColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,memberLimit,const DeepCollectionEquality().hash(_memberNames),const DeepCollectionEquality().hash(_memberAvatarColors),alreadyJoined,coverColor);
}

@override
String toString() {
    return 'InvitedDiaryBookResponse(id: $id, name: $name, memberLimit: $memberLimit, memberNames: $memberNames, memberAvatarColors: $memberAvatarColors, alreadyJoined: $alreadyJoined, coverColor: $coverColor)';
}


}

/// @nodoc
abstract mixin class _$InvitedDiaryBookResponseCopyWith<$Res> implements $InvitedDiaryBookResponseCopyWith<$Res> {
  factory _$InvitedDiaryBookResponseCopyWith(_InvitedDiaryBookResponse value, $Res Function(_InvitedDiaryBookResponse) _then) = __$InvitedDiaryBookResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int memberLimit, List<String> memberNames, List<int?> memberAvatarColors, bool alreadyJoined, int? coverColor
});




}
/// @nodoc
class __$InvitedDiaryBookResponseCopyWithImpl<$Res>
    implements _$InvitedDiaryBookResponseCopyWith<$Res> {
  __$InvitedDiaryBookResponseCopyWithImpl(this._self, this._then);

  final _InvitedDiaryBookResponse _self;
  final $Res Function(_InvitedDiaryBookResponse) _then;

/// Create a copy of InvitedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? memberLimit = null,Object? memberNames = null,Object? memberAvatarColors = null,Object? alreadyJoined = null,Object? coverColor = freezed,}) {
  return _then(_InvitedDiaryBookResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberLimit: null == memberLimit ? _self.memberLimit : memberLimit // ignore: cast_nullable_to_non_nullable
as int,memberNames: null == memberNames ? _self._memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,memberAvatarColors: null == memberAvatarColors ? _self._memberAvatarColors : memberAvatarColors // ignore: cast_nullable_to_non_nullable
as List<int?>,alreadyJoined: null == alreadyJoined ? _self.alreadyJoined : alreadyJoined // ignore: cast_nullable_to_non_nullable
as bool,coverColor: freezed == coverColor ? _self.coverColor : coverColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
