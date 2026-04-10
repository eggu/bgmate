// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LlmResponse {

 String get text;
/// Create a copy of LlmResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LlmResponseCopyWith<LlmResponse> get copyWith => _$LlmResponseCopyWithImpl<LlmResponse>(this as LlmResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LlmResponse&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'LlmResponse(text: $text)';
}


}

/// @nodoc
abstract mixin class $LlmResponseCopyWith<$Res>  {
  factory $LlmResponseCopyWith(LlmResponse value, $Res Function(LlmResponse) _then) = _$LlmResponseCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$LlmResponseCopyWithImpl<$Res>
    implements $LlmResponseCopyWith<$Res> {
  _$LlmResponseCopyWithImpl(this._self, this._then);

  final LlmResponse _self;
  final $Res Function(LlmResponse) _then;

/// Create a copy of LlmResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LlmResponse].
extension LlmResponsePatterns on LlmResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LlmResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LlmResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LlmResponse value)  $default,){
final _that = this;
switch (_that) {
case _LlmResponse():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LlmResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LlmResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LlmResponse() when $default != null:
return $default(_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text)  $default,) {final _that = this;
switch (_that) {
case _LlmResponse():
return $default(_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text)?  $default,) {final _that = this;
switch (_that) {
case _LlmResponse() when $default != null:
return $default(_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _LlmResponse implements LlmResponse {
  const _LlmResponse({required this.text});
  

@override final  String text;

/// Create a copy of LlmResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LlmResponseCopyWith<_LlmResponse> get copyWith => __$LlmResponseCopyWithImpl<_LlmResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LlmResponse&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'LlmResponse(text: $text)';
}


}

/// @nodoc
abstract mixin class _$LlmResponseCopyWith<$Res> implements $LlmResponseCopyWith<$Res> {
  factory _$LlmResponseCopyWith(_LlmResponse value, $Res Function(_LlmResponse) _then) = __$LlmResponseCopyWithImpl;
@override @useResult
$Res call({
 String text
});




}
/// @nodoc
class __$LlmResponseCopyWithImpl<$Res>
    implements _$LlmResponseCopyWith<$Res> {
  __$LlmResponseCopyWithImpl(this._self, this._then);

  final _LlmResponse _self;
  final $Res Function(_LlmResponse) _then;

/// Create a copy of LlmResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_LlmResponse(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
