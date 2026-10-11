// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_book_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiaryBookPageState {

/// 日記帳に参加している人。参加した順。
 List<DiaryBookMember> get members;/// その日の日記。書いた時刻の新しい順。
 List<Diary> get diaries;/// その日（朝4時区切り）の記録。古い順。
 List<TimelinePost> get posts;
/// Create a copy of DiaryBookPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookPageStateCopyWith<DiaryBookPageState> get copyWith => _$DiaryBookPageStateCopyWithImpl<DiaryBookPageState>(this as DiaryBookPageState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiaryBookPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBookPageState&&const DeepCollectionEquality().equals(other.members, _this.members)&&const DeepCollectionEquality().equals(other.diaries, _this.diaries)&&const DeepCollectionEquality().equals(other.posts, _this.posts));
}


@override
int get hashCode {
  final _this = this as DiaryBookPageState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.members),const DeepCollectionEquality().hash(_this.diaries),const DeepCollectionEquality().hash(_this.posts));
}

@override
String toString() {
  final _this = this as DiaryBookPageState;
  return 'DiaryBookPageState(members: ${_this.members}, diaries: ${_this.diaries}, posts: ${_this.posts})';
}


}

/// @nodoc
abstract mixin class $DiaryBookPageStateCopyWith<$Res>  {
  factory $DiaryBookPageStateCopyWith(DiaryBookPageState value, $Res Function(DiaryBookPageState) _then) = _$DiaryBookPageStateCopyWithImpl;
@useResult
$Res call({
 List<DiaryBookMember> members, List<Diary> diaries, List<TimelinePost> posts
});




}
/// @nodoc
class _$DiaryBookPageStateCopyWithImpl<$Res>
    implements $DiaryBookPageStateCopyWith<$Res> {
  _$DiaryBookPageStateCopyWithImpl(this._self, this._then);

  final DiaryBookPageState _self;
  final $Res Function(DiaryBookPageState) _then;

/// Create a copy of DiaryBookPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? diaries = null,Object? posts = null,}) {
  return _then(DiaryBookPageState(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<DiaryBookMember>,diaries: null == diaries ? _self.diaries : diaries // ignore: cast_nullable_to_non_nullable
as List<Diary>,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<TimelinePost>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryBookPageState].
extension DiaryBookPageStatePatterns on DiaryBookPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBookPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBookPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBookPageState value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBookPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBookPageState value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBookPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiaryBookMember> members,  List<Diary> diaries,  List<TimelinePost> posts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBookPageState() when $default != null:
return $default(_that.members,_that.diaries,_that.posts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiaryBookMember> members,  List<Diary> diaries,  List<TimelinePost> posts)  $default,) {final _that = this;
switch (_that) {
case _DiaryBookPageState():
return $default(_that.members,_that.diaries,_that.posts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiaryBookMember> members,  List<Diary> diaries,  List<TimelinePost> posts)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBookPageState() when $default != null:
return $default(_that.members,_that.diaries,_that.posts);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryBookPageState implements DiaryBookPageState {
  const _DiaryBookPageState({required  List<DiaryBookMember> members, required  List<Diary> diaries, required  List<TimelinePost> posts}): _members = members,_diaries = diaries,_posts = posts;
  

/// 日記帳に参加している人。参加した順。
 final  List<DiaryBookMember> _members;
/// 日記帳に参加している人。参加した順。
@override List<DiaryBookMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

/// その日の日記。書いた時刻の新しい順。
 final  List<Diary> _diaries;
/// その日の日記。書いた時刻の新しい順。
@override List<Diary> get diaries {
  if (_diaries is EqualUnmodifiableListView) return _diaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diaries);
}

/// その日（朝4時区切り）の記録。古い順。
 final  List<TimelinePost> _posts;
/// その日（朝4時区切り）の記録。古い順。
@override List<TimelinePost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}


/// Create a copy of DiaryBookPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookPageStateCopyWith<_DiaryBookPageState> get copyWith => __$DiaryBookPageStateCopyWithImpl<_DiaryBookPageState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBookPageState&&const DeepCollectionEquality().equals(other.members, _members)&&const DeepCollectionEquality().equals(other.diaries, _diaries)&&const DeepCollectionEquality().equals(other.posts, _posts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_diaries),const DeepCollectionEquality().hash(_posts));
}

@override
String toString() {
    return 'DiaryBookPageState(members: $members, diaries: $diaries, posts: $posts)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookPageStateCopyWith<$Res> implements $DiaryBookPageStateCopyWith<$Res> {
  factory _$DiaryBookPageStateCopyWith(_DiaryBookPageState value, $Res Function(_DiaryBookPageState) _then) = __$DiaryBookPageStateCopyWithImpl;
@override @useResult
$Res call({
 List<DiaryBookMember> members, List<Diary> diaries, List<TimelinePost> posts
});




}
/// @nodoc
class __$DiaryBookPageStateCopyWithImpl<$Res>
    implements _$DiaryBookPageStateCopyWith<$Res> {
  __$DiaryBookPageStateCopyWithImpl(this._self, this._then);

  final _DiaryBookPageState _self;
  final $Res Function(_DiaryBookPageState) _then;

/// Create a copy of DiaryBookPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? diaries = null,Object? posts = null,}) {
  return _then(_DiaryBookPageState(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<DiaryBookMember>,diaries: null == diaries ? _self._diaries : diaries // ignore: cast_nullable_to_non_nullable
as List<Diary>,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<TimelinePost>,
  ));
}


}

// dart format on
