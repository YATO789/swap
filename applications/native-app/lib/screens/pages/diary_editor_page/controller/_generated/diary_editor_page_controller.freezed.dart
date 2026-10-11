// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_editor_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiaryEditorPageState implements DiagnosticableTreeMixin {

/// その日にもう書いた自分の日記。日記帳の id ごと。
 Map<String, Diary> get diaries;/// その日（朝4時区切り）の自分の記録。古い順。
 List<TimelinePost> get posts;
/// Create a copy of DiaryEditorPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryEditorPageStateCopyWith<DiaryEditorPageState> get copyWith => _$DiaryEditorPageStateCopyWithImpl<DiaryEditorPageState>(this as DiaryEditorPageState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as DiaryEditorPageState;
  properties
    ..add(DiagnosticsProperty('type', 'DiaryEditorPageState'))
    ..add(DiagnosticsProperty('diaries', _this.diaries))..add(DiagnosticsProperty('posts', _this.posts));
}

@override
bool operator ==(Object other) {
  final _this = this as DiaryEditorPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryEditorPageState&&const DeepCollectionEquality().equals(other.diaries, _this.diaries)&&const DeepCollectionEquality().equals(other.posts, _this.posts));
}


@override
int get hashCode {
  final _this = this as DiaryEditorPageState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.diaries),const DeepCollectionEquality().hash(_this.posts));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as DiaryEditorPageState;
  return 'DiaryEditorPageState(diaries: ${_this.diaries}, posts: ${_this.posts})';
}


}

/// @nodoc
abstract mixin class $DiaryEditorPageStateCopyWith<$Res>  {
  factory $DiaryEditorPageStateCopyWith(DiaryEditorPageState value, $Res Function(DiaryEditorPageState) _then) = _$DiaryEditorPageStateCopyWithImpl;
@useResult
$Res call({
 Map<String, Diary> diaries, List<TimelinePost> posts
});




}
/// @nodoc
class _$DiaryEditorPageStateCopyWithImpl<$Res>
    implements $DiaryEditorPageStateCopyWith<$Res> {
  _$DiaryEditorPageStateCopyWithImpl(this._self, this._then);

  final DiaryEditorPageState _self;
  final $Res Function(DiaryEditorPageState) _then;

/// Create a copy of DiaryEditorPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diaries = null,Object? posts = null,}) {
  return _then(DiaryEditorPageState(
diaries: null == diaries ? _self.diaries : diaries // ignore: cast_nullable_to_non_nullable
as Map<String, Diary>,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<TimelinePost>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryEditorPageState].
extension DiaryEditorPageStatePatterns on DiaryEditorPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryEditorPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryEditorPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryEditorPageState value)  $default,){
final _that = this;
switch (_that) {
case _DiaryEditorPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryEditorPageState value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryEditorPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Diary> diaries,  List<TimelinePost> posts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryEditorPageState() when $default != null:
return $default(_that.diaries,_that.posts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Diary> diaries,  List<TimelinePost> posts)  $default,) {final _that = this;
switch (_that) {
case _DiaryEditorPageState():
return $default(_that.diaries,_that.posts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Diary> diaries,  List<TimelinePost> posts)?  $default,) {final _that = this;
switch (_that) {
case _DiaryEditorPageState() when $default != null:
return $default(_that.diaries,_that.posts);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryEditorPageState with DiagnosticableTreeMixin implements DiaryEditorPageState {
  const _DiaryEditorPageState({required  Map<String, Diary> diaries, required  List<TimelinePost> posts}): _diaries = diaries,_posts = posts;
  

/// その日にもう書いた自分の日記。日記帳の id ごと。
 final  Map<String, Diary> _diaries;
/// その日にもう書いた自分の日記。日記帳の id ごと。
@override Map<String, Diary> get diaries {
  if (_diaries is EqualUnmodifiableMapView) return _diaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_diaries);
}

/// その日（朝4時区切り）の自分の記録。古い順。
 final  List<TimelinePost> _posts;
/// その日（朝4時区切り）の自分の記録。古い順。
@override List<TimelinePost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}


/// Create a copy of DiaryEditorPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryEditorPageStateCopyWith<_DiaryEditorPageState> get copyWith => __$DiaryEditorPageStateCopyWithImpl<_DiaryEditorPageState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'DiaryEditorPageState'))
    ..add(DiagnosticsProperty('diaries', diaries))..add(DiagnosticsProperty('posts', posts));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryEditorPageState&&const DeepCollectionEquality().equals(other.diaries, _diaries)&&const DeepCollectionEquality().equals(other.posts, _posts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_diaries),const DeepCollectionEquality().hash(_posts));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'DiaryEditorPageState(diaries: $diaries, posts: $posts)';
}


}

/// @nodoc
abstract mixin class _$DiaryEditorPageStateCopyWith<$Res> implements $DiaryEditorPageStateCopyWith<$Res> {
  factory _$DiaryEditorPageStateCopyWith(_DiaryEditorPageState value, $Res Function(_DiaryEditorPageState) _then) = __$DiaryEditorPageStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Diary> diaries, List<TimelinePost> posts
});




}
/// @nodoc
class __$DiaryEditorPageStateCopyWithImpl<$Res>
    implements _$DiaryEditorPageStateCopyWith<$Res> {
  __$DiaryEditorPageStateCopyWithImpl(this._self, this._then);

  final _DiaryEditorPageState _self;
  final $Res Function(_DiaryEditorPageState) _then;

/// Create a copy of DiaryEditorPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diaries = null,Object? posts = null,}) {
  return _then(_DiaryEditorPageState(
diaries: null == diaries ? _self._diaries : diaries // ignore: cast_nullable_to_non_nullable
as Map<String, Diary>,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<TimelinePost>,
  ));
}


}

// dart format on
