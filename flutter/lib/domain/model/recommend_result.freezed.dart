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

 String get name; String get reason; bool get isOwned; double? get bggScore; String? get difficulty;
/// Create a copy of RecommendResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendResultCopyWith<RecommendResult> get copyWith => _$RecommendResultCopyWithImpl<RecommendResult>(this as RecommendResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendResult&&(identical(other.name, name) || other.name == name)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.bggScore, bggScore) || other.bggScore == bggScore)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}


@override
int get hashCode => Object.hash(runtimeType,name,reason,isOwned,bggScore,difficulty);

@override
String toString() {
  return 'RecommendResult(name: $name, reason: $reason, isOwned: $isOwned, bggScore: $bggScore, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class $RecommendResultCopyWith<$Res>  {
  factory $RecommendResultCopyWith(RecommendResult value, $Res Function(RecommendResult) _then) = _$RecommendResultCopyWithImpl;
@useResult
$Res call({
 String name, String reason, bool isOwned, double? bggScore, String? difficulty
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? reason = null,Object? isOwned = null,Object? bggScore = freezed,Object? difficulty = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,isOwned: null == isOwned ? _self.isOwned : isOwned // ignore: cast_nullable_to_non_nullable
as bool,bggScore: freezed == bggScore ? _self.bggScore : bggScore // ignore: cast_nullable_to_non_nullable
as double?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String reason,  bool isOwned,  double? bggScore,  String? difficulty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendResult() when $default != null:
return $default(_that.name,_that.reason,_that.isOwned,_that.bggScore,_that.difficulty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String reason,  bool isOwned,  double? bggScore,  String? difficulty)  $default,) {final _that = this;
switch (_that) {
case _RecommendResult():
return $default(_that.name,_that.reason,_that.isOwned,_that.bggScore,_that.difficulty);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String reason,  bool isOwned,  double? bggScore,  String? difficulty)?  $default,) {final _that = this;
switch (_that) {
case _RecommendResult() when $default != null:
return $default(_that.name,_that.reason,_that.isOwned,_that.bggScore,_that.difficulty);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendResult implements RecommendResult {
  const _RecommendResult({required this.name, required this.reason, required this.isOwned, this.bggScore = null, this.difficulty = null});
  

@override final  String name;
@override final  String reason;
@override final  bool isOwned;
@override@JsonKey() final  double? bggScore;
@override@JsonKey() final  String? difficulty;

/// Create a copy of RecommendResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendResultCopyWith<_RecommendResult> get copyWith => __$RecommendResultCopyWithImpl<_RecommendResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendResult&&(identical(other.name, name) || other.name == name)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.bggScore, bggScore) || other.bggScore == bggScore)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}


@override
int get hashCode => Object.hash(runtimeType,name,reason,isOwned,bggScore,difficulty);

@override
String toString() {
  return 'RecommendResult(name: $name, reason: $reason, isOwned: $isOwned, bggScore: $bggScore, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class _$RecommendResultCopyWith<$Res> implements $RecommendResultCopyWith<$Res> {
  factory _$RecommendResultCopyWith(_RecommendResult value, $Res Function(_RecommendResult) _then) = __$RecommendResultCopyWithImpl;
@override @useResult
$Res call({
 String name, String reason, bool isOwned, double? bggScore, String? difficulty
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? reason = null,Object? isOwned = null,Object? bggScore = freezed,Object? difficulty = freezed,}) {
  return _then(_RecommendResult(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,isOwned: null == isOwned ? _self.isOwned : isOwned // ignore: cast_nullable_to_non_nullable
as bool,bggScore: freezed == bggScore ? _self.bggScore : bggScore // ignore: cast_nullable_to_non_nullable
as double?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
