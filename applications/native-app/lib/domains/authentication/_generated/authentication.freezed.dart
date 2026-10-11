// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../authentication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Authentication {

 bool get isLoginApp;
/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationCopyWith<Authentication> get copyWith => _$AuthenticationCopyWithImpl<Authentication>(this as Authentication, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Authentication;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authentication&&(identical(other.isLoginApp, _this.isLoginApp) || other.isLoginApp == _this.isLoginApp));
}


@override
int get hashCode {
  final _this = this as Authentication;
  return Object.hash(runtimeType,_this.isLoginApp);
}

@override
String toString() {
  final _this = this as Authentication;
  return 'Authentication(isLoginApp: ${_this.isLoginApp})';
}


}

/// @nodoc
abstract mixin class $AuthenticationCopyWith<$Res>  {
  factory $AuthenticationCopyWith(Authentication value, $Res Function(Authentication) _then) = _$AuthenticationCopyWithImpl;
@useResult
$Res call({
 bool isLoginApp
});




}
/// @nodoc
class _$AuthenticationCopyWithImpl<$Res>
    implements $AuthenticationCopyWith<$Res> {
  _$AuthenticationCopyWithImpl(this._self, this._then);

  final Authentication _self;
  final $Res Function(Authentication) _then;

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoginApp = null,}) {
  return _then(Authentication(
isLoginApp: null == isLoginApp ? _self.isLoginApp : isLoginApp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Authentication].
extension AuthenticationPatterns on Authentication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Authentication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Authentication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Authentication value)  $default,){
final _that = this;
switch (_that) {
case _Authentication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Authentication value)?  $default,){
final _that = this;
switch (_that) {
case _Authentication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoginApp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Authentication() when $default != null:
return $default(_that.isLoginApp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoginApp)  $default,) {final _that = this;
switch (_that) {
case _Authentication():
return $default(_that.isLoginApp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoginApp)?  $default,) {final _that = this;
switch (_that) {
case _Authentication() when $default != null:
return $default(_that.isLoginApp);case _:
  return null;

}
}

}

/// @nodoc


class _Authentication implements Authentication {
  const _Authentication({this.isLoginApp = false});
  

@override@JsonKey() final  bool isLoginApp;

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticationCopyWith<_Authentication> get copyWith => __$AuthenticationCopyWithImpl<_Authentication>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authentication&&(identical(other.isLoginApp, isLoginApp) || other.isLoginApp == isLoginApp));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoginApp);
}

@override
String toString() {
    return 'Authentication(isLoginApp: $isLoginApp)';
}


}

/// @nodoc
abstract mixin class _$AuthenticationCopyWith<$Res> implements $AuthenticationCopyWith<$Res> {
  factory _$AuthenticationCopyWith(_Authentication value, $Res Function(_Authentication) _then) = __$AuthenticationCopyWithImpl;
@override @useResult
$Res call({
 bool isLoginApp
});




}
/// @nodoc
class __$AuthenticationCopyWithImpl<$Res>
    implements _$AuthenticationCopyWith<$Res> {
  __$AuthenticationCopyWithImpl(this._self, this._then);

  final _Authentication _self;
  final $Res Function(_Authentication) _then;

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoginApp = null,}) {
  return _then(_Authentication(
isLoginApp: null == isLoginApp ? _self.isLoginApp : isLoginApp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
