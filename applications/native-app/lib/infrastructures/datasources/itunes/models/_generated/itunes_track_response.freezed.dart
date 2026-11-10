// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../itunes_track_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItunesTrackResponse {

 int get trackId; String get trackName; String get artistName; String get collectionName; String get trackViewUrl; int? get trackTimeMillis; String? get artworkUrl100; String? get previewUrl;
/// Create a copy of ItunesTrackResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItunesTrackResponseCopyWith<ItunesTrackResponse> get copyWith => _$ItunesTrackResponseCopyWithImpl<ItunesTrackResponse>(this as ItunesTrackResponse, _$identity);

  /// Serializes this ItunesTrackResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItunesTrackResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItunesTrackResponse&&(identical(other.trackId, _this.trackId) || other.trackId == _this.trackId)&&(identical(other.trackName, _this.trackName) || other.trackName == _this.trackName)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.collectionName, _this.collectionName) || other.collectionName == _this.collectionName)&&(identical(other.trackViewUrl, _this.trackViewUrl) || other.trackViewUrl == _this.trackViewUrl)&&(identical(other.trackTimeMillis, _this.trackTimeMillis) || other.trackTimeMillis == _this.trackTimeMillis)&&(identical(other.artworkUrl100, _this.artworkUrl100) || other.artworkUrl100 == _this.artworkUrl100)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItunesTrackResponse;
  return Object.hash(runtimeType,_this.trackId,_this.trackName,_this.artistName,_this.collectionName,_this.trackViewUrl,_this.trackTimeMillis,_this.artworkUrl100,_this.previewUrl);
}

@override
String toString() {
  final _this = this as ItunesTrackResponse;
  return 'ItunesTrackResponse(trackId: ${_this.trackId}, trackName: ${_this.trackName}, artistName: ${_this.artistName}, collectionName: ${_this.collectionName}, trackViewUrl: ${_this.trackViewUrl}, trackTimeMillis: ${_this.trackTimeMillis}, artworkUrl100: ${_this.artworkUrl100}, previewUrl: ${_this.previewUrl})';
}


}

