// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../update_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateInfoResponse {

 String get latestVersion; String get requiredVersion; DateTime get enabledAt;/// 新しいバージョンで変わったこと。改行は `\n` で書く。なくてもよい。
 String? get releaseNotes;
/// Create a copy of UpdateInfoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInfoResponseCopyWith<UpdateInfoResponse> get copyWith => _$UpdateInfoResponseCopyWithImpl<UpdateInfoResponse>(this as UpdateInfoResponse, _$identity);

  /// Serializes this UpdateInfoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateInfoResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInfoResponse&&(identical(other.latestVersion, _this.latestVersion) || other.latestVersion == _this.latestVersion)&&(identical(other.requiredVersion, _this.requiredVersion) || other.requiredVersion == _this.requiredVersion)&&(identical(other.enabledAt, _this.enabledAt) || other.enabledAt == _this.enabledAt)&&(identical(other.releaseNotes, _this.releaseNotes) || other.releaseNotes == _this.releaseNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateInfoResponse;
  return Object.hash(runtimeType,_this.latestVersion,_this.requiredVersion,_this.enabledAt,_this.releaseNotes);
}

@override
String toString() {
  final _this = this as UpdateInfoResponse;
  return 'UpdateInfoResponse(latestVersion: ${_this.latestVersion}, requiredVersion: ${_this.requiredVersion}, enabledAt: ${_this.enabledAt}, releaseNotes: ${_this.releaseNotes})';
}


}

/// @nodoc
abstract mixin class $UpdateInfoResponseCopyWith<$Res>  {
  factory $UpdateInfoResponseCopyWith(UpdateInfoResponse value, $Res Function(UpdateInfoResponse) _then) = _$UpdateInfoResponseCopyWithImpl;
@useResult
$Res call({
 String latestVersion, String requiredVersion, DateTime enabledAt, String? releaseNotes
});




}
/// @nodoc
class _$UpdateInfoResponseCopyWithImpl<$Res>
    implements $UpdateInfoResponseCopyWith<$Res> {
  _$UpdateInfoResponseCopyWithImpl(this._self, this._then);

  final UpdateInfoResponse _self;
  final $Res Function(UpdateInfoResponse) _then;

/// Create a copy of UpdateInfoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestVersion = null,Object? requiredVersion = null,Object? enabledAt = null,Object? releaseNotes = freezed,}) {
  return _then(UpdateInfoResponse(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,requiredVersion: null == requiredVersion ? _self.requiredVersion : requiredVersion // ignore: cast_nullable_to_non_nullable
as String,enabledAt: null == enabledAt ? _self.enabledAt : enabledAt // ignore: cast_nullable_to_non_nullable
as DateTime,releaseNotes: freezed == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateInfoResponse].
extension UpdateInfoResponsePatterns on UpdateInfoResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateInfoResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateInfoResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateInfoResponse value)  $default,){
final _that = this;
switch (_that) {
case _UpdateInfoResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateInfoResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateInfoResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String latestVersion,  String requiredVersion,  DateTime enabledAt,  String? releaseNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateInfoResponse() when $default != null:
return $default(_that.latestVersion,_that.requiredVersion,_that.enabledAt,_that.releaseNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String latestVersion,  String requiredVersion,  DateTime enabledAt,  String? releaseNotes)  $default,) {final _that = this;
switch (_that) {
case _UpdateInfoResponse():
return $default(_that.latestVersion,_that.requiredVersion,_that.enabledAt,_that.releaseNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String latestVersion,  String requiredVersion,  DateTime enabledAt,  String? releaseNotes)?  $default,) {final _that = this;
switch (_that) {
case _UpdateInfoResponse() when $default != null:
return $default(_that.latestVersion,_that.requiredVersion,_that.enabledAt,_that.releaseNotes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.none)
class _UpdateInfoResponse implements UpdateInfoResponse {
  const _UpdateInfoResponse({required this.latestVersion, required this.requiredVersion, required this.enabledAt, this.releaseNotes});
  factory _UpdateInfoResponse.fromJson(Map<String, dynamic> json) => _$UpdateInfoResponseFromJson(json);

@override final  String latestVersion;
@override final  String requiredVersion;
@override final  DateTime enabledAt;
/// 新しいバージョンで変わったこと。改行は `\n` で書く。なくてもよい。
@override final  String? releaseNotes;

/// Create a copy of UpdateInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateInfoResponseCopyWith<_UpdateInfoResponse> get copyWith => __$UpdateInfoResponseCopyWithImpl<_UpdateInfoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateInfoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInfoResponse&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.requiredVersion, requiredVersion) || other.requiredVersion == requiredVersion)&&(identical(other.enabledAt, enabledAt) || other.enabledAt == enabledAt)&&(identical(other.releaseNotes, releaseNotes) || other.releaseNotes == releaseNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,latestVersion,requiredVersion,enabledAt,releaseNotes);
}

@override
String toString() {
    return 'UpdateInfoResponse(latestVersion: $latestVersion, requiredVersion: $requiredVersion, enabledAt: $enabledAt, releaseNotes: $releaseNotes)';
}


}

/// @nodoc
abstract mixin class _$UpdateInfoResponseCopyWith<$Res> implements $UpdateInfoResponseCopyWith<$Res> {
  factory _$UpdateInfoResponseCopyWith(_UpdateInfoResponse value, $Res Function(_UpdateInfoResponse) _then) = __$UpdateInfoResponseCopyWithImpl;
@override @useResult
$Res call({
 String latestVersion, String requiredVersion, DateTime enabledAt, String? releaseNotes
});




}
/// @nodoc
class __$UpdateInfoResponseCopyWithImpl<$Res>
    implements _$UpdateInfoResponseCopyWith<$Res> {
  __$UpdateInfoResponseCopyWithImpl(this._self, this._then);

  final _UpdateInfoResponse _self;
  final $Res Function(_UpdateInfoResponse) _then;

/// Create a copy of UpdateInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestVersion = null,Object? requiredVersion = null,Object? enabledAt = null,Object? releaseNotes = freezed,}) {
  return _then(_UpdateInfoResponse(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,requiredVersion: null == requiredVersion ? _self.requiredVersion : requiredVersion // ignore: cast_nullable_to_non_nullable
as String,enabledAt: null == enabledAt ? _self.enabledAt : enabledAt // ignore: cast_nullable_to_non_nullable
as DateTime,releaseNotes: freezed == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
