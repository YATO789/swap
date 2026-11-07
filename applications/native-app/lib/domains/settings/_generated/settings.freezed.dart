// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Settings {

/// ホームの日記帳を1冊ずつ画面いっぱいに出し、縦にスワイプして切り替えるか。
/// false なら表紙を横2列のグリッドで並べる。
 bool get diaryBookPaged;/// ホームの書き込みバーに手書きの説明を出すか。
 bool get postHintVisible;/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。
 ThemeMode get themeMode;/// 毎日決まった時刻に、日記を書くよう知らせるか。
 bool get diaryReminderEnabled;/// 日記のリマインダーを出す時刻。
 TimeOfDay get diaryReminderTime;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Settings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.diaryBookPaged, _this.diaryBookPaged) || other.diaryBookPaged == _this.diaryBookPaged)&&(identical(other.postHintVisible, _this.postHintVisible) || other.postHintVisible == _this.postHintVisible)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.diaryReminderEnabled, _this.diaryReminderEnabled) || other.diaryReminderEnabled == _this.diaryReminderEnabled)&&(identical(other.diaryReminderTime, _this.diaryReminderTime) || other.diaryReminderTime == _this.diaryReminderTime));
}


@override
int get hashCode {
  final _this = this as Settings;
  return Object.hash(runtimeType,_this.diaryBookPaged,_this.postHintVisible,_this.themeMode,_this.diaryReminderEnabled,_this.diaryReminderTime);
}

@override
String toString() {
  final _this = this as Settings;
  return 'Settings(diaryBookPaged: ${_this.diaryBookPaged}, postHintVisible: ${_this.postHintVisible}, themeMode: ${_this.themeMode}, diaryReminderEnabled: ${_this.diaryReminderEnabled}, diaryReminderTime: ${_this.diaryReminderTime})';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 bool diaryBookPaged, bool postHintVisible, ThemeMode themeMode, bool diaryReminderEnabled, TimeOfDay diaryReminderTime
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diaryBookPaged = null,Object? postHintVisible = null,Object? themeMode = null,Object? diaryReminderEnabled = null,Object? diaryReminderTime = null,}) {
  return _then(Settings(
diaryBookPaged: null == diaryBookPaged ? _self.diaryBookPaged : diaryBookPaged // ignore: cast_nullable_to_non_nullable
as bool,postHintVisible: null == postHintVisible ? _self.postHintVisible : postHintVisible // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,diaryReminderEnabled: null == diaryReminderEnabled ? _self.diaryReminderEnabled : diaryReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,diaryReminderTime: null == diaryReminderTime ? _self.diaryReminderTime : diaryReminderTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}

}


/// Adds pattern-matching-related methods to [Settings].
extension SettingsPatterns on Settings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settings value)  $default,){
final _that = this;
switch (_that) {
case _Settings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settings value)?  $default,){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool diaryBookPaged,  bool postHintVisible,  ThemeMode themeMode,  bool diaryReminderEnabled,  TimeOfDay diaryReminderTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.diaryBookPaged,_that.postHintVisible,_that.themeMode,_that.diaryReminderEnabled,_that.diaryReminderTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool diaryBookPaged,  bool postHintVisible,  ThemeMode themeMode,  bool diaryReminderEnabled,  TimeOfDay diaryReminderTime)  $default,) {final _that = this;
switch (_that) {
case _Settings():
return $default(_that.diaryBookPaged,_that.postHintVisible,_that.themeMode,_that.diaryReminderEnabled,_that.diaryReminderTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool diaryBookPaged,  bool postHintVisible,  ThemeMode themeMode,  bool diaryReminderEnabled,  TimeOfDay diaryReminderTime)?  $default,) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.diaryBookPaged,_that.postHintVisible,_that.themeMode,_that.diaryReminderEnabled,_that.diaryReminderTime);case _:
  return null;

}
}

}

/// @nodoc


class _Settings implements Settings {
  const _Settings({required this.diaryBookPaged, required this.postHintVisible, required this.themeMode, required this.diaryReminderEnabled, required this.diaryReminderTime});
  

/// ホームの日記帳を1冊ずつ画面いっぱいに出し、縦にスワイプして切り替えるか。
/// false なら表紙を横2列のグリッドで並べる。
@override final  bool diaryBookPaged;
/// ホームの書き込みバーに手書きの説明を出すか。
@override final  bool postHintVisible;
/// ライト・ダーク・端末の設定に合わせる、のどれで表示するか。
@override final  ThemeMode themeMode;
/// 毎日決まった時刻に、日記を書くよう知らせるか。
@override final  bool diaryReminderEnabled;
/// 日記のリマインダーを出す時刻。
@override final  TimeOfDay diaryReminderTime;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.diaryBookPaged, diaryBookPaged) || other.diaryBookPaged == diaryBookPaged)&&(identical(other.postHintVisible, postHintVisible) || other.postHintVisible == postHintVisible)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.diaryReminderEnabled, diaryReminderEnabled) || other.diaryReminderEnabled == diaryReminderEnabled)&&(identical(other.diaryReminderTime, diaryReminderTime) || other.diaryReminderTime == diaryReminderTime));
}


@override
int get hashCode {
    return Object.hash(runtimeType,diaryBookPaged,postHintVisible,themeMode,diaryReminderEnabled,diaryReminderTime);
}

@override
String toString() {
    return 'Settings(diaryBookPaged: $diaryBookPaged, postHintVisible: $postHintVisible, themeMode: $themeMode, diaryReminderEnabled: $diaryReminderEnabled, diaryReminderTime: $diaryReminderTime)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 bool diaryBookPaged, bool postHintVisible, ThemeMode themeMode, bool diaryReminderEnabled, TimeOfDay diaryReminderTime
});




}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diaryBookPaged = null,Object? postHintVisible = null,Object? themeMode = null,Object? diaryReminderEnabled = null,Object? diaryReminderTime = null,}) {
  return _then(_Settings(
diaryBookPaged: null == diaryBookPaged ? _self.diaryBookPaged : diaryBookPaged // ignore: cast_nullable_to_non_nullable
as bool,postHintVisible: null == postHintVisible ? _self.postHintVisible : postHintVisible // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,diaryReminderEnabled: null == diaryReminderEnabled ? _self.diaryReminderEnabled : diaryReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,diaryReminderTime: null == diaryReminderTime ? _self.diaryReminderTime : diaryReminderTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

// dart format on
