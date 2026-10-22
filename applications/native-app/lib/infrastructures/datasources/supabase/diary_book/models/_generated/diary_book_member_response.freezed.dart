// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_book_member_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryBookMemberResponse {

 String get userId;@JsonKey(name: 'profiles') DiaryBookMemberProfileResponse get profile;
/// Create a copy of DiaryBookMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookMemberResponseCopyWith<DiaryBookMemberResponse> get copyWith => _$DiaryBookMemberResponseCopyWithImpl<DiaryBookMemberResponse>(this as DiaryBookMemberResponse, _$identity);

  /// Serializes this DiaryBookMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryBookMemberResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBookMemberResponse&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.profile, _this.profile) || other.profile == _this.profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryBookMemberResponse;
  return Object.hash(runtimeType,_this.userId,_this.profile);
}

@override
String toString() {
  final _this = this as DiaryBookMemberResponse;
  return 'DiaryBookMemberResponse(userId: ${_this.userId}, profile: ${_this.profile})';
}


}

/// @nodoc
abstract mixin class $DiaryBookMemberResponseCopyWith<$Res>  {
  factory $DiaryBookMemberResponseCopyWith(DiaryBookMemberResponse value, $Res Function(DiaryBookMemberResponse) _then) = _$DiaryBookMemberResponseCopyWithImpl;
@useResult
$Res call({
 String userId,@JsonKey(name: 'profiles') DiaryBookMemberProfileResponse profile
});


$DiaryBookMemberProfileResponseCopyWith<$Res> get profile;

}
/// @nodoc
class _$DiaryBookMemberResponseCopyWithImpl<$Res>
    implements $DiaryBookMemberResponseCopyWith<$Res> {
  _$DiaryBookMemberResponseCopyWithImpl(this._self, this._then);

  final DiaryBookMemberResponse _self;
  final $Res Function(DiaryBookMemberResponse) _then;

/// Create a copy of DiaryBookMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? profile = null,}) {
  return _then(DiaryBookMemberResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DiaryBookMemberProfileResponse,
  ));
}
/// Create a copy of DiaryBookMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryBookMemberProfileResponseCopyWith<$Res> get profile {
  
  return $DiaryBookMemberProfileResponseCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiaryBookMemberResponse].
extension DiaryBookMemberResponsePatterns on DiaryBookMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBookMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBookMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBookMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBookMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBookMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBookMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId, @JsonKey(name: 'profiles')  DiaryBookMemberProfileResponse profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBookMemberResponse() when $default != null:
return $default(_that.userId,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId, @JsonKey(name: 'profiles')  DiaryBookMemberProfileResponse profile)  $default,) {final _that = this;
switch (_that) {
case _DiaryBookMemberResponse():
return $default(_that.userId,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId, @JsonKey(name: 'profiles')  DiaryBookMemberProfileResponse profile)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBookMemberResponse() when $default != null:
return $default(_that.userId,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryBookMemberResponse implements DiaryBookMemberResponse {
  const _DiaryBookMemberResponse({required this.userId, @JsonKey(name: 'profiles') required this.profile});
  factory _DiaryBookMemberResponse.fromJson(Map<String, dynamic> json) => _$DiaryBookMemberResponseFromJson(json);

@override final  String userId;
@override@JsonKey(name: 'profiles') final  DiaryBookMemberProfileResponse profile;

/// Create a copy of DiaryBookMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookMemberResponseCopyWith<_DiaryBookMemberResponse> get copyWith => __$DiaryBookMemberResponseCopyWithImpl<_DiaryBookMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryBookMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBookMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,profile);
}

@override
String toString() {
    return 'DiaryBookMemberResponse(userId: $userId, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookMemberResponseCopyWith<$Res> implements $DiaryBookMemberResponseCopyWith<$Res> {
  factory _$DiaryBookMemberResponseCopyWith(_DiaryBookMemberResponse value, $Res Function(_DiaryBookMemberResponse) _then) = __$DiaryBookMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId,@JsonKey(name: 'profiles') DiaryBookMemberProfileResponse profile
});


@override $DiaryBookMemberProfileResponseCopyWith<$Res> get profile;

}
/// @nodoc
class __$DiaryBookMemberResponseCopyWithImpl<$Res>
    implements _$DiaryBookMemberResponseCopyWith<$Res> {
  __$DiaryBookMemberResponseCopyWithImpl(this._self, this._then);

  final _DiaryBookMemberResponse _self;
  final $Res Function(_DiaryBookMemberResponse) _then;

/// Create a copy of DiaryBookMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? profile = null,}) {
  return _then(_DiaryBookMemberResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DiaryBookMemberProfileResponse,
  ));
}

