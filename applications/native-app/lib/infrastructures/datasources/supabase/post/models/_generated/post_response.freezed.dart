// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../post_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostResponse {

 String get id; String get authorId; String get message;@LocalDateTimeConverter() DateTime get postedAt; TrackResponse? get track;/// 日記帳を絞って読んだときの出し先。その日記帳の1つだけが入る。
 List<PostDiaryBookResponse> get postDiaryBooks;
/// Create a copy of PostResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostResponseCopyWith<PostResponse> get copyWith => _$PostResponseCopyWithImpl<PostResponse>(this as PostResponse, _$identity);

  /// Serializes this PostResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.postedAt, _this.postedAt) || other.postedAt == _this.postedAt)&&(identical(other.track, _this.track) || other.track == _this.track)&&const DeepCollectionEquality().equals(other.postDiaryBooks, _this.postDiaryBooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostResponse;
  return Object.hash(runtimeType,_this.id,_this.authorId,_this.message,_this.postedAt,_this.track,const DeepCollectionEquality().hash(_this.postDiaryBooks));
}

@override
String toString() {
  final _this = this as PostResponse;
  return 'PostResponse(id: ${_this.id}, authorId: ${_this.authorId}, message: ${_this.message}, postedAt: ${_this.postedAt}, track: ${_this.track}, postDiaryBooks: ${_this.postDiaryBooks})';
}


}

/// @nodoc
abstract mixin class $PostResponseCopyWith<$Res>  {
  factory $PostResponseCopyWith(PostResponse value, $Res Function(PostResponse) _then) = _$PostResponseCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, String message,@LocalDateTimeConverter() DateTime postedAt, TrackResponse? track, List<PostDiaryBookResponse> postDiaryBooks
});


$TrackResponseCopyWith<$Res>? get track;

}
/// @nodoc
class _$PostResponseCopyWithImpl<$Res>
    implements $PostResponseCopyWith<$Res> {
  _$PostResponseCopyWithImpl(this._self, this._then);

  final PostResponse _self;
  final $Res Function(PostResponse) _then;

/// Create a copy of PostResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? message = null,Object? postedAt = null,Object? track = freezed,Object? postDiaryBooks = null,}) {
  return _then(PostResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,postedAt: null == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as TrackResponse?,postDiaryBooks: null == postDiaryBooks ? _self.postDiaryBooks : postDiaryBooks // ignore: cast_nullable_to_non_nullable
as List<PostDiaryBookResponse>,
  ));
}
/// Create a copy of PostResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackResponseCopyWith<$Res>? get track {
    if (_self.track == null) {
    return null;
  }

  return $TrackResponseCopyWith<$Res>(_self.track!, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostResponse].
extension PostResponsePatterns on PostResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostResponse value)  $default,){
final _that = this;
switch (_that) {
case _PostResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PostResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  String message, @LocalDateTimeConverter()  DateTime postedAt,  TrackResponse? track,  List<PostDiaryBookResponse> postDiaryBooks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostResponse() when $default != null:
return $default(_that.id,_that.authorId,_that.message,_that.postedAt,_that.track,_that.postDiaryBooks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  String message, @LocalDateTimeConverter()  DateTime postedAt,  TrackResponse? track,  List<PostDiaryBookResponse> postDiaryBooks)  $default,) {final _that = this;
switch (_that) {
case _PostResponse():
return $default(_that.id,_that.authorId,_that.message,_that.postedAt,_that.track,_that.postDiaryBooks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  String message, @LocalDateTimeConverter()  DateTime postedAt,  TrackResponse? track,  List<PostDiaryBookResponse> postDiaryBooks)?  $default,) {final _that = this;
switch (_that) {
case _PostResponse() when $default != null:
return $default(_that.id,_that.authorId,_that.message,_that.postedAt,_that.track,_that.postDiaryBooks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostResponse implements PostResponse {
  const _PostResponse({required this.id, required this.authorId, required this.message, @LocalDateTimeConverter() required this.postedAt, this.track,  List<PostDiaryBookResponse> postDiaryBooks = const []}): _postDiaryBooks = postDiaryBooks;
  factory _PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);

@override final  String id;
@override final  String authorId;
@override final  String message;
@override@LocalDateTimeConverter() final  DateTime postedAt;
@override final  TrackResponse? track;
/// 日記帳を絞って読んだときの出し先。その日記帳の1つだけが入る。
 final  List<PostDiaryBookResponse> _postDiaryBooks;
/// 日記帳を絞って読んだときの出し先。その日記帳の1つだけが入る。
@override@JsonKey() List<PostDiaryBookResponse> get postDiaryBooks {
  if (_postDiaryBooks is EqualUnmodifiableListView) return _postDiaryBooks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postDiaryBooks);
}


/// Create a copy of PostResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostResponseCopyWith<_PostResponse> get copyWith => __$PostResponseCopyWithImpl<_PostResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.message, message) || other.message == message)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other.postDiaryBooks, _postDiaryBooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,authorId,message,postedAt,track,const DeepCollectionEquality().hash(_postDiaryBooks));
}

@override
String toString() {
    return 'PostResponse(id: $id, authorId: $authorId, message: $message, postedAt: $postedAt, track: $track, postDiaryBooks: $postDiaryBooks)';
}


}

/// @nodoc
abstract mixin class _$PostResponseCopyWith<$Res> implements $PostResponseCopyWith<$Res> {
  factory _$PostResponseCopyWith(_PostResponse value, $Res Function(_PostResponse) _then) = __$PostResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, String message,@LocalDateTimeConverter() DateTime postedAt, TrackResponse? track, List<PostDiaryBookResponse> postDiaryBooks
});


@override $TrackResponseCopyWith<$Res>? get track;

}
/// @nodoc
class __$PostResponseCopyWithImpl<$Res>
    implements _$PostResponseCopyWith<$Res> {
  __$PostResponseCopyWithImpl(this._self, this._then);

  final _PostResponse _self;
  final $Res Function(_PostResponse) _then;

/// Create a copy of PostResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? message = null,Object? postedAt = null,Object? track = freezed,Object? postDiaryBooks = null,}) {
  return _then(_PostResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,postedAt: null == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as TrackResponse?,postDiaryBooks: null == postDiaryBooks ? _self._postDiaryBooks : postDiaryBooks // ignore: cast_nullable_to_non_nullable
as List<PostDiaryBookResponse>,
  ));
}

