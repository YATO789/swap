// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_detail_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiaryDetailPageState implements DiagnosticableTreeMixin {

/// 読める日記。自分の日記を先頭に、あとは書いた時刻の新しい順。この順にページをめくる。
 List<Diary> get diaries;/// 日記を書いた人の表示名。
 Map<String, String> get names;/// 日記を書いた人ごとの、その日（朝4時区切り）の記録。古い順。
 Map<String, List<TimelinePost>> get posts;
/// Create a copy of DiaryDetailPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryDetailPageStateCopyWith<DiaryDetailPageState> get copyWith => _$DiaryDetailPageStateCopyWithImpl<DiaryDetailPageState>(this as DiaryDetailPageState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as DiaryDetailPageState;
  properties
    ..add(DiagnosticsProperty('type', 'DiaryDetailPageState'))
    ..add(DiagnosticsProperty('diaries', _this.diaries))..add(DiagnosticsProperty('names', _this.names))..add(DiagnosticsProperty('posts', _this.posts));
}

@override
bool operator ==(Object other) {
  final _this = this as DiaryDetailPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryDetailPageState&&const DeepCollectionEquality().equals(other.diaries, _this.diaries)&&const DeepCollectionEquality().equals(other.names, _this.names)&&const DeepCollectionEquality().equals(other.posts, _this.posts));
}


@override
int get hashCode {
  final _this = this as DiaryDetailPageState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.diaries),const DeepCollectionEquality().hash(_this.names),const DeepCollectionEquality().hash(_this.posts));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as DiaryDetailPageState;
  return 'DiaryDetailPageState(diaries: ${_this.diaries}, names: ${_this.names}, posts: ${_this.posts})';
}


}

/// @nodoc
abstract mixin class $DiaryDetailPageStateCopyWith<$Res>  {
  factory $DiaryDetailPageStateCopyWith(DiaryDetailPageState value, $Res Function(DiaryDetailPageState) _then) = _$DiaryDetailPageStateCopyWithImpl;
@useResult
$Res call({
 List<Diary> diaries, Map<String, String> names, Map<String, List<TimelinePost>> posts
});




}
/// @nodoc
class _$DiaryDetailPageStateCopyWithImpl<$Res>
    implements $DiaryDetailPageStateCopyWith<$Res> {
  _$DiaryDetailPageStateCopyWithImpl(this._self, this._then);

  final DiaryDetailPageState _self;
  final $Res Function(DiaryDetailPageState) _then;

/// Create a copy of DiaryDetailPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diaries = null,Object? names = null,Object? posts = null,}) {
  return _then(DiaryDetailPageState(
diaries: null == diaries ? _self.diaries : diaries // ignore: cast_nullable_to_non_nullable
as List<Diary>,names: null == names ? _self.names : names // ignore: cast_nullable_to_non_nullable
as Map<String, String>,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as Map<String, List<TimelinePost>>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryDetailPageState].
extension DiaryDetailPageStatePatterns on DiaryDetailPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryDetailPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryDetailPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryDetailPageState value)  $default,){
final _that = this;
switch (_that) {
case _DiaryDetailPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryDetailPageState value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryDetailPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Diary> diaries,  Map<String, String> names,  Map<String, List<TimelinePost>> posts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryDetailPageState() when $default != null:
return $default(_that.diaries,_that.names,_that.posts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Diary> diaries,  Map<String, String> names,  Map<String, List<TimelinePost>> posts)  $default,) {final _that = this;
switch (_that) {
case _DiaryDetailPageState():
return $default(_that.diaries,_that.names,_that.posts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Diary> diaries,  Map<String, String> names,  Map<String, List<TimelinePost>> posts)?  $default,) {final _that = this;
switch (_that) {
case _DiaryDetailPageState() when $default != null:
return $default(_that.diaries,_that.names,_that.posts);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryDetailPageState with DiagnosticableTreeMixin implements DiaryDetailPageState {
  const _DiaryDetailPageState({required  List<Diary> diaries, required  Map<String, String> names, required  Map<String, List<TimelinePost>> posts}): _diaries = diaries,_names = names,_posts = posts;
  

/// 読める日記。自分の日記を先頭に、あとは書いた時刻の新しい順。この順にページをめくる。
 final  List<Diary> _diaries;
/// 読める日記。自分の日記を先頭に、あとは書いた時刻の新しい順。この順にページをめくる。
@override List<Diary> get diaries {
  if (_diaries is EqualUnmodifiableListView) return _diaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diaries);
}

/// 日記を書いた人の表示名。
 final  Map<String, String> _names;
/// 日記を書いた人の表示名。
@override Map<String, String> get names {
  if (_names is EqualUnmodifiableMapView) return _names;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_names);
}

/// 日記を書いた人ごとの、その日（朝4時区切り）の記録。古い順。
 final  Map<String, List<TimelinePost>> _posts;
/// 日記を書いた人ごとの、その日（朝4時区切り）の記録。古い順。
@override Map<String, List<TimelinePost>> get posts {
  if (_posts is EqualUnmodifiableMapView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_posts);
}


/// Create a copy of DiaryDetailPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryDetailPageStateCopyWith<_DiaryDetailPageState> get copyWith => __$DiaryDetailPageStateCopyWithImpl<_DiaryDetailPageState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'DiaryDetailPageState'))
    ..add(DiagnosticsProperty('diaries', diaries))..add(DiagnosticsProperty('names', names))..add(DiagnosticsProperty('posts', posts));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryDetailPageState&&const DeepCollectionEquality().equals(other.diaries, _diaries)&&const DeepCollectionEquality().equals(other.names, _names)&&const DeepCollectionEquality().equals(other.posts, _posts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_diaries),const DeepCollectionEquality().hash(_names),const DeepCollectionEquality().hash(_posts));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'DiaryDetailPageState(diaries: $diaries, names: $names, posts: $posts)';
}


}

/// @nodoc
abstract mixin class _$DiaryDetailPageStateCopyWith<$Res> implements $DiaryDetailPageStateCopyWith<$Res> {
  factory _$DiaryDetailPageStateCopyWith(_DiaryDetailPageState value, $Res Function(_DiaryDetailPageState) _then) = __$DiaryDetailPageStateCopyWithImpl;
@override @useResult
$Res call({
 List<Diary> diaries, Map<String, String> names, Map<String, List<TimelinePost>> posts
});




}
/// @nodoc
class __$DiaryDetailPageStateCopyWithImpl<$Res>
    implements _$DiaryDetailPageStateCopyWith<$Res> {
  __$DiaryDetailPageStateCopyWithImpl(this._self, this._then);

  final _DiaryDetailPageState _self;
  final $Res Function(_DiaryDetailPageState) _then;

/// Create a copy of DiaryDetailPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diaries = null,Object? names = null,Object? posts = null,}) {
  return _then(_DiaryDetailPageState(
diaries: null == diaries ? _self._diaries : diaries // ignore: cast_nullable_to_non_nullable
as List<Diary>,names: null == names ? _self._names : names // ignore: cast_nullable_to_non_nullable
as Map<String, String>,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as Map<String, List<TimelinePost>>,
  ));
}


}

// dart format on
