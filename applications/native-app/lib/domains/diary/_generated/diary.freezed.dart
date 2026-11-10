// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Diary {

 String get id; String get authorId;/// どの日の日記か（年月日のみ）。朝4時区切りなので、深夜に書いたものは前日になる。
 DateTime get date;/// 実際に書いた時刻。端末の時計ではなくサーバーの時刻。
 DateTime get writtenAt;/// 空ならタイトルなし。まだ読めない日記でも見える。
 String get title;/// 本文。まだ読めない日記（自分がその日に書いていない）なら null。
 String? get body;/// 付いた絵文字のリアクション。付けた順。1人1つ。
 List<Reaction> get reactions;
/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryCopyWith<Diary> get copyWith => _$DiaryCopyWithImpl<Diary>(this as Diary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Diary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Diary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.writtenAt, _this.writtenAt) || other.writtenAt == _this.writtenAt)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.reactions, _this.reactions));
}


@override
int get hashCode {
  final _this = this as Diary;
  return Object.hash(runtimeType,_this.id,_this.authorId,_this.date,_this.writtenAt,_this.title,_this.body,const DeepCollectionEquality().hash(_this.reactions));
}

@override
String toString() {
  final _this = this as Diary;
  return 'Diary(id: ${_this.id}, authorId: ${_this.authorId}, date: ${_this.date}, writtenAt: ${_this.writtenAt}, title: ${_this.title}, body: ${_this.body}, reactions: ${_this.reactions})';
}


}

/// @nodoc
abstract mixin class $DiaryCopyWith<$Res>  {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) _then) = _$DiaryCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, DateTime date, DateTime writtenAt, String title, String? body, List<Reaction> reactions
});




}
/// @nodoc
class _$DiaryCopyWithImpl<$Res>
    implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._self, this._then);

  final Diary _self;
  final $Res Function(Diary) _then;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? date = null,Object? writtenAt = null,Object? title = null,Object? body = freezed,Object? reactions = null,}) {
  return _then(Diary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,writtenAt: null == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Reaction>,
  ));
}

}


/// Adds pattern-matching-related methods to [Diary].
extension DiaryPatterns on Diary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Diary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Diary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Diary value)  $default,){
final _that = this;
switch (_that) {
case _Diary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Diary value)?  $default,){
final _that = this;
switch (_that) {
case _Diary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  DateTime date,  DateTime writtenAt,  String title,  String? body,  List<Reaction> reactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Diary() when $default != null:
return $default(_that.id,_that.authorId,_that.date,_that.writtenAt,_that.title,_that.body,_that.reactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  DateTime date,  DateTime writtenAt,  String title,  String? body,  List<Reaction> reactions)  $default,) {final _that = this;
switch (_that) {
case _Diary():
return $default(_that.id,_that.authorId,_that.date,_that.writtenAt,_that.title,_that.body,_that.reactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  DateTime date,  DateTime writtenAt,  String title,  String? body,  List<Reaction> reactions)?  $default,) {final _that = this;
switch (_that) {
case _Diary() when $default != null:
return $default(_that.id,_that.authorId,_that.date,_that.writtenAt,_that.title,_that.body,_that.reactions);case _:
  return null;

}
}

}

/// @nodoc


class _Diary extends Diary {
  const _Diary({required this.id, required this.authorId, required this.date, required this.writtenAt, this.title = '', this.body,  List<Reaction> reactions = const []}): _reactions = reactions,super._();
  

@override final  String id;
@override final  String authorId;
/// どの日の日記か（年月日のみ）。朝4時区切りなので、深夜に書いたものは前日になる。
@override final  DateTime date;
/// 実際に書いた時刻。端末の時計ではなくサーバーの時刻。
@override final  DateTime writtenAt;
/// 空ならタイトルなし。まだ読めない日記でも見える。
@override@JsonKey() final  String title;
/// 本文。まだ読めない日記（自分がその日に書いていない）なら null。
@override final  String? body;
/// 付いた絵文字のリアクション。付けた順。1人1つ。
 final  List<Reaction> _reactions;
/// 付いた絵文字のリアクション。付けた順。1人1つ。
@override@JsonKey() List<Reaction> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}


/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryCopyWith<_Diary> get copyWith => __$DiaryCopyWithImpl<_Diary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Diary&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.writtenAt, writtenAt) || other.writtenAt == writtenAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.reactions, _reactions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,authorId,date,writtenAt,title,body,const DeepCollectionEquality().hash(_reactions));
}

@override
String toString() {
    return 'Diary(id: $id, authorId: $authorId, date: $date, writtenAt: $writtenAt, title: $title, body: $body, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class _$DiaryCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$DiaryCopyWith(_Diary value, $Res Function(_Diary) _then) = __$DiaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, DateTime date, DateTime writtenAt, String title, String? body, List<Reaction> reactions
});




}
/// @nodoc
class __$DiaryCopyWithImpl<$Res>
    implements _$DiaryCopyWith<$Res> {
  __$DiaryCopyWithImpl(this._self, this._then);

  final _Diary _self;
  final $Res Function(_Diary) _then;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? date = null,Object? writtenAt = null,Object? title = null,Object? body = freezed,Object? reactions = null,}) {
  return _then(_Diary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,writtenAt: null == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Reaction>,
  ));
}


}

// dart format on
