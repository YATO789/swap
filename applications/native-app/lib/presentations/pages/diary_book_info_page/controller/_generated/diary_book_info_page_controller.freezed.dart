// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_book_info_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiaryBookInfoPageState implements DiagnosticableTreeMixin {

/// 日記帳に参加している人。参加した順。
 List<DiaryBookMember> get members;
/// Create a copy of DiaryBookInfoPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryBookInfoPageStateCopyWith<DiaryBookInfoPageState> get copyWith => _$DiaryBookInfoPageStateCopyWithImpl<DiaryBookInfoPageState>(this as DiaryBookInfoPageState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as DiaryBookInfoPageState;
  properties
    ..add(DiagnosticsProperty('type', 'DiaryBookInfoPageState'))
    ..add(DiagnosticsProperty('members', _this.members));
}

@override
bool operator ==(Object other) {
  final _this = this as DiaryBookInfoPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryBookInfoPageState&&const DeepCollectionEquality().equals(other.members, _this.members));
}


@override
int get hashCode {
  final _this = this as DiaryBookInfoPageState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.members));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as DiaryBookInfoPageState;
  return 'DiaryBookInfoPageState(members: ${_this.members})';
}


}

/// @nodoc
abstract mixin class $DiaryBookInfoPageStateCopyWith<$Res>  {
  factory $DiaryBookInfoPageStateCopyWith(DiaryBookInfoPageState value, $Res Function(DiaryBookInfoPageState) _then) = _$DiaryBookInfoPageStateCopyWithImpl;
@useResult
$Res call({
 List<DiaryBookMember> members
});




}
/// @nodoc
class _$DiaryBookInfoPageStateCopyWithImpl<$Res>
    implements $DiaryBookInfoPageStateCopyWith<$Res> {
  _$DiaryBookInfoPageStateCopyWithImpl(this._self, this._then);

  final DiaryBookInfoPageState _self;
  final $Res Function(DiaryBookInfoPageState) _then;

/// Create a copy of DiaryBookInfoPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,}) {
  return _then(DiaryBookInfoPageState(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<DiaryBookMember>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryBookInfoPageState].
extension DiaryBookInfoPageStatePatterns on DiaryBookInfoPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryBookInfoPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryBookInfoPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryBookInfoPageState value)  $default,){
final _that = this;
switch (_that) {
case _DiaryBookInfoPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryBookInfoPageState value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryBookInfoPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiaryBookMember> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryBookInfoPageState() when $default != null:
return $default(_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiaryBookMember> members)  $default,) {final _that = this;
switch (_that) {
case _DiaryBookInfoPageState():
return $default(_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiaryBookMember> members)?  $default,) {final _that = this;
switch (_that) {
case _DiaryBookInfoPageState() when $default != null:
return $default(_that.members);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryBookInfoPageState with DiagnosticableTreeMixin implements DiaryBookInfoPageState {
  const _DiaryBookInfoPageState({required  List<DiaryBookMember> members}): _members = members;
  

/// 日記帳に参加している人。参加した順。
 final  List<DiaryBookMember> _members;
/// 日記帳に参加している人。参加した順。
@override List<DiaryBookMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of DiaryBookInfoPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryBookInfoPageStateCopyWith<_DiaryBookInfoPageState> get copyWith => __$DiaryBookInfoPageStateCopyWithImpl<_DiaryBookInfoPageState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'DiaryBookInfoPageState'))
    ..add(DiagnosticsProperty('members', members));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryBookInfoPageState&&const DeepCollectionEquality().equals(other.members, _members));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_members));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'DiaryBookInfoPageState(members: $members)';
}


}

/// @nodoc
abstract mixin class _$DiaryBookInfoPageStateCopyWith<$Res> implements $DiaryBookInfoPageStateCopyWith<$Res> {
  factory _$DiaryBookInfoPageStateCopyWith(_DiaryBookInfoPageState value, $Res Function(_DiaryBookInfoPageState) _then) = __$DiaryBookInfoPageStateCopyWithImpl;
@override @useResult
$Res call({
 List<DiaryBookMember> members
});




}
/// @nodoc
class __$DiaryBookInfoPageStateCopyWithImpl<$Res>
    implements _$DiaryBookInfoPageStateCopyWith<$Res> {
  __$DiaryBookInfoPageStateCopyWithImpl(this._self, this._then);

  final _DiaryBookInfoPageState _self;
  final $Res Function(_DiaryBookInfoPageState) _then;

/// Create a copy of DiaryBookInfoPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,}) {
  return _then(_DiaryBookInfoPageState(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<DiaryBookMember>,
  ));
}


}

// dart format on
