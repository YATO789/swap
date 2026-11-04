// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../timeline_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimelinePost {

 String get id; String get authorId; String get message; DateTime get postedAt;/// この日記帳で付いたリアクション。付けた順。1人1つ。
 List<PostReaction> get reactions;
/// Create a copy of TimelinePost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelinePostCopyWith<TimelinePost> get copyWith => _$TimelinePostCopyWithImpl<TimelinePost>(this as TimelinePost, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TimelinePost;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelinePost&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.postedAt, _this.postedAt) || other.postedAt == _this.postedAt)&&const DeepCollectionEquality().equals(other.reactions, _this.reactions));
}


@override
int get hashCode {
  final _this = this as TimelinePost;
  return Object.hash(runtimeType,_this.id,_this.authorId,_this.message,_this.postedAt,const DeepCollectionEquality().hash(_this.reactions));
}

@override
String toString() {
  final _this = this as TimelinePost;
  return 'TimelinePost(id: ${_this.id}, authorId: ${_this.authorId}, message: ${_this.message}, postedAt: ${_this.postedAt}, reactions: ${_this.reactions})';
}


}

/// @nodoc
abstract mixin class $TimelinePostCopyWith<$Res>  {
  factory $TimelinePostCopyWith(TimelinePost value, $Res Function(TimelinePost) _then) = _$TimelinePostCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, String message, DateTime postedAt, List<PostReaction> reactions
});




}
/// @nodoc
class _$TimelinePostCopyWithImpl<$Res>
    implements $TimelinePostCopyWith<$Res> {
  _$TimelinePostCopyWithImpl(this._self, this._then);

  final TimelinePost _self;
  final $Res Function(TimelinePost) _then;

/// Create a copy of TimelinePost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? message = null,Object? postedAt = null,Object? reactions = null,}) {
  return _then(TimelinePost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,postedAt: null == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<PostReaction>,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelinePost].
extension TimelinePostPatterns on TimelinePost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelinePost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelinePost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelinePost value)  $default,){
final _that = this;
switch (_that) {
case _TimelinePost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelinePost value)?  $default,){
final _that = this;
switch (_that) {
case _TimelinePost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  String message,  DateTime postedAt,  List<PostReaction> reactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelinePost() when $default != null:
return $default(_that.id,_that.authorId,_that.message,_that.postedAt,_that.reactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  String message,  DateTime postedAt,  List<PostReaction> reactions)  $default,) {final _that = this;
switch (_that) {
case _TimelinePost():
return $default(_that.id,_that.authorId,_that.message,_that.postedAt,_that.reactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  String message,  DateTime postedAt,  List<PostReaction> reactions)?  $default,) {final _that = this;
switch (_that) {
case _TimelinePost() when $default != null:
return $default(_that.id,_that.authorId,_that.message,_that.postedAt,_that.reactions);case _:
  return null;

}
}

}

/// @nodoc


class _TimelinePost extends TimelinePost {
  const _TimelinePost({required this.id, required this.authorId, required this.message, required this.postedAt,  List<PostReaction> reactions = const []}): _reactions = reactions,super._();
  

@override final  String id;
@override final  String authorId;
@override final  String message;
@override final  DateTime postedAt;
/// この日記帳で付いたリアクション。付けた順。1人1つ。
 final  List<PostReaction> _reactions;
/// この日記帳で付いたリアクション。付けた順。1人1つ。
@override@JsonKey() List<PostReaction> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}


/// Create a copy of TimelinePost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelinePostCopyWith<_TimelinePost> get copyWith => __$TimelinePostCopyWithImpl<_TimelinePost>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelinePost&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.message, message) || other.message == message)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&const DeepCollectionEquality().equals(other.reactions, _reactions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,authorId,message,postedAt,const DeepCollectionEquality().hash(_reactions));
}

@override
String toString() {
    return 'TimelinePost(id: $id, authorId: $authorId, message: $message, postedAt: $postedAt, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class _$TimelinePostCopyWith<$Res> implements $TimelinePostCopyWith<$Res> {
  factory _$TimelinePostCopyWith(_TimelinePost value, $Res Function(_TimelinePost) _then) = __$TimelinePostCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, String message, DateTime postedAt, List<PostReaction> reactions
});




}
/// @nodoc
class __$TimelinePostCopyWithImpl<$Res>
    implements _$TimelinePostCopyWith<$Res> {
  __$TimelinePostCopyWithImpl(this._self, this._then);

  final _TimelinePost _self;
  final $Res Function(_TimelinePost) _then;

/// Create a copy of TimelinePost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? message = null,Object? postedAt = null,Object? reactions = null,}) {
  return _then(_TimelinePost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,postedAt: null == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<PostReaction>,
  ));
}


}

/// @nodoc
mixin _$PostReaction {

 String get userId; String get emoji;
/// Create a copy of PostReaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostReactionCopyWith<PostReaction> get copyWith => _$PostReactionCopyWithImpl<PostReaction>(this as PostReaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PostReaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostReaction&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.emoji, _this.emoji) || other.emoji == _this.emoji));
}


@override
int get hashCode {
  final _this = this as PostReaction;
  return Object.hash(runtimeType,_this.userId,_this.emoji);
}

@override
String toString() {
  final _this = this as PostReaction;
  return 'PostReaction(userId: ${_this.userId}, emoji: ${_this.emoji})';
}


}

/// @nodoc
abstract mixin class $PostReactionCopyWith<$Res>  {
  factory $PostReactionCopyWith(PostReaction value, $Res Function(PostReaction) _then) = _$PostReactionCopyWithImpl;
@useResult
$Res call({
 String userId, String emoji
});




}
/// @nodoc
class _$PostReactionCopyWithImpl<$Res>
    implements $PostReactionCopyWith<$Res> {
  _$PostReactionCopyWithImpl(this._self, this._then);

  final PostReaction _self;
  final $Res Function(PostReaction) _then;

/// Create a copy of PostReaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? emoji = null,}) {
  return _then(PostReaction(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostReaction].
extension PostReactionPatterns on PostReaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostReaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostReaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostReaction value)  $default,){
final _that = this;
switch (_that) {
case _PostReaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostReaction value)?  $default,){
final _that = this;
switch (_that) {
case _PostReaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostReaction() when $default != null:
return $default(_that.userId,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String emoji)  $default,) {final _that = this;
switch (_that) {
case _PostReaction():
return $default(_that.userId,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String emoji)?  $default,) {final _that = this;
switch (_that) {
case _PostReaction() when $default != null:
return $default(_that.userId,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc


class _PostReaction implements PostReaction {
  const _PostReaction({required this.userId, required this.emoji});
  

@override final  String userId;
@override final  String emoji;

/// Create a copy of PostReaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostReactionCopyWith<_PostReaction> get copyWith => __$PostReactionCopyWithImpl<_PostReaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostReaction&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,emoji);
}

@override
String toString() {
    return 'PostReaction(userId: $userId, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$PostReactionCopyWith<$Res> implements $PostReactionCopyWith<$Res> {
  factory _$PostReactionCopyWith(_PostReaction value, $Res Function(_PostReaction) _then) = __$PostReactionCopyWithImpl;
@override @useResult
$Res call({
 String userId, String emoji
});




}
/// @nodoc
class __$PostReactionCopyWithImpl<$Res>
    implements _$PostReactionCopyWith<$Res> {
  __$PostReactionCopyWithImpl(this._self, this._then);

  final _PostReaction _self;
  final $Res Function(_PostReaction) _then;

/// Create a copy of PostReaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? emoji = null,}) {
  return _then(_PostReaction(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