/// Create a copy of PostResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackResponseCopyWith<$Res>? get track {
    if (_self.track == null) {
    return null;
  }

  return $TrackResponseCopyWith<$Res>(_self.track!, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// @nodoc
mixin _$PostDiaryBookResponse {

 List<PostReactionResponse> get postReactions; List<PostCommentResponse> get postComments;
/// Create a copy of PostDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDiaryBookResponseCopyWith<PostDiaryBookResponse> get copyWith => _$PostDiaryBookResponseCopyWithImpl<PostDiaryBookResponse>(this as PostDiaryBookResponse, _$identity);

  /// Serializes this PostDiaryBookResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostDiaryBookResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDiaryBookResponse&&const DeepCollectionEquality().equals(other.postReactions, _this.postReactions)&&const DeepCollectionEquality().equals(other.postComments, _this.postComments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostDiaryBookResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.postReactions),const DeepCollectionEquality().hash(_this.postComments));
}

@override
String toString() {
  final _this = this as PostDiaryBookResponse;
  return 'PostDiaryBookResponse(postReactions: ${_this.postReactions}, postComments: ${_this.postComments})';
}


}

/// @nodoc
abstract mixin class $PostDiaryBookResponseCopyWith<$Res>  {
  factory $PostDiaryBookResponseCopyWith(PostDiaryBookResponse value, $Res Function(PostDiaryBookResponse) _then) = _$PostDiaryBookResponseCopyWithImpl;
@useResult
$Res call({
 List<PostReactionResponse> postReactions, List<PostCommentResponse> postComments
});




}
/// @nodoc
class _$PostDiaryBookResponseCopyWithImpl<$Res>
    implements $PostDiaryBookResponseCopyWith<$Res> {
  _$PostDiaryBookResponseCopyWithImpl(this._self, this._then);

  final PostDiaryBookResponse _self;
  final $Res Function(PostDiaryBookResponse) _then;

/// Create a copy of PostDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postReactions = null,Object? postComments = null,}) {
  return _then(PostDiaryBookResponse(
postReactions: null == postReactions ? _self.postReactions : postReactions // ignore: cast_nullable_to_non_nullable
as List<PostReactionResponse>,postComments: null == postComments ? _self.postComments : postComments // ignore: cast_nullable_to_non_nullable
as List<PostCommentResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [PostDiaryBookResponse].
extension PostDiaryBookResponsePatterns on PostDiaryBookResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDiaryBookResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDiaryBookResponse value)  $default,){
final _that = this;
switch (_that) {
case _PostDiaryBookResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDiaryBookResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PostDiaryBookResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PostReactionResponse> postReactions,  List<PostCommentResponse> postComments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDiaryBookResponse() when $default != null:
return $default(_that.postReactions,_that.postComments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PostReactionResponse> postReactions,  List<PostCommentResponse> postComments)  $default,) {final _that = this;
switch (_that) {
case _PostDiaryBookResponse():
return $default(_that.postReactions,_that.postComments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PostReactionResponse> postReactions,  List<PostCommentResponse> postComments)?  $default,) {final _that = this;
switch (_that) {
case _PostDiaryBookResponse() when $default != null:
return $default(_that.postReactions,_that.postComments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostDiaryBookResponse implements PostDiaryBookResponse {
  const _PostDiaryBookResponse({ List<PostReactionResponse> postReactions = const [],  List<PostCommentResponse> postComments = const []}): _postReactions = postReactions,_postComments = postComments;
  factory _PostDiaryBookResponse.fromJson(Map<String, dynamic> json) => _$PostDiaryBookResponseFromJson(json);

 final  List<PostReactionResponse> _postReactions;
@override@JsonKey() List<PostReactionResponse> get postReactions {
  if (_postReactions is EqualUnmodifiableListView) return _postReactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postReactions);
}

 final  List<PostCommentResponse> _postComments;
@override@JsonKey() List<PostCommentResponse> get postComments {
  if (_postComments is EqualUnmodifiableListView) return _postComments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postComments);
}


/// Create a copy of PostDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDiaryBookResponseCopyWith<_PostDiaryBookResponse> get copyWith => __$PostDiaryBookResponseCopyWithImpl<_PostDiaryBookResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostDiaryBookResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDiaryBookResponse&&const DeepCollectionEquality().equals(other.postReactions, _postReactions)&&const DeepCollectionEquality().equals(other.postComments, _postComments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_postReactions),const DeepCollectionEquality().hash(_postComments));
}

@override
String toString() {
    return 'PostDiaryBookResponse(postReactions: $postReactions, postComments: $postComments)';
}


}

/// @nodoc
abstract mixin class _$PostDiaryBookResponseCopyWith<$Res> implements $PostDiaryBookResponseCopyWith<$Res> {
  factory _$PostDiaryBookResponseCopyWith(_PostDiaryBookResponse value, $Res Function(_PostDiaryBookResponse) _then) = __$PostDiaryBookResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PostReactionResponse> postReactions, List<PostCommentResponse> postComments
});




}
/// @nodoc
class __$PostDiaryBookResponseCopyWithImpl<$Res>
    implements _$PostDiaryBookResponseCopyWith<$Res> {
  __$PostDiaryBookResponseCopyWithImpl(this._self, this._then);

  final _PostDiaryBookResponse _self;
  final $Res Function(_PostDiaryBookResponse) _then;

/// Create a copy of PostDiaryBookResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postReactions = null,Object? postComments = null,}) {
  return _then(_PostDiaryBookResponse(
postReactions: null == postReactions ? _self._postReactions : postReactions // ignore: cast_nullable_to_non_nullable
as List<PostReactionResponse>,postComments: null == postComments ? _self._postComments : postComments // ignore: cast_nullable_to_non_nullable
as List<PostCommentResponse>,
  ));
}


}


