// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../diary_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryResponse {

 String get id; String get diaryBookId; String get authorId; DateTime get date;@LocalDateTimeConverter() DateTime get writtenAt;/// diary_id が主キーなので1対1になる。RLS で読めなければ null。
@JsonKey(name: 'diary_contents') DiaryContentResponse? get content;
/// Create a copy of DiaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryResponseCopyWith<DiaryResponse> get copyWith => _$DiaryResponseCopyWithImpl<DiaryResponse>(this as DiaryResponse, _$identity);

  /// Serializes this DiaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.diaryBookId, _this.diaryBookId) || other.diaryBookId == _this.diaryBookId)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.writtenAt, _this.writtenAt) || other.writtenAt == _this.writtenAt)&&(identical(other.content, _this.content) || other.content == _this.content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryResponse;
  return Object.hash(runtimeType,_this.id,_this.diaryBookId,_this.authorId,_this.date,_this.writtenAt,_this.content);
}

@override
String toString() {
  final _this = this as DiaryResponse;
  return 'DiaryResponse(id: ${_this.id}, diaryBookId: ${_this.diaryBookId}, authorId: ${_this.authorId}, date: ${_this.date}, writtenAt: ${_this.writtenAt}, content: ${_this.content})';
}


}

/// @nodoc
abstract mixin class $DiaryResponseCopyWith<$Res>  {
  factory $DiaryResponseCopyWith(DiaryResponse value, $Res Function(DiaryResponse) _then) = _$DiaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String diaryBookId, String authorId, DateTime date,@LocalDateTimeConverter() DateTime writtenAt,@JsonKey(name: 'diary_contents') DiaryContentResponse? content
});


$DiaryContentResponseCopyWith<$Res>? get content;

}
/// @nodoc
class _$DiaryResponseCopyWithImpl<$Res>
    implements $DiaryResponseCopyWith<$Res> {
  _$DiaryResponseCopyWithImpl(this._self, this._then);

  final DiaryResponse _self;
  final $Res Function(DiaryResponse) _then;

/// Create a copy of DiaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? diaryBookId = null,Object? authorId = null,Object? date = null,Object? writtenAt = null,Object? content = freezed,}) {
  return _then(DiaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,diaryBookId: null == diaryBookId ? _self.diaryBookId : diaryBookId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,writtenAt: null == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as DateTime,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as DiaryContentResponse?,
  ));
}
/// Create a copy of DiaryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryContentResponseCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $DiaryContentResponseCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiaryResponse].
extension DiaryResponsePatterns on DiaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _DiaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String diaryBookId,  String authorId,  DateTime date, @LocalDateTimeConverter()  DateTime writtenAt, @JsonKey(name: 'diary_contents')  DiaryContentResponse? content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryResponse() when $default != null:
return $default(_that.id,_that.diaryBookId,_that.authorId,_that.date,_that.writtenAt,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String diaryBookId,  String authorId,  DateTime date, @LocalDateTimeConverter()  DateTime writtenAt, @JsonKey(name: 'diary_contents')  DiaryContentResponse? content)  $default,) {final _that = this;
switch (_that) {
case _DiaryResponse():
return $default(_that.id,_that.diaryBookId,_that.authorId,_that.date,_that.writtenAt,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String diaryBookId,  String authorId,  DateTime date, @LocalDateTimeConverter()  DateTime writtenAt, @JsonKey(name: 'diary_contents')  DiaryContentResponse? content)?  $default,) {final _that = this;
switch (_that) {
case _DiaryResponse() when $default != null:
return $default(_that.id,_that.diaryBookId,_that.authorId,_that.date,_that.writtenAt,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryResponse implements DiaryResponse {
  const _DiaryResponse({required this.id, required this.diaryBookId, required this.authorId, required this.date, @LocalDateTimeConverter() required this.writtenAt, @JsonKey(name: 'diary_contents') this.content});
  factory _DiaryResponse.fromJson(Map<String, dynamic> json) => _$DiaryResponseFromJson(json);

@override final  String id;
@override final  String diaryBookId;
@override final  String authorId;
@override final  DateTime date;
@override@LocalDateTimeConverter() final  DateTime writtenAt;
/// diary_id が主キーなので1対1になる。RLS で読めなければ null。
@override@JsonKey(name: 'diary_contents') final  DiaryContentResponse? content;

/// Create a copy of DiaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryResponseCopyWith<_DiaryResponse> get copyWith => __$DiaryResponseCopyWithImpl<_DiaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.diaryBookId, diaryBookId) || other.diaryBookId == diaryBookId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.writtenAt, writtenAt) || other.writtenAt == writtenAt)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,diaryBookId,authorId,date,writtenAt,content);
}

@override
String toString() {
    return 'DiaryResponse(id: $id, diaryBookId: $diaryBookId, authorId: $authorId, date: $date, writtenAt: $writtenAt, content: $content)';
}


}

/// @nodoc
abstract mixin class _$DiaryResponseCopyWith<$Res> implements $DiaryResponseCopyWith<$Res> {
  factory _$DiaryResponseCopyWith(_DiaryResponse value, $Res Function(_DiaryResponse) _then) = __$DiaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String diaryBookId, String authorId, DateTime date,@LocalDateTimeConverter() DateTime writtenAt,@JsonKey(name: 'diary_contents') DiaryContentResponse? content
});


@override $DiaryContentResponseCopyWith<$Res>? get content;

}
/// @nodoc
class __$DiaryResponseCopyWithImpl<$Res>
    implements _$DiaryResponseCopyWith<$Res> {
  __$DiaryResponseCopyWithImpl(this._self, this._then);

  final _DiaryResponse _self;
  final $Res Function(_DiaryResponse) _then;

/// Create a copy of DiaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? diaryBookId = null,Object? authorId = null,Object? date = null,Object? writtenAt = null,Object? content = freezed,}) {
  return _then(_DiaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,diaryBookId: null == diaryBookId ? _self.diaryBookId : diaryBookId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,writtenAt: null == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as DateTime,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as DiaryContentResponse?,
  ));
}

