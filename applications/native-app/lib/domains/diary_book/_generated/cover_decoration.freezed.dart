// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../cover_decoration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoverDecoration {

/// 飾りの形の番号。[coverDecorationVersion] より大きければ、新しいアプリで飾ったもの。
 int get version;/// 貼ったもの。後ろほど上に重なる。
 List<CoverSticker> get stickers;/// らくがきの線。描いた順に重ね、貼ったものすべての上に出す。
 List<CoverStroke> get strokes;
/// Create a copy of CoverDecoration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverDecorationCopyWith<CoverDecoration> get copyWith => _$CoverDecorationCopyWithImpl<CoverDecoration>(this as CoverDecoration, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CoverDecoration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverDecoration&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.stickers, _this.stickers)&&const DeepCollectionEquality().equals(other.strokes, _this.strokes));
}


@override
int get hashCode {
  final _this = this as CoverDecoration;
  return Object.hash(runtimeType,_this.version,const DeepCollectionEquality().hash(_this.stickers),const DeepCollectionEquality().hash(_this.strokes));
}

@override
String toString() {
  final _this = this as CoverDecoration;
  return 'CoverDecoration(version: ${_this.version}, stickers: ${_this.stickers}, strokes: ${_this.strokes})';
}


}

/// @nodoc
abstract mixin class $CoverDecorationCopyWith<$Res>  {
  factory $CoverDecorationCopyWith(CoverDecoration value, $Res Function(CoverDecoration) _then) = _$CoverDecorationCopyWithImpl;
@useResult
$Res call({
 int version, List<CoverSticker> stickers, List<CoverStroke> strokes
});




}
/// @nodoc
class _$CoverDecorationCopyWithImpl<$Res>
    implements $CoverDecorationCopyWith<$Res> {
  _$CoverDecorationCopyWithImpl(this._self, this._then);

  final CoverDecoration _self;
  final $Res Function(CoverDecoration) _then;

/// Create a copy of CoverDecoration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? stickers = null,Object? strokes = null,}) {
  return _then(CoverDecoration(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,stickers: null == stickers ? _self.stickers : stickers // ignore: cast_nullable_to_non_nullable
as List<CoverSticker>,strokes: null == strokes ? _self.strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<CoverStroke>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoverDecoration].
extension CoverDecorationPatterns on CoverDecoration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverDecoration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverDecoration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverDecoration value)  $default,){
final _that = this;
switch (_that) {
case _CoverDecoration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverDecoration value)?  $default,){
final _that = this;
switch (_that) {
case _CoverDecoration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<CoverSticker> stickers,  List<CoverStroke> strokes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoverDecoration() when $default != null:
return $default(_that.version,_that.stickers,_that.strokes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<CoverSticker> stickers,  List<CoverStroke> strokes)  $default,) {final _that = this;
switch (_that) {
case _CoverDecoration():
return $default(_that.version,_that.stickers,_that.strokes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<CoverSticker> stickers,  List<CoverStroke> strokes)?  $default,) {final _that = this;
switch (_that) {
case _CoverDecoration() when $default != null:
return $default(_that.version,_that.stickers,_that.strokes);case _:
  return null;

}
}

}

/// @nodoc


class _CoverDecoration extends CoverDecoration {
  const _CoverDecoration({this.version = coverDecorationVersion,  List<CoverSticker> stickers = const <CoverSticker>[],  List<CoverStroke> strokes = const <CoverStroke>[]}): _stickers = stickers,_strokes = strokes,super._();
  

/// 飾りの形の番号。[coverDecorationVersion] より大きければ、新しいアプリで飾ったもの。
@override@JsonKey() final  int version;
/// 貼ったもの。後ろほど上に重なる。
 final  List<CoverSticker> _stickers;
/// 貼ったもの。後ろほど上に重なる。
@override@JsonKey() List<CoverSticker> get stickers {
  if (_stickers is EqualUnmodifiableListView) return _stickers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stickers);
}

/// らくがきの線。描いた順に重ね、貼ったものすべての上に出す。
 final  List<CoverStroke> _strokes;
/// らくがきの線。描いた順に重ね、貼ったものすべての上に出す。
@override@JsonKey() List<CoverStroke> get strokes {
  if (_strokes is EqualUnmodifiableListView) return _strokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strokes);
}


