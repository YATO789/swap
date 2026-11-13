// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../app_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppUpdate {

 AppUpdateLevel get level;/// ストアに出ている新しいバージョン。促さないときは null。
 AppVersion? get latestVersion;/// 新しいバージョンで変わったこと。1行に1つずつ。Remote Config に書いていなければ空。
 List<String> get releaseNotes;
/// Create a copy of AppUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateCopyWith<AppUpdate> get copyWith => _$AppUpdateCopyWithImpl<AppUpdate>(this as AppUpdate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdate&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.latestVersion, _this.latestVersion) || other.latestVersion == _this.latestVersion)&&const DeepCollectionEquality().equals(other.releaseNotes, _this.releaseNotes));
}


@override
int get hashCode {
  final _this = this as AppUpdate;
  return Object.hash(runtimeType,_this.level,_this.latestVersion,const DeepCollectionEquality().hash(_this.releaseNotes));
}

@override
String toString() {
  final _this = this as AppUpdate;
  return 'AppUpdate(level: ${_this.level}, latestVersion: ${_this.latestVersion}, releaseNotes: ${_this.releaseNotes})';
}


}

/// @nodoc
abstract mixin class $AppUpdateCopyWith<$Res>  {
  factory $AppUpdateCopyWith(AppUpdate value, $Res Function(AppUpdate) _then) = _$AppUpdateCopyWithImpl;
@useResult
$Res call({
 AppUpdateLevel level, AppVersion? latestVersion, List<String> releaseNotes
});


$AppVersionCopyWith<$Res>? get latestVersion;

}
/// @nodoc
class _$AppUpdateCopyWithImpl<$Res>
    implements $AppUpdateCopyWith<$Res> {
  _$AppUpdateCopyWithImpl(this._self, this._then);

  final AppUpdate _self;
  final $Res Function(AppUpdate) _then;

/// Create a copy of AppUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? latestVersion = freezed,Object? releaseNotes = null,}) {
  return _then(AppUpdate(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as AppUpdateLevel,latestVersion: freezed == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as AppVersion?,releaseNotes: null == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of AppUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res>? get latestVersion {
    if (_self.latestVersion == null) {
    return null;
  }

  return $AppVersionCopyWith<$Res>(_self.latestVersion!, (value) {
    return _then(_self.copyWith(latestVersion: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUpdate].
extension AppUpdatePatterns on AppUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdate value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppUpdateLevel level,  AppVersion? latestVersion,  List<String> releaseNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdate() when $default != null:
return $default(_that.level,_that.latestVersion,_that.releaseNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppUpdateLevel level,  AppVersion? latestVersion,  List<String> releaseNotes)  $default,) {final _that = this;
switch (_that) {
case _AppUpdate():
return $default(_that.level,_that.latestVersion,_that.releaseNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppUpdateLevel level,  AppVersion? latestVersion,  List<String> releaseNotes)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdate() when $default != null:
return $default(_that.level,_that.latestVersion,_that.releaseNotes);case _:
  return null;

}
}

}

/// @nodoc


class _AppUpdate implements AppUpdate {
  const _AppUpdate({required this.level, this.latestVersion,  List<String> releaseNotes = const []}): _releaseNotes = releaseNotes;
  

@override final  AppUpdateLevel level;
/// ストアに出ている新しいバージョン。促さないときは null。
@override final  AppVersion? latestVersion;
/// 新しいバージョンで変わったこと。1行に1つずつ。Remote Config に書いていなければ空。
 final  List<String> _releaseNotes;
/// 新しいバージョンで変わったこと。1行に1つずつ。Remote Config に書いていなければ空。
@override@JsonKey() List<String> get releaseNotes {
  if (_releaseNotes is EqualUnmodifiableListView) return _releaseNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_releaseNotes);
}


/// Create a copy of AppUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateCopyWith<_AppUpdate> get copyWith => __$AppUpdateCopyWithImpl<_AppUpdate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdate&&(identical(other.level, level) || other.level == level)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&const DeepCollectionEquality().equals(other.releaseNotes, _releaseNotes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,level,latestVersion,const DeepCollectionEquality().hash(_releaseNotes));
}

@override
String toString() {
    return 'AppUpdate(level: $level, latestVersion: $latestVersion, releaseNotes: $releaseNotes)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateCopyWith<$Res> implements $AppUpdateCopyWith<$Res> {
  factory _$AppUpdateCopyWith(_AppUpdate value, $Res Function(_AppUpdate) _then) = __$AppUpdateCopyWithImpl;
@override @useResult
$Res call({
 AppUpdateLevel level, AppVersion? latestVersion, List<String> releaseNotes
});


@override $AppVersionCopyWith<$Res>? get latestVersion;

}
/// @nodoc
class __$AppUpdateCopyWithImpl<$Res>
    implements _$AppUpdateCopyWith<$Res> {
  __$AppUpdateCopyWithImpl(this._self, this._then);

  final _AppUpdate _self;
  final $Res Function(_AppUpdate) _then;

/// Create a copy of AppUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? latestVersion = freezed,Object? releaseNotes = null,}) {
  return _then(_AppUpdate(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as AppUpdateLevel,latestVersion: freezed == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as AppVersion?,releaseNotes: null == releaseNotes ? _self._releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of AppUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res>? get latestVersion {
    if (_self.latestVersion == null) {
    return null;
  }

  return $AppVersionCopyWith<$Res>(_self.latestVersion!, (value) {
    return _then(_self.copyWith(latestVersion: value));
  });
}
}

/// @nodoc
mixin _$UpdateInfo {

/// これより古ければ、アップデートを促す。
 AppVersion get latestVersion;/// これより古ければ、アップデートするまで使えなくする。
 AppVersion get requiredVersion;/// この日時から案内を出す。ストアの審査が通るのを待ってから出すために使う。
 DateTime get enabledAt;
/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInfoCopyWith<UpdateInfo> get copyWith => _$UpdateInfoCopyWithImpl<UpdateInfo>(this as UpdateInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UpdateInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInfo&&(identical(other.latestVersion, _this.latestVersion) || other.latestVersion == _this.latestVersion)&&(identical(other.requiredVersion, _this.requiredVersion) || other.requiredVersion == _this.requiredVersion)&&(identical(other.enabledAt, _this.enabledAt) || other.enabledAt == _this.enabledAt));
}


@override
int get hashCode {
  final _this = this as UpdateInfo;
  return Object.hash(runtimeType,_this.latestVersion,_this.requiredVersion,_this.enabledAt);
}

@override
String toString() {
  final _this = this as UpdateInfo;
  return 'UpdateInfo(latestVersion: ${_this.latestVersion}, requiredVersion: ${_this.requiredVersion}, enabledAt: ${_this.enabledAt})';
}


}

/// @nodoc
abstract mixin class $UpdateInfoCopyWith<$Res>  {
  factory $UpdateInfoCopyWith(UpdateInfo value, $Res Function(UpdateInfo) _then) = _$UpdateInfoCopyWithImpl;
@useResult
$Res call({
 AppVersion latestVersion, AppVersion requiredVersion, DateTime enabledAt
});


$AppVersionCopyWith<$Res> get latestVersion;$AppVersionCopyWith<$Res> get requiredVersion;

}
/// @nodoc
class _$UpdateInfoCopyWithImpl<$Res>
    implements $UpdateInfoCopyWith<$Res> {
  _$UpdateInfoCopyWithImpl(this._self, this._then);

  final UpdateInfo _self;
  final $Res Function(UpdateInfo) _then;

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestVersion = null,Object? requiredVersion = null,Object? enabledAt = null,}) {
  return _then(UpdateInfo(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,requiredVersion: null == requiredVersion ? _self.requiredVersion : requiredVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,enabledAt: null == enabledAt ? _self.enabledAt : enabledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res> get latestVersion {
  
  return $AppVersionCopyWith<$Res>(_self.latestVersion, (value) {
    return _then(_self.copyWith(latestVersion: value));
  });
}/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res> get requiredVersion {
  
  return $AppVersionCopyWith<$Res>(_self.requiredVersion, (value) {
    return _then(_self.copyWith(requiredVersion: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateInfo].
extension UpdateInfoPatterns on UpdateInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateInfo value)  $default,){
final _that = this;
switch (_that) {
case _UpdateInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateInfo value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppVersion latestVersion,  AppVersion requiredVersion,  DateTime enabledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
return $default(_that.latestVersion,_that.requiredVersion,_that.enabledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppVersion latestVersion,  AppVersion requiredVersion,  DateTime enabledAt)  $default,) {final _that = this;
switch (_that) {
case _UpdateInfo():
return $default(_that.latestVersion,_that.requiredVersion,_that.enabledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppVersion latestVersion,  AppVersion requiredVersion,  DateTime enabledAt)?  $default,) {final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
return $default(_that.latestVersion,_that.requiredVersion,_that.enabledAt);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateInfo extends UpdateInfo {
  const _UpdateInfo({required this.latestVersion, required this.requiredVersion, required this.enabledAt}): super._();
  

/// これより古ければ、アップデートを促す。
@override final  AppVersion latestVersion;
/// これより古ければ、アップデートするまで使えなくする。
@override final  AppVersion requiredVersion;
/// この日時から案内を出す。ストアの審査が通るのを待ってから出すために使う。
@override final  DateTime enabledAt;

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateInfoCopyWith<_UpdateInfo> get copyWith => __$UpdateInfoCopyWithImpl<_UpdateInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInfo&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.requiredVersion, requiredVersion) || other.requiredVersion == requiredVersion)&&(identical(other.enabledAt, enabledAt) || other.enabledAt == enabledAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,latestVersion,requiredVersion,enabledAt);
}

@override
String toString() {
    return 'UpdateInfo(latestVersion: $latestVersion, requiredVersion: $requiredVersion, enabledAt: $enabledAt)';
}


}

/// @nodoc
abstract mixin class _$UpdateInfoCopyWith<$Res> implements $UpdateInfoCopyWith<$Res> {
  factory _$UpdateInfoCopyWith(_UpdateInfo value, $Res Function(_UpdateInfo) _then) = __$UpdateInfoCopyWithImpl;
@override @useResult
$Res call({
 AppVersion latestVersion, AppVersion requiredVersion, DateTime enabledAt
});


@override $AppVersionCopyWith<$Res> get latestVersion;@override $AppVersionCopyWith<$Res> get requiredVersion;

}
/// @nodoc
class __$UpdateInfoCopyWithImpl<$Res>
    implements _$UpdateInfoCopyWith<$Res> {
  __$UpdateInfoCopyWithImpl(this._self, this._then);

  final _UpdateInfo _self;
  final $Res Function(_UpdateInfo) _then;

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestVersion = null,Object? requiredVersion = null,Object? enabledAt = null,}) {
  return _then(_UpdateInfo(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,requiredVersion: null == requiredVersion ? _self.requiredVersion : requiredVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,enabledAt: null == enabledAt ? _self.enabledAt : enabledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res> get latestVersion {
  
  return $AppVersionCopyWith<$Res>(_self.latestVersion, (value) {
    return _then(_self.copyWith(latestVersion: value));
  });
}/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res> get requiredVersion {
  
  return $AppVersionCopyWith<$Res>(_self.requiredVersion, (value) {
    return _then(_self.copyWith(requiredVersion: value));
  });
}
}

/// @nodoc
mixin _$AppVersion {

 List<int> get parts;
/// Create a copy of AppVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppVersionCopyWith<AppVersion> get copyWith => _$AppVersionCopyWithImpl<AppVersion>(this as AppVersion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppVersion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppVersion&&const DeepCollectionEquality().equals(other.parts, _this.parts));
}


@override
int get hashCode {
  final _this = this as AppVersion;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.parts));
}



}

/// @nodoc
abstract mixin class $AppVersionCopyWith<$Res>  {
  factory $AppVersionCopyWith(AppVersion value, $Res Function(AppVersion) _then) = _$AppVersionCopyWithImpl;
@useResult
$Res call({
 List<int> parts
});




}
/// @nodoc
class _$AppVersionCopyWithImpl<$Res>
    implements $AppVersionCopyWith<$Res> {
  _$AppVersionCopyWithImpl(this._self, this._then);

  final AppVersion _self;
  final $Res Function(AppVersion) _then;

/// Create a copy of AppVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parts = null,}) {
  return _then(AppVersion(
null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppVersion].
extension AppVersionPatterns on AppVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppVersion value)  $default,){
final _that = this;
switch (_that) {
case _AppVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppVersion value)?  $default,){
final _that = this;
switch (_that) {
case _AppVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> parts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppVersion() when $default != null:
return $default(_that.parts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> parts)  $default,) {final _that = this;
switch (_that) {
case _AppVersion():
return $default(_that.parts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> parts)?  $default,) {final _that = this;
switch (_that) {
case _AppVersion() when $default != null:
return $default(_that.parts);case _:
  return null;

}
}

}

/// @nodoc


class _AppVersion extends AppVersion {
  const _AppVersion( List<int> parts): _parts = parts,super._();
  

 final  List<int> _parts;
@override List<int> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}


/// Create a copy of AppVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppVersionCopyWith<_AppVersion> get copyWith => __$AppVersionCopyWithImpl<_AppVersion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppVersion&&const DeepCollectionEquality().equals(other.parts, _parts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_parts));
}



}

/// @nodoc
abstract mixin class _$AppVersionCopyWith<$Res> implements $AppVersionCopyWith<$Res> {
  factory _$AppVersionCopyWith(_AppVersion value, $Res Function(_AppVersion) _then) = __$AppVersionCopyWithImpl;
@override @useResult
$Res call({
 List<int> parts
});




}
/// @nodoc
class __$AppVersionCopyWithImpl<$Res>
    implements _$AppVersionCopyWith<$Res> {
  __$AppVersionCopyWithImpl(this._self, this._then);

  final _AppVersion _self;
  final $Res Function(_AppVersion) _then;

/// Create a copy of AppVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parts = null,}) {
  return _then(_AppVersion(
null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
