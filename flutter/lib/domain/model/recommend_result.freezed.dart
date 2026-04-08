// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommend_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecommendResult {

 int get bggId; String get name; String get reason;
/// Create a copy of RecommendResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendResultCopyWith<RecommendResult> get copyWith => _$RecommendResultCopyWithImpl<RecommendResult>(this as RecommendResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendResult&&(identical(other.bggId, bggId) || other.bggId == bggId)&&(identical(other.name, name) || other.name == name)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,bggId,name,reason);

@override
String toString() {
  return 'RecommendResult(bggId: $bggId, name: $name, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RecommendResultCopyWith<$Res>  {
  factory $RecommendResultCopyWith(RecommendResult value, $Res Function(RecommendResult) _then) = _$RecommendResultCopyWithImpl;
@useResult
$Res call({
 int bggId, String name, String reason
});




}
/// @nodoc
class _$RecommendResultCopyWithImpl<$Res>
    implements $RecommendResultCopyWith<$Res> {
  _$RecommendResultCopyWithImpl(this._self, this._then);

  final RecommendResult _self;
  final $Res Function(RecommendResult) _then;

/// Create a copy of RecommendResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bggId = null,Object? name = null,Object? reason = null,}) {
  return _then(_self.copyWith(
bggId: null == bggId ? _self.bggId : bggId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendResult].
extension RecommendResultPatterns on RecommendResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendResult value)  $default,){
final _that = this;
switch (_that) {
case _RecommendResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendResult value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bggId,  String name,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendResult() when $default != null:
return $default(_that.bggId,_that.name,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bggId,  String name,  String reason)  $default,) {final _that = this;
switch (_that) {
case _RecommendResult():
return $default(_that.bggId,_that.name,_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bggId,  String name,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _RecommendResult() when $default != null:
return $default(_that.bggId,_that.name,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendResult implements RecommendResult {
  const _RecommendResult({required this.bggId, required this.name, required this.reason});
  

@override final  int bggId;
@override final  String name;
@override final  String reason;

/// Create a copy of RecommendResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendResultCopyWith<_RecommendResult> get copyWith => __$RecommendResultCopyWithImpl<_RecommendResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendResult&&(identical(other.bggId, bggId) || other.bggId == bggId)&&(identical(other.name, name) || other.name == name)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,bggId,name,reason);

@override
String toString() {
  return 'RecommendResult(bggId: $bggId, name: $name, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RecommendResultCopyWith<$Res> implements $RecommendResultCopyWith<$Res> {
  factory _$RecommendResultCopyWith(_RecommendResult value, $Res Function(_RecommendResult) _then) = __$RecommendResultCopyWithImpl;
@override @useResult
$Res call({
 int bggId, String name, String reason
});




}
/// @nodoc
class __$RecommendResultCopyWithImpl<$Res>
    implements _$RecommendResultCopyWith<$Res> {
  __$RecommendResultCopyWithImpl(this._self, this._then);

  final _RecommendResult _self;
  final $Res Function(_RecommendResult) _then;

/// Create a copy of RecommendResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bggId = null,Object? name = null,Object? reason = null,}) {
  return _then(_RecommendResult(
bggId: null == bggId ? _self.bggId : bggId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