/// Create a copy of CoverDecoration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverDecorationCopyWith<_CoverDecoration> get copyWith => __$CoverDecorationCopyWithImpl<_CoverDecoration>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverDecoration&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.stickers, _stickers)&&const DeepCollectionEquality().equals(other.strokes, _strokes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_stickers),const DeepCollectionEquality().hash(_strokes));
}

@override
String toString() {
    return 'CoverDecoration(version: $version, stickers: $stickers, strokes: $strokes)';
}


}

/// @nodoc
abstract mixin class _$CoverDecorationCopyWith<$Res> implements $CoverDecorationCopyWith<$Res> {
  factory _$CoverDecorationCopyWith(_CoverDecoration value, $Res Function(_CoverDecoration) _then) = __$CoverDecorationCopyWithImpl;
@override @useResult
$Res call({
 int version, List<CoverSticker> stickers, List<CoverStroke> strokes
});




}
/// @nodoc
class __$CoverDecorationCopyWithImpl<$Res>
    implements _$CoverDecorationCopyWith<$Res> {
  __$CoverDecorationCopyWithImpl(this._self, this._then);

  final _CoverDecoration _self;
  final $Res Function(_CoverDecoration) _then;

/// Create a copy of CoverDecoration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? stickers = null,Object? strokes = null,}) {
  return _then(_CoverDecoration(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,stickers: null == stickers ? _self._stickers : stickers // ignore: cast_nullable_to_non_nullable
as List<CoverSticker>,strokes: null == strokes ? _self._strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<CoverStroke>,
  ));
}


}

/// @nodoc
mixin _$CoverSticker {

/// 絵文字。絵文字でなければ null。
 String? get emoji;/// 置いた文字。文字でなければ null。改行で何行かにできる。
 String? get text;/// 日記帳の名前か。
 bool get isName;/// 中心の位置。
 double get x; double get y;/// 幅（白いふちを含む）。
 double get size;/// 回転（ラジアン、時計回り）。
 double get rotation;/// 白いふちを付けるか。
 bool get frame;/// 文字と名前の色（0xAARRGGBB）。null なら表紙の色に合わせて黒か白にする。絵文字では使わない。
 int? get color;
/// Create a copy of CoverSticker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverStickerCopyWith<CoverSticker> get copyWith => _$CoverStickerCopyWithImpl<CoverSticker>(this as CoverSticker, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CoverSticker;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverSticker&&(identical(other.emoji, _this.emoji) || other.emoji == _this.emoji)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.isName, _this.isName) || other.isName == _this.isName)&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.rotation, _this.rotation) || other.rotation == _this.rotation)&&(identical(other.frame, _this.frame) || other.frame == _this.frame)&&(identical(other.color, _this.color) || other.color == _this.color));
}


@override
int get hashCode {
  final _this = this as CoverSticker;
  return Object.hash(runtimeType,_this.emoji,_this.text,_this.isName,_this.x,_this.y,_this.size,_this.rotation,_this.frame,_this.color);
}