/// @nodoc
mixin _$PostReactionResponse {

 String get userId; String get emoji;@LocalDateTimeConverter() DateTime get createdAt;
/// Create a copy of PostReactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostReactionResponseCopyWith<PostReactionResponse> get copyWith => _$PostReactionResponseCopyWithImpl<PostReactionResponse>(this as PostReactionResponse, _$identity);

  /// Serializes this PostReactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostReactionResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostReactionResponse&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.emoji, _this.emoji) || other.emoji == _this.emoji)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostReactionResponse;
  return Object.hash(runtimeType,_this.userId,_this.emoji,_this.createdAt);
}

@override
String toString() {
  final _this = this as PostReactionResponse;
  return 'PostReactionResponse(userId: ${_this.userId}, emoji: ${_this.emoji}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PostReactionResponseCopyWith<$Res>  {
  factory $PostReactionResponseCopyWith(PostReactionResponse value, $Res Function(PostReactionResponse) _then) = _$PostReactionResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String emoji,@LocalDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$PostReactionResponseCopyWithImpl<$Res>
    implements $PostReactionResponseCopyWith<$Res> {
  _$PostReactionResponseCopyWithImpl(this._self, this._then);

  final PostReactionResponse _self;
  final $Res Function(PostReactionResponse) _then;

/// Create a copy of PostReactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? emoji = null,Object? createdAt = null,}) {
  return _then(PostReactionResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PostReactionResponse].
extension PostReactionResponsePatterns on PostReactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostReactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostReactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostReactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _PostReactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostReactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PostReactionResponse() when $default != null:
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
case _PostReactionResponse() when $default != null:
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
case _PostReactionResponse():
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
case _PostReactionResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostReactionResponse implements PostReactionResponse {
  const _PostReactionResponse({required this.userId, required this.emoji, @LocalDateTimeConverter() required this.createdAt});
  factory _PostReactionResponse.fromJson(Map<String, dynamic> json) => _$PostReactionResponseFromJson(json);

@override final  String userId;
@override final  String emoji;
@override@LocalDateTimeConverter() final  DateTime createdAt;

/// Create a copy of PostReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostReactionResponseCopyWith<_PostReactionResponse> get copyWith => __$PostReactionResponseCopyWithImpl<_PostReactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostReactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostReactionResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,emoji,createdAt);
}

@override
String toString() {
    return 'PostReactionResponse(userId: $userId, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PostReactionResponseCopyWith<$Res> implements $PostReactionResponseCopyWith<$Res> {
  factory _$PostReactionResponseCopyWith(_PostReactionResponse value, $Res Function(_PostReactionResponse) _then) = __$PostReactionResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String emoji,@LocalDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$PostReactionResponseCopyWithImpl<$Res>
    implements _$PostReactionResponseCopyWith<$Res> {
  __$PostReactionResponseCopyWithImpl(this._self, this._then);

  final _PostReactionResponse _self;
  final $Res Function(_PostReactionResponse) _then;

/// Create a copy of PostReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? emoji = null,Object? createdAt = null,}) {
  return _then(_PostReactionResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PostCommentResponse {

 String get id; String get userId; String get message;@LocalDateTimeConverter() DateTime get createdAt;
/// Create a copy of PostCommentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCommentResponseCopyWith<PostCommentResponse> get copyWith => _$PostCommentResponseCopyWithImpl<PostCommentResponse>(this as PostCommentResponse, _$identity);

  /// Serializes this PostCommentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostCommentResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCommentResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostCommentResponse;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.message,_this.createdAt);
}

@override
String toString() {
  final _this = this as PostCommentResponse;
  return 'PostCommentResponse(id: ${_this.id}, userId: ${_this.userId}, message: ${_this.message}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PostCommentResponseCopyWith<$Res>  {
  factory $PostCommentResponseCopyWith(PostCommentResponse value, $Res Function(PostCommentResponse) _then) = _$PostCommentResponseCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String message,@LocalDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$PostCommentResponseCopyWithImpl<$Res>
    implements $PostCommentResponseCopyWith<$Res> {
  _$PostCommentResponseCopyWithImpl(this._self, this._then);

  final PostCommentResponse _self;
  final $Res Function(PostCommentResponse) _then;

/// Create a copy of PostCommentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? message = null,Object? createdAt = null,}) {
  return _then(PostCommentResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PostCommentResponse].
extension PostCommentResponsePatterns on PostCommentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCommentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCommentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCommentResponse value)  $default,){
final _that = this;
switch (_that) {
case _PostCommentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCommentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PostCommentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String message, @LocalDateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostCommentResponse() when $default != null:
return $default(_that.id,_that.userId,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String message, @LocalDateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PostCommentResponse():
return $default(_that.id,_that.userId,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String message, @LocalDateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PostCommentResponse() when $default != null:
return $default(_that.id,_that.userId,_that.message,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostCommentResponse implements PostCommentResponse {
  const _PostCommentResponse({required this.id, required this.userId, required this.message, @LocalDateTimeConverter() required this.createdAt});
  factory _PostCommentResponse.fromJson(Map<String, dynamic> json) => _$PostCommentResponseFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String message;
@override@LocalDateTimeConverter() final  DateTime createdAt;

/// Create a copy of PostCommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCommentResponseCopyWith<_PostCommentResponse> get copyWith => __$PostCommentResponseCopyWithImpl<_PostCommentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCommentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCommentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,message,createdAt);
}

@override
String toString() {
    return 'PostCommentResponse(id: $id, userId: $userId, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PostCommentResponseCopyWith<$Res> implements $PostCommentResponseCopyWith<$Res> {
  factory _$PostCommentResponseCopyWith(_PostCommentResponse value, $Res Function(_PostCommentResponse) _then) = __$PostCommentResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String message,@LocalDateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$PostCommentResponseCopyWithImpl<$Res>
    implements _$PostCommentResponseCopyWith<$Res> {
  __$PostCommentResponseCopyWithImpl(this._self, this._then);

  final _PostCommentResponse _self;
  final $Res Function(_PostCommentResponse) _then;

/// Create a copy of PostCommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? message = null,Object? createdAt = null,}) {
  return _then(_PostCommentResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