/// @nodoc
abstract mixin class $ItunesTrackResponseCopyWith<$Res>  {
  factory $ItunesTrackResponseCopyWith(ItunesTrackResponse value, $Res Function(ItunesTrackResponse) _then) = _$ItunesTrackResponseCopyWithImpl;
@useResult
$Res call({
 int trackId, String trackName, String artistName, String collectionName, String trackViewUrl, int? trackTimeMillis, String? artworkUrl100, String? previewUrl
});




}
/// @nodoc
class _$ItunesTrackResponseCopyWithImpl<$Res>
    implements $ItunesTrackResponseCopyWith<$Res> {
  _$ItunesTrackResponseCopyWithImpl(this._self, this._then);

  final ItunesTrackResponse _self;
  final $Res Function(ItunesTrackResponse) _then;

/// Create a copy of ItunesTrackResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = null,Object? trackName = null,Object? artistName = null,Object? collectionName = null,Object? trackViewUrl = null,Object? trackTimeMillis = freezed,Object? artworkUrl100 = freezed,Object? previewUrl = freezed,}) {
  return _then(ItunesTrackResponse(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int,trackName: null == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,collectionName: null == collectionName ? _self.collectionName : collectionName // ignore: cast_nullable_to_non_nullable
as String,trackViewUrl: null == trackViewUrl ? _self.trackViewUrl : trackViewUrl // ignore: cast_nullable_to_non_nullable
as String,trackTimeMillis: freezed == trackTimeMillis ? _self.trackTimeMillis : trackTimeMillis // ignore: cast_nullable_to_non_nullable
as int?,artworkUrl100: freezed == artworkUrl100 ? _self.artworkUrl100 : artworkUrl100 // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItunesTrackResponse].
extension ItunesTrackResponsePatterns on ItunesTrackResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItunesTrackResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItunesTrackResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItunesTrackResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItunesTrackResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItunesTrackResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItunesTrackResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int trackId,  String trackName,  String artistName,  String collectionName,  String trackViewUrl,  int? trackTimeMillis,  String? artworkUrl100,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItunesTrackResponse() when $default != null:
return $default(_that.trackId,_that.trackName,_that.artistName,_that.collectionName,_that.trackViewUrl,_that.trackTimeMillis,_that.artworkUrl100,_that.previewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int trackId,  String trackName,  String artistName,  String collectionName,  String trackViewUrl,  int? trackTimeMillis,  String? artworkUrl100,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _ItunesTrackResponse():
return $default(_that.trackId,_that.trackName,_that.artistName,_that.collectionName,_that.trackViewUrl,_that.trackTimeMillis,_that.artworkUrl100,_that.previewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int trackId,  String trackName,  String artistName,  String collectionName,  String trackViewUrl,  int? trackTimeMillis,  String? artworkUrl100,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _ItunesTrackResponse() when $default != null:
return $default(_that.trackId,_that.trackName,_that.artistName,_that.collectionName,_that.trackViewUrl,_that.trackTimeMillis,_that.artworkUrl100,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.none)
class _ItunesTrackResponse implements ItunesTrackResponse {
  const _ItunesTrackResponse({required this.trackId, required this.trackName, required this.artistName, required this.collectionName, required this.trackViewUrl, this.trackTimeMillis, this.artworkUrl100, this.previewUrl});
  factory _ItunesTrackResponse.fromJson(Map<String, dynamic> json) => _$ItunesTrackResponseFromJson(json);

@override final  int trackId;
@override final  String trackName;
@override final  String artistName;
@override final  String collectionName;
@override final  String trackViewUrl;
@override final  int? trackTimeMillis;
@override final  String? artworkUrl100;
@override final  String? previewUrl;

/// Create a copy of ItunesTrackResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItunesTrackResponseCopyWith<_ItunesTrackResponse> get copyWith => __$ItunesTrackResponseCopyWithImpl<_ItunesTrackResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItunesTrackResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItunesTrackResponse&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackName, trackName) || other.trackName == trackName)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.collectionName, collectionName) || other.collectionName == collectionName)&&(identical(other.trackViewUrl, trackViewUrl) || other.trackViewUrl == trackViewUrl)&&(identical(other.trackTimeMillis, trackTimeMillis) || other.trackTimeMillis == trackTimeMillis)&&(identical(other.artworkUrl100, artworkUrl100) || other.artworkUrl100 == artworkUrl100)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,trackId,trackName,artistName,collectionName,trackViewUrl,trackTimeMillis,artworkUrl100,previewUrl);
}

@override
String toString() {
    return 'ItunesTrackResponse(trackId: $trackId, trackName: $trackName, artistName: $artistName, collectionName: $collectionName, trackViewUrl: $trackViewUrl, trackTimeMillis: $trackTimeMillis, artworkUrl100: $artworkUrl100, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$ItunesTrackResponseCopyWith<$Res> implements $ItunesTrackResponseCopyWith<$Res> {
  factory _$ItunesTrackResponseCopyWith(_ItunesTrackResponse value, $Res Function(_ItunesTrackResponse) _then) = __$ItunesTrackResponseCopyWithImpl;
@override @useResult
$Res call({
 int trackId, String trackName, String artistName, String collectionName, String trackViewUrl, int? trackTimeMillis, String? artworkUrl100, String? previewUrl
});




}
/// @nodoc
class __$ItunesTrackResponseCopyWithImpl<$Res>
    implements _$ItunesTrackResponseCopyWith<$Res> {
  __$ItunesTrackResponseCopyWithImpl(this._self, this._then);

  final _ItunesTrackResponse _self;
  final $Res Function(_ItunesTrackResponse) _then;

/// Create a copy of ItunesTrackResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = null,Object? trackName = null,Object? artistName = null,Object? collectionName = null,Object? trackViewUrl = null,Object? trackTimeMillis = freezed,Object? artworkUrl100 = freezed,Object? previewUrl = freezed,}) {
  return _then(_ItunesTrackResponse(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int,trackName: null == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,collectionName: null == collectionName ? _self.collectionName : collectionName // ignore: cast_nullable_to_non_nullable
as String,trackViewUrl: null == trackViewUrl ? _self.trackViewUrl : trackViewUrl // ignore: cast_nullable_to_non_nullable
as String,trackTimeMillis: freezed == trackTimeMillis ? _self.trackTimeMillis : trackTimeMillis // ignore: cast_nullable_to_non_nullable
as int?,artworkUrl100: freezed == artworkUrl100 ? _self.artworkUrl100 : artworkUrl100 // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