@override
String toString() {
  final _this = this as CoverSticker;
  return 'CoverSticker(emoji: ${_this.emoji}, text: ${_this.text}, isName: ${_this.isName}, x: ${_this.x}, y: ${_this.y}, size: ${_this.size}, rotation: ${_this.rotation}, frame: ${_this.frame}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $CoverStickerCopyWith<$Res>  {
  factory $CoverStickerCopyWith(CoverSticker value, $Res Function(CoverSticker) _then) = _$CoverStickerCopyWithImpl;
@useResult
$Res call({
 String? emoji, String? text, bool isName, double x, double y, double size, double rotation, bool frame, int? color
});




}
/// @nodoc
class _$CoverStickerCopyWithImpl<$Res>
    implements $CoverStickerCopyWith<$Res> {
  _$CoverStickerCopyWithImpl(this._self, this._then);

  final CoverSticker _self;
  final $Res Function(CoverSticker) _then;

/// Create a copy of CoverSticker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = freezed,Object? text = freezed,Object? isName = null,Object? x = null,Object? y = null,Object? size = null,Object? rotation = null,Object? frame = null,Object? color = freezed,}) {
  return _then(CoverSticker(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,isName: null == isName ? _self.isName : isName // ignore: cast_nullable_to_non_nullable
as bool,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as bool,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoverSticker].
extension CoverStickerPatterns on CoverSticker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverSticker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverSticker() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverSticker value)  $default,){
final _that = this;
switch (_that) {
case _CoverSticker():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverSticker value)?  $default,){
final _that = this;
switch (_that) {
case _CoverSticker() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? emoji,  String? text,  bool isName,  double x,  double y,  double size,  double rotation,  bool frame,  int? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoverSticker() when $default != null:
return $default(_that.emoji,_that.text,_that.isName,_that.x,_that.y,_that.size,_that.rotation,_that.frame,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? emoji,  String? text,  bool isName,  double x,  double y,  double size,  double rotation,  bool frame,  int? color)  $default,) {final _that = this;
switch (_that) {
case _CoverSticker():
return $default(_that.emoji,_that.text,_that.isName,_that.x,_that.y,_that.size,_that.rotation,_that.frame,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? emoji,  String? text,  bool isName,  double x,  double y,  double size,  double rotation,  bool frame,  int? color)?  $default,) {final _that = this;
switch (_that) {
case _CoverSticker() when $default != null:
return $default(_that.emoji,_that.text,_that.isName,_that.x,_that.y,_that.size,_that.rotation,_that.frame,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _CoverSticker extends CoverSticker {
  const _CoverSticker({this.emoji, this.text, this.isName = false, required this.x, required this.y, required this.size, this.rotation = 0, this.frame = true, this.color}): super._();
  

/// 絵文字。絵文字でなければ null。
@override final  String? emoji;
/// 置いた文字。文字でなければ null。改行で何行かにできる。
@override final  String? text;
/// 日記帳の名前か。
@override@JsonKey() final  bool isName;
/// 中心の位置。
@override final  double x;
@override final  double y;
/// 幅（白いふちを含む）。
@override final  double size;
/// 回転（ラジアン、時計回り）。
@override@JsonKey() final  double rotation;
/// 白いふちを付けるか。
@override@JsonKey() final  bool frame;
/// 文字と名前の色（0xAARRGGBB）。null なら表紙の色に合わせて黒か白にする。絵文字では使わない。
@override final  int? color;

/// Create a copy of CoverSticker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverStickerCopyWith<_CoverSticker> get copyWith => __$CoverStickerCopyWithImpl<_CoverSticker>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverSticker&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.isName, isName) || other.isName == isName)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.size, size) || other.size == size)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.frame, frame) || other.frame == frame)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode {
    return Object.hash(runtimeType,emoji,text,isName,x,y,size,rotation,frame,color);
}

@override
String toString() {
    return 'CoverSticker(emoji: $emoji, text: $text, isName: $isName, x: $x, y: $y, size: $size, rotation: $rotation, frame: $frame, color: $color)';
}


}

/// @nodoc
abstract mixin class _$CoverStickerCopyWith<$Res> implements $CoverStickerCopyWith<$Res> {
  factory _$CoverStickerCopyWith(_CoverSticker value, $Res Function(_CoverSticker) _then) = __$CoverStickerCopyWithImpl;
@override @useResult
$Res call({
 String? emoji, String? text, bool isName, double x, double y, double size, double rotation, bool frame, int? color
});




}
/// @nodoc
class __$CoverStickerCopyWithImpl<$Res>
    implements _$CoverStickerCopyWith<$Res> {
  __$CoverStickerCopyWithImpl(this._self, this._then);

  final _CoverSticker _self;
  final $Res Function(_CoverSticker) _then;

/// Create a copy of CoverSticker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = freezed,Object? text = freezed,Object? isName = null,Object? x = null,Object? y = null,Object? size = null,Object? rotation = null,Object? frame = null,Object? color = freezed,}) {
  return _then(_CoverSticker(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,isName: null == isName ? _self.isName : isName // ignore: cast_nullable_to_non_nullable
as bool,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as bool,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$CoverStroke {

/// 線の色（0xAARRGGBB）。
 int get color;/// 線の太さ。
 double get width;/// 線が通る点。
 List<Offset> get points;
/// Create a copy of CoverStroke
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverStrokeCopyWith<CoverStroke> get copyWith => _$CoverStrokeCopyWithImpl<CoverStroke>(this as CoverStroke, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CoverStroke;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverStroke&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.width, _this.width) || other.width == _this.width)&&const DeepCollectionEquality().equals(other.points, _this.points));
}


@override
int get hashCode {
  final _this = this as CoverStroke;
  return Object.hash(runtimeType,_this.color,_this.width,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as CoverStroke;
  return 'CoverStroke(color: ${_this.color}, width: ${_this.width}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $CoverStrokeCopyWith<$Res>  {
  factory $CoverStrokeCopyWith(CoverStroke value, $Res Function(CoverStroke) _then) = _$CoverStrokeCopyWithImpl;
@useResult
$Res call({
 int color, double width, List<Offset> points
});




}
/// @nodoc
class _$CoverStrokeCopyWithImpl<$Res>
    implements $CoverStrokeCopyWith<$Res> {
  _$CoverStrokeCopyWithImpl(this._self, this._then);

  final CoverStroke _self;
  final $Res Function(CoverStroke) _then;

/// Create a copy of CoverStroke
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,Object? width = null,Object? points = null,}) {
  return _then(CoverStroke(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<Offset>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoverStroke].
extension CoverStrokePatterns on CoverStroke {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverStroke value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverStroke() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverStroke value)  $default,){
final _that = this;
switch (_that) {
case _CoverStroke():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverStroke value)?  $default,){
final _that = this;
switch (_that) {
case _CoverStroke() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int color,  double width,  List<Offset> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoverStroke() when $default != null:
return $default(_that.color,_that.width,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int color,  double width,  List<Offset> points)  $default,) {final _that = this;
switch (_that) {
case _CoverStroke():
return $default(_that.color,_that.width,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int color,  double width,  List<Offset> points)?  $default,) {final _that = this;
switch (_that) {
case _CoverStroke() when $default != null:
return $default(_that.color,_that.width,_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _CoverStroke extends CoverStroke {
  const _CoverStroke({required this.color, required this.width, required  List<Offset> points}): _points = points,super._();
  

/// 線の色（0xAARRGGBB）。
@override final  int color;
/// 線の太さ。
@override final  double width;
/// 線が通る点。
 final  List<Offset> _points;
/// 線が通る点。
@override List<Offset> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of CoverStroke
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverStrokeCopyWith<_CoverStroke> get copyWith => __$CoverStrokeCopyWithImpl<_CoverStroke>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverStroke&&(identical(other.color, color) || other.color == color)&&(identical(other.width, width) || other.width == width)&&const DeepCollectionEquality().equals(other.points, _points));
}


@override
int get hashCode {
    return Object.hash(runtimeType,color,width,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'CoverStroke(color: $color, width: $width, points: $points)';
}


}

/// @nodoc
abstract mixin class _$CoverStrokeCopyWith<$Res> implements $CoverStrokeCopyWith<$Res> {
  factory _$CoverStrokeCopyWith(_CoverStroke value, $Res Function(_CoverStroke) _then) = __$CoverStrokeCopyWithImpl;
@override @useResult
$Res call({
 int color, double width, List<Offset> points
});




}
/// @nodoc
class __$CoverStrokeCopyWithImpl<$Res>
    implements _$CoverStrokeCopyWith<$Res> {
  __$CoverStrokeCopyWithImpl(this._self, this._then);

  final _CoverStroke _self;
  final $Res Function(_CoverStroke) _then;

/// Create a copy of CoverStroke
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,Object? width = null,Object? points = null,}) {
  return _then(_CoverStroke(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<Offset>,
  ));
}


}

// dart format on