/// Create a copy of DiaryBookMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryBookMemberProfileResponseCopyWith<$Res> get profile {
  
  return $DiaryBookMemberProfileResponseCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$DiaryBookMemberProfileResponse {

 String get displayName; int? get avatarColor;
/// Create a copy of DiaryBookMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookMemberProfileResponseCopyWith<DiaryBookMemberProfileResponse> get copyWith => _$DiaryBookMemberProfileResponseCopyWithImpl<DiaryBookMemberProfileResponse>(this as DiaryBookMemberProfileResponse, _$identity);

  /// Serializes this DiaryBookMemberProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryBookMemberProfileResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBookMemberProfileResponse&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarColor, _this.avatarColor) || other.avatarColor == _this.avatarColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryBookMemberProfileResponse;
  return Object.hash(runtimeType,_this.displayName,_this.avatarColor);
}

@override
String toString() {
  final _this = this as DiaryBookMemberProfileResponse;
  return 'DiaryBookMemberProfileResponse(displayName: ${_this.displayName}, avatarColor: ${_this.avatarColor})';
}


}

/// @nodoc
abstract mixin class $DiaryBookMemberProfileResponseCopyWith<$Res>  {
  factory $DiaryBookMemberProfileResponseCopyWith(DiaryBookMemberProfileResponse value, $Res Function(DiaryBookMemberProfileResponse) _then) = _$DiaryBookMemberProfileResponseCopyWithImpl;
@useResult
$Res call({
 String displayName, int? avatarColor
});




}
/// @nodoc
class _$DiaryBookMemberProfileResponseCopyWithImpl<$Res>
    implements $DiaryBookMemberProfileResponseCopyWith<$Res> {
  _$DiaryBookMemberProfileResponseCopyWithImpl(this._self, this._then);

  final DiaryBookMemberProfileResponse _self;
  final $Res Function(DiaryBookMemberProfileResponse) _then;

/// Create a copy of DiaryBookMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? avatarColor = freezed,}) {
  return _then(DiaryBookMemberProfileResponse(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: freezed == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryBookMemberProfileResponse].
extension DiaryBookMemberProfileResponsePatterns on DiaryBookMemberProfileResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBookMemberProfileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBookMemberProfileResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBookMemberProfileResponse value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBookMemberProfileResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBookMemberProfileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBookMemberProfileResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  int? avatarColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBookMemberProfileResponse() when $default != null:
return $default(_that.displayName,_that.avatarColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  int? avatarColor)  $default,) {final _that = this;
switch (_that) {
case _DiaryBookMemberProfileResponse():
return $default(_that.displayName,_that.avatarColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  int? avatarColor)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBookMemberProfileResponse() when $default != null:
return $default(_that.displayName,_that.avatarColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryBookMemberProfileResponse implements DiaryBookMemberProfileResponse {
  const _DiaryBookMemberProfileResponse({required this.displayName, this.avatarColor});
  factory _DiaryBookMemberProfileResponse.fromJson(Map<String, dynamic> json) => _$DiaryBookMemberProfileResponseFromJson(json);

@override final  String displayName;
@override final  int? avatarColor;

/// Create a copy of DiaryBookMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookMemberProfileResponseCopyWith<_DiaryBookMemberProfileResponse> get copyWith => __$DiaryBookMemberProfileResponseCopyWithImpl<_DiaryBookMemberProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryBookMemberProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBookMemberProfileResponse&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName,avatarColor);
}

@override
String toString() {
    return 'DiaryBookMemberProfileResponse(displayName: $displayName, avatarColor: $avatarColor)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookMemberProfileResponseCopyWith<$Res> implements $DiaryBookMemberProfileResponseCopyWith<$Res> {
  factory _$DiaryBookMemberProfileResponseCopyWith(_DiaryBookMemberProfileResponse value, $Res Function(_DiaryBookMemberProfileResponse) _then) = __$DiaryBookMemberProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 String displayName, int? avatarColor
});




}
/// @nodoc
class __$DiaryBookMemberProfileResponseCopyWithImpl<$Res>
    implements _$DiaryBookMemberProfileResponseCopyWith<$Res> {
  __$DiaryBookMemberProfileResponseCopyWithImpl(this._self, this._then);

  final _DiaryBookMemberProfileResponse _self;
  final $Res Function(_DiaryBookMemberProfileResponse) _then;

/// Create a copy of DiaryBookMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? avatarColor = freezed,}) {
  return _then(_DiaryBookMemberProfileResponse(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: freezed == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
