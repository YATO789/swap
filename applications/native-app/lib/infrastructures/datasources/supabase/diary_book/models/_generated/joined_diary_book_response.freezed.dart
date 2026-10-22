// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../joined_diary_book_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinedDiaryBookResponse {

 DiaryBookResponse get diaryBook; int get memberCount;
/// Create a copy of JoinedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinedDiaryBookResponseCopyWith<JoinedDiaryBookResponse> get copyWith => _$JoinedDiaryBookResponseCopyWithImpl<JoinedDiaryBookResponse>(this as JoinedDiaryBookResponse, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JoinedDiaryBookResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinedDiaryBookResponse&&(identical(other.diaryBook, _this.diaryBook) || other.diaryBook == _this.diaryBook)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount));
}


@override
int get hashCode {
  final _this = this as JoinedDiaryBookResponse;
  return Object.hash(runtimeType,_this.diaryBook,_this.memberCount);
}

@override
String toString() {
  final _this = this as JoinedDiaryBookResponse;
  return 'JoinedDiaryBookResponse(diaryBook: ${_this.diaryBook}, memberCount: ${_this.memberCount})';
}


}

/// @nodoc
abstract mixin class $JoinedDiaryBookResponseCopyWith<$Res>  {
  factory $JoinedDiaryBookResponseCopyWith(JoinedDiaryBookResponse value, $Res Function(JoinedDiaryBookResponse) _then) = _$JoinedDiaryBookResponseCopyWithImpl;
@useResult
$Res call({
 DiaryBookResponse diaryBook, int memberCount
});


$DiaryBookResponseCopyWith<$Res> get diaryBook;

}
/// @nodoc
class _$JoinedDiaryBookResponseCopyWithImpl<$Res>
    implements $JoinedDiaryBookResponseCopyWith<$Res> {
  _$JoinedDiaryBookResponseCopyWithImpl(this._self, this._then);

  final JoinedDiaryBookResponse _self;
  final $Res Function(JoinedDiaryBookResponse) _then;

/// Create a copy of JoinedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diaryBook = null,Object? memberCount = null,}) {
  return _then(JoinedDiaryBookResponse(
diaryBook: null == diaryBook ? _self.diaryBook : diaryBook // ignore: cast_nullable_to_non_nullable
as DiaryBookResponse,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of JoinedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryBookResponseCopyWith<$Res> get diaryBook {
  
  return $DiaryBookResponseCopyWith<$Res>(_self.diaryBook, (value) {
    return _then(_self.copyWith(diaryBook: value));
  });
}
}


/// Adds pattern-matching-related methods to [JoinedDiaryBookResponse].
extension JoinedDiaryBookResponsePatterns on JoinedDiaryBookResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinedDiaryBookResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinedDiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinedDiaryBookResponse value)  $default,){
final _that = this;
switch (_that) {
case _JoinedDiaryBookResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinedDiaryBookResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JoinedDiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiaryBookResponse diaryBook,  int memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinedDiaryBookResponse() when $default != null:
return $default(_that.diaryBook,_that.memberCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiaryBookResponse diaryBook,  int memberCount)  $default,) {final _that = this;
switch (_that) {
case _JoinedDiaryBookResponse():
return $default(_that.diaryBook,_that.memberCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiaryBookResponse diaryBook,  int memberCount)?  $default,) {final _that = this;
switch (_that) {
case _JoinedDiaryBookResponse() when $default != null:
return $default(_that.diaryBook,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc


class _JoinedDiaryBookResponse implements JoinedDiaryBookResponse {
  const _JoinedDiaryBookResponse({required this.diaryBook, required this.memberCount});
  

@override final  DiaryBookResponse diaryBook;
@override final  int memberCount;

/// Create a copy of JoinedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinedDiaryBookResponseCopyWith<_JoinedDiaryBookResponse> get copyWith => __$JoinedDiaryBookResponseCopyWithImpl<_JoinedDiaryBookResponse>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinedDiaryBookResponse&&(identical(other.diaryBook, diaryBook) || other.diaryBook == diaryBook)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,diaryBook,memberCount);
}

@override
String toString() {
    return 'JoinedDiaryBookResponse(diaryBook: $diaryBook, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$JoinedDiaryBookResponseCopyWith<$Res> implements $JoinedDiaryBookResponseCopyWith<$Res> {
  factory _$JoinedDiaryBookResponseCopyWith(_JoinedDiaryBookResponse value, $Res Function(_JoinedDiaryBookResponse) _then) = __$JoinedDiaryBookResponseCopyWithImpl;
@override @useResult
$Res call({
 DiaryBookResponse diaryBook, int memberCount
});


@override $DiaryBookResponseCopyWith<$Res> get diaryBook;

}
/// @nodoc
class __$JoinedDiaryBookResponseCopyWithImpl<$Res>
    implements _$JoinedDiaryBookResponseCopyWith<$Res> {
  __$JoinedDiaryBookResponseCopyWithImpl(this._self, this._then);

  final _JoinedDiaryBookResponse _self;
  final $Res Function(_JoinedDiaryBookResponse) _then;

/// Create a copy of JoinedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diaryBook = null,Object? memberCount = null,}) {
  return _then(_JoinedDiaryBookResponse(
diaryBook: null == diaryBook ? _self.diaryBook : diaryBook // ignore: cast_nullable_to_non_nullable
as DiaryBookResponse,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of JoinedDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryBookResponseCopyWith<$Res> get diaryBook {
  
  return $DiaryBookResponseCopyWith<$Res>(_self.diaryBook, (value) {
    return _then(_self.copyWith(diaryBook: value));
  });
}
}

// dart format on
