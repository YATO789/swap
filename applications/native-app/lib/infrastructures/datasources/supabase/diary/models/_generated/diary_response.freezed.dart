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

 String get id; String get diaryBookId; String get authorId; DateTime get date;@LocalDateTimeConverter() DateTime get writtenAt;/// 空ならタイトルなし。まだ読めない日記でも返る。
 String get title;/// diary_id が主キーなので1対1になる。RLS で読めなければ null。
@JsonKey(name: 'diary_contents') DiaryContentResponse? get content;/// 付いたリアクション。
 List<DiaryReactionResponse> get diaryReactions;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.diaryBookId, _this.diaryBookId) || other.diaryBookId == _this.diaryBookId)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.writtenAt, _this.writtenAt) || other.writtenAt == _this.writtenAt)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&const DeepCollectionEquality().equals(other.diaryReactions, _this.diaryReactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryResponse;
  return Object.hash(runtimeType,_this.id,_this.diaryBookId,_this.authorId,_this.date,_this.writtenAt,_this.title,_this.content,const DeepCollectionEquality().hash(_this.diaryReactions));
}

@override
String toString() {
  final _this = this as DiaryResponse;
  return 'DiaryResponse(id: ${_this.id}, diaryBookId: ${_this.diaryBookId}, authorId: ${_this.authorId}, date: ${_this.date}, writtenAt: ${_this.writtenAt}, title: ${_this.title}, content: ${_this.content}, diaryReactions: ${_this.diaryReactions})';
}


}

/// @nodoc
abstract mixin class $DiaryResponseCopyWith<$Res>  {
  factory $DiaryResponseCopyWith(DiaryResponse value, $Res Function(DiaryResponse) _then) = _$DiaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String diaryBookId, String authorId, DateTime date,@LocalDateTimeConverter() DateTime writtenAt, String title,@JsonKey(name: 'diary_contents') DiaryContentResponse? content, List<DiaryReactionResponse> diaryReactions
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? diaryBookId = null,Object? authorId = null,Object? date = null,Object? writtenAt = null,Object? title = null,Object? content = freezed,Object? diaryReactions = null,}) {
  return _then(DiaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,diaryBookId: null == diaryBookId ? _self.diaryBookId : diaryBookId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,writtenAt: null == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as DiaryContentResponse?,diaryReactions: null == diaryReactions ? _self.diaryReactions : diaryReactions // ignore: cast_nullable_to_non_nullable
as List<DiaryReactionResponse>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String diaryBookId,  String authorId,  DateTime date, @LocalDateTimeConverter()  DateTime writtenAt,  String title, @JsonKey(name: 'diary_contents')  DiaryContentResponse? content,  List<DiaryReactionResponse> diaryReactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryResponse() when $default != null:
return $default(_that.id,_that.diaryBookId,_that.authorId,_that.date,_that.writtenAt,_that.title,_that.content,_that.diaryReactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String diaryBookId,  String authorId,  DateTime date, @LocalDateTimeConverter()  DateTime writtenAt,  String title, @JsonKey(name: 'diary_contents')  DiaryContentResponse? content,  List<DiaryReactionResponse> diaryReactions)  $default,) {final _that = this;
switch (_that) {
case _DiaryResponse():
return $default(_that.id,_that.diaryBookId,_that.authorId,_that.date,_that.writtenAt,_that.title,_that.content,_that.diaryReactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String diaryBookId,  String authorId,  DateTime date, @LocalDateTimeConverter()  DateTime writtenAt,  String title, @JsonKey(name: 'diary_contents')  DiaryContentResponse? content,  List<DiaryReactionResponse> diaryReactions)?  $default,) {final _that = this;
switch (_that) {
case _DiaryResponse() when $default != null:
return $default(_that.id,_that.diaryBookId,_that.authorId,_that.date,_that.writtenAt,_that.title,_that.content,_that.diaryReactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryResponse implements DiaryResponse {
  const _DiaryResponse({required this.id, required this.diaryBookId, required this.authorId, required this.date, @LocalDateTimeConverter() required this.writtenAt, required this.title, @JsonKey(name: 'diary_contents') this.content,  List<DiaryReactionResponse> diaryReactions = const []}): _diaryReactions = diaryReactions;
  factory _DiaryResponse.fromJson(Map<String, dynamic> json) => _$DiaryResponseFromJson(json);

@override final  String id;
@override final  String diaryBookId;
@override final  String authorId;
@override final  DateTime date;
@override@LocalDateTimeConverter() final  DateTime writtenAt;
/// 空ならタイトルなし。まだ読めない日記でも返る。
@override final  String title;
/// diary_id が主キーなので1対1になる。RLS で読めなければ null。
@override@JsonKey(name: 'diary_contents') final  DiaryContentResponse? content;
/// 付いたリアクション。
 final  List<DiaryReactionResponse> _diaryReactions;
/// 付いたリアクション。
@override@JsonKey() List<DiaryReactionResponse> get diaryReactions {
  if (_diaryReactions is EqualUnmodifiableListView) return _diaryReactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diaryReactions);
}


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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.diaryBookId, diaryBookId) || other.diaryBookId == diaryBookId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.writtenAt, writtenAt) || other.writtenAt == writtenAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.diaryReactions, _diaryReactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,diaryBookId,authorId,date,writtenAt,title,content,const DeepCollectionEquality().hash(_diaryReactions));
}

@override
String toString() {
    return 'DiaryResponse(id: $id, diaryBookId: $diaryBookId, authorId: $authorId, date: $date, writtenAt: $writtenAt, title: $title, content: $content, diaryReactions: $diaryReactions)';
}


}