/// Create a copy of DiaryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryContentResponseCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $DiaryContentResponseCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$DiaryContentResponse {

 String get title; String get body;
/// Create a copy of DiaryContentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryContentResponseCopyWith<DiaryContentResponse> get copyWith => _$DiaryContentResponseCopyWithImpl<DiaryContentResponse>(this as DiaryContentResponse, _$identity);

  /// Serializes this DiaryContentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryContentResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryContentResponse&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryContentResponse;
  return Object.hash(runtimeType,_this.title,_this.body);
}

@override
String toString() {
  final _this = this as DiaryContentResponse;
  return 'DiaryContentResponse(title: ${_this.title}, body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $DiaryContentResponseCopyWith<$Res>  {
  factory $DiaryContentResponseCopyWith(DiaryContentResponse value, $Res Function(DiaryContentResponse) _then) = _$DiaryContentResponseCopyWithImpl;
@useResult
$Res call({
 String title, String body
});




}
/// @nodoc
class _$DiaryContentResponseCopyWithImpl<$Res>
    implements $DiaryContentResponseCopyWith<$Res> {
  _$DiaryContentResponseCopyWithImpl(this._self, this._then);

  final DiaryContentResponse _self;
  final $Res Function(DiaryContentResponse) _then;

/// Create a copy of DiaryContentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,}) {
  return _then(DiaryContentResponse(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryContentResponse].
extension DiaryContentResponsePatterns on DiaryContentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryContentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryContentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryContentResponse value)  $default,){
final _that = this;
switch (_that) {
case _DiaryContentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryContentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryContentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryContentResponse() when $default != null:
return $default(_that.title,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body)  $default,) {final _that = this;
switch (_that) {
case _DiaryContentResponse():
return $default(_that.title,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _DiaryContentResponse() when $default != null:
return $default(_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryContentResponse implements DiaryContentResponse {
  const _DiaryContentResponse({required this.title, required this.body});
  factory _DiaryContentResponse.fromJson(Map<String, dynamic> json) => _$DiaryContentResponseFromJson(json);

@override final  String title;
@override final  String body;

/// Create a copy of DiaryContentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryContentResponseCopyWith<_DiaryContentResponse> get copyWith => __$DiaryContentResponseCopyWithImpl<_DiaryContentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryContentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryContentResponse&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,body);
}

@override
String toString() {
    return 'DiaryContentResponse(title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$DiaryContentResponseCopyWith<$Res> implements $DiaryContentResponseCopyWith<$Res> {
  factory _$DiaryContentResponseCopyWith(_DiaryContentResponse value, $Res Function(_DiaryContentResponse) _then) = __$DiaryContentResponseCopyWithImpl;
@override @useResult
$Res call({
 String title, String body
});




}
/// @nodoc
class __$DiaryContentResponseCopyWithImpl<$Res>
    implements _$DiaryContentResponseCopyWith<$Res> {
  __$DiaryContentResponseCopyWithImpl(this._self, this._then);

  final _DiaryContentResponse _self;
  final $Res Function(_DiaryContentResponse) _then;

/// Create a copy of DiaryContentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,}) {
  return _then(_DiaryContentResponse(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
