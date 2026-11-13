// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../track_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackResponse {

 String get id; String get title; String get artist; String get album; int get durationMs; String get storeUrl; String? get artworkUrl; String? get previewUrl;
/// Create a copy of TrackResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackResponseCopyWith<TrackResponse> get copyWith => _$TrackResponseCopyWithImpl<TrackResponse>(this as TrackResponse, _$identity);

  /// Serializes this TrackResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.album, _this.album) || other.album == _this.album)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.storeUrl, _this.storeUrl) || other.storeUrl == _this.storeUrl)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackResponse;
  return Object.hash(runtimeType,_this.id,_this.title,_this.artist,_this.album,_this.durationMs,_this.storeUrl,_this.artworkUrl,_this.previewUrl);
}

@override
String toString() {
  final _this = this as TrackResponse;
  return 'TrackResponse(id: ${_this.id}, title: ${_this.title}, artist: ${_this.artist}, album: ${_this.album}, durationMs: ${_this.durationMs}, storeUrl: ${_this.storeUrl}, artworkUrl: ${_this.artworkUrl}, previewUrl: ${_this.previewUrl})';
}


}

/// @nodoc
abstract mixin class $TrackResponseCopyWith<$Res>  {
  factory $TrackResponseCopyWith(TrackResponse value, $Res Function(TrackResponse) _then) = _$TrackResponseCopyWithImpl;
@useResult
$Res call({
 String id, String title, String artist, String album, int durationMs, String storeUrl, String? artworkUrl, String? previewUrl
});




}
/// @nodoc
class _$TrackResponseCopyWithImpl<$Res>
    implements $TrackResponseCopyWith<$Res> {
  _$TrackResponseCopyWithImpl(this._self, this._then);

  final TrackResponse _self;
  final $Res Function(TrackResponse) _then;

/// Create a copy of TrackResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? album = null,Object? durationMs = null,Object? storeUrl = null,Object? artworkUrl = freezed,Object? previewUrl = freezed,}) {
  return _then(TrackResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackResponse].
extension TrackResponsePatterns on TrackResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackResponse value)  $default,){
final _that = this;
switch (_that) {
case _TrackResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TrackResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String album,  int durationMs,  String storeUrl,  String? artworkUrl,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackResponse() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.album,_that.durationMs,_that.storeUrl,_that.artworkUrl,_that.previewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String album,  int durationMs,  String storeUrl,  String? artworkUrl,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _TrackResponse():
return $default(_that.id,_that.title,_that.artist,_that.album,_that.durationMs,_that.storeUrl,_that.artworkUrl,_that.previewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String artist,  String album,  int durationMs,  String storeUrl,  String? artworkUrl,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _TrackResponse() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.album,_that.durationMs,_that.storeUrl,_that.artworkUrl,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackResponse implements TrackResponse {
  const _TrackResponse({required this.id, required this.title, required this.artist, required this.album, required this.durationMs, required this.storeUrl, this.artworkUrl, this.previewUrl});
  factory _TrackResponse.fromJson(Map<String, dynamic> json) => _$TrackResponseFromJson(json);

@override final  String id;
@override final  String title;
@override final  String artist;
@override final  String album;
@override final  int durationMs;
@override final  String storeUrl;
@override final  String? artworkUrl;
@override final  String? previewUrl;

/// Create a copy of TrackResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackResponseCopyWith<_TrackResponse> get copyWith => __$TrackResponseCopyWithImpl<_TrackResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.storeUrl, storeUrl) || other.storeUrl == storeUrl)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,artist,album,durationMs,storeUrl,artworkUrl,previewUrl);
}

@override
String toString() {
    return 'TrackResponse(id: $id, title: $title, artist: $artist, album: $album, durationMs: $durationMs, storeUrl: $storeUrl, artworkUrl: $artworkUrl, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$TrackResponseCopyWith<$Res> implements $TrackResponseCopyWith<$Res> {
  factory _$TrackResponseCopyWith(_TrackResponse value, $Res Function(_TrackResponse) _then) = __$TrackResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String artist, String album, int durationMs, String storeUrl, String? artworkUrl, String? previewUrl
});




}
/// @nodoc
class __$TrackResponseCopyWithImpl<$Res>
    implements _$TrackResponseCopyWith<$Res> {
  __$TrackResponseCopyWithImpl(this._self, this._then);

  final _TrackResponse _self;
  final $Res Function(_TrackResponse) _then;

/// Create a copy of TrackResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? album = null,Object? durationMs = null,Object? storeUrl = null,Object? artworkUrl = freezed,Object? previewUrl = freezed,}) {
  return _then(_TrackResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