/// @nodoc
abstract mixin class _$DiaryResponseCopyWith<$Res> implements $DiaryResponseCopyWith<$Res> {
  factory _$DiaryResponseCopyWith(_DiaryResponse value, $Res Function(_DiaryResponse) _then) = __$DiaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String diaryBookId, String authorId, DateTime date,@LocalDateTimeConverter() DateTime writtenAt, String title,@JsonKey(name: 'diary_contents') DiaryContentResponse? content, List<DiaryReactionResponse> diaryReactions
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? diaryBookId = null,Object? authorId = null,Object? date = null,Object? writtenAt = null,Object? title = null,Object? content = freezed,Object? diaryReactions = null,}) {
  return _then(_DiaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,diaryBookId: null == diaryBookId ? _self.diaryBookId : diaryBookId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,writtenAt: null == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as DiaryContentResponse?,diaryReactions: null == diaryReactions ? _self._diaryReactions : diaryReactions // ignore: cast_nullable_to_non_nullable
as List<DiaryReactionResponse>,
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

 String get body;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryContentResponse&&(identical(other.body, _this.body) || other.body == _this.body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryContentResponse;
  return Object.hash(runtimeType,_this.body);
}

@override
String toString() {
  final _this = this as DiaryContentResponse;
  return 'DiaryContentResponse(body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $DiaryContentResponseCopyWith<$Res>  {
  factory $DiaryContentResponseCopyWith(DiaryContentResponse value, $Res Function(DiaryContentResponse) _then) = _$DiaryContentResponseCopyWithImpl;
@useResult
$Res call({
 String body
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
@pragma('vm:prefer-inline') @override $Res call({Object? body = null,}) {
  return _then(DiaryContentResponse(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryContentResponse() when $default != null:
return $default(_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String body)  $default,) {final _that = this;
switch (_that) {
case _DiaryContentResponse():
return $default(_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String body)?  $default,) {final _that = this;
switch (_that) {
case _DiaryContentResponse() when $default != null:
return $default(_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryContentResponse implements DiaryContentResponse {
  const _DiaryContentResponse({required this.body});
  factory _DiaryContentResponse.fromJson(Map<String, dynamic> json) => _$DiaryContentResponseFromJson(json);

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryContentResponse&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,body);
}

@override
String toString() {
    return 'DiaryContentResponse(body: $body)';
}


}

/// @nodoc
abstract mixin class _$DiaryContentResponseCopyWith<$Res> implements $DiaryContentResponseCopyWith<$Res> {
  factory _$DiaryContentResponseCopyWith(_DiaryContentResponse value, $Res Function(_DiaryContentResponse) _then) = __$DiaryContentResponseCopyWithImpl;
@override @useResult
$Res call({
 String body
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
@override @pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(_DiaryContentResponse(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DiaryReactionResponse {

 String get userId; String get emoji;@LocalDateTimeConverter() DateTime get createdAt;
/// Create a copy of DiaryReactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryReactionResponseCopyWith<DiaryReactionResponse> get copyWith => _$DiaryReactionResponseCopyWithImpl<DiaryReactionResponse>(this as DiaryReactionResponse, _$identity);

  /// Serializes this DiaryReactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryReactionResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryReactionResponse&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.emoji, _this.emoji) || other.emoji == _this.emoji)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryReactionResponse;
  return Object.hash(runtimeType,_this.userId,_this.emoji,_this.createdAt);
}

@override
String toString() {
  final _this = this as DiaryReactionResponse;
  return 'DiaryReactionResponse(userId: ${_this.userId}, emoji: ${_this.emoji}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $DiaryReactionResponseCopyWith<$Res>  {
  factory $DiaryReactionResponseCopyWith(DiaryReactionResponse value, $Res Function(DiaryReactionResponse) _then) = _$DiaryReactionResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String emoji,@LocalDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$DiaryReactionResponseCopyWithImpl<$Res>
    implements $DiaryReactionResponseCopyWith<$Res> {
  _$DiaryReactionResponseCopyWithImpl(this._self, this._then);

  final DiaryReactionResponse _self;
  final $Res Function(DiaryReactionResponse) _then;

/// Create a copy of DiaryReactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? emoji = null,Object? createdAt = null,}) {
  return _then(DiaryReactionResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryReactionResponse].
extension DiaryReactionResponsePatterns on DiaryReactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryReactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryReactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryReactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _DiaryReactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryReactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryReactionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String emoji, @LocalDateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryReactionResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String emoji, @LocalDateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DiaryReactionResponse():
return $default(_that.userId,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String emoji, @LocalDateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DiaryReactionResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryReactionResponse implements DiaryReactionResponse {
  const _DiaryReactionResponse({required this.userId, required this.emoji, @LocalDateTimeConverter() required this.createdAt});
  factory _DiaryReactionResponse.fromJson(Map<String, dynamic> json) => _$DiaryReactionResponseFromJson(json);

@override final  String userId;
@override final  String emoji;
@override@LocalDateTimeConverter() final  DateTime createdAt;

/// Create a copy of DiaryReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryReactionResponseCopyWith<_DiaryReactionResponse> get copyWith => __$DiaryReactionResponseCopyWithImpl<_DiaryReactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryReactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryReactionResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,emoji,createdAt);
}

@override
String toString() {
    return 'DiaryReactionResponse(userId: $userId, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DiaryReactionResponseCopyWith<$Res> implements $DiaryReactionResponseCopyWith<$Res> {
  factory _$DiaryReactionResponseCopyWith(_DiaryReactionResponse value, $Res Function(_DiaryReactionResponse) _then) = __$DiaryReactionResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String emoji,@LocalDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$DiaryReactionResponseCopyWithImpl<$Res>
    implements _$DiaryReactionResponseCopyWith<$Res> {
  __$DiaryReactionResponseCopyWithImpl(this._self, this._then);

  final _DiaryReactionResponse _self;
  final $Res Function(_DiaryReactionResponse) _then;

/// Create a copy of DiaryReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? emoji = null,Object? createdAt = null,}) {
  return _then(_DiaryReactionResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
