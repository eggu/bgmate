// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommend_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecommendCondition {

 int get playerCount; PlayTime get playTimeMinutes; Set<Mood> get moods;
/// Create a copy of RecommendCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendConditionCopyWith<RecommendCondition> get copyWith => _$RecommendConditionCopyWithImpl<RecommendCondition>(this as RecommendCondition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendCondition&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.playTimeMinutes, playTimeMinutes) || other.playTimeMinutes == playTimeMinutes)&&const DeepCollectionEquality().equals(other.moods, moods));
}


@override
int get hashCode => Object.hash(runtimeType,playerCount,playTimeMinutes,const DeepCollectionEquality().hash(moods));

@override
String toString() {
  return 'RecommendCondition(playerCount: $playerCount, playTimeMinutes: $playTimeMinutes, moods: $moods)';
}


}

/// @nodoc
abstract mixin class $RecommendConditionCopyWith<$Res>  {
  factory $RecommendConditionCopyWith(RecommendCondition value, $Res Function(RecommendCondition) _then) = _$RecommendConditionCopyWithImpl;
@useResult
$Res call({
 int playerCount, PlayTime playTimeMinutes, Set<Mood> moods
});




}
/// @nodoc
class _$RecommendConditionCopyWithImpl<$Res>
    implements $RecommendConditionCopyWith<$Res> {
  _$RecommendConditionCopyWithImpl(this._self, this._then);

  final RecommendCondition _self;
  final $Res Function(RecommendCondition) _then;

/// Create a copy of RecommendCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerCount = null,Object? playTimeMinutes = null,Object? moods = null,}) {
  return _then(_self.copyWith(
playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,playTimeMinutes: null == playTimeMinutes ? _self.playTimeMinutes : playTimeMinutes // ignore: cast_nullable_to_non_nullable
as PlayTime,moods: null == moods ? _self.moods : moods // ignore: cast_nullable_to_non_nullable
as Set<Mood>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendCondition].
extension RecommendConditionPatterns on RecommendCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendCondition value)  $default,){
final _that = this;
switch (_that) {
case _RecommendCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendCondition value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playerCount,  PlayTime playTimeMinutes,  Set<Mood> moods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendCondition() when $default != null:
return $default(_that.playerCount,_that.playTimeMinutes,_that.moods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playerCount,  PlayTime playTimeMinutes,  Set<Mood> moods)  $default,) {final _that = this;
switch (_that) {
case _RecommendCondition():
return $default(_that.playerCount,_that.playTimeMinutes,_that.moods);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playerCount,  PlayTime playTimeMinutes,  Set<Mood> moods)?  $default,) {final _that = this;
switch (_that) {
case _RecommendCondition() when $default != null:
return $default(_that.playerCount,_that.playTimeMinutes,_that.moods);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendCondition implements RecommendCondition {
  const _RecommendCondition({required this.playerCount, required this.playTimeMinutes, required final  Set<Mood> moods}): _moods = moods;
  

@override final  int playerCount;
@override final  PlayTime playTimeMinutes;
 final  Set<Mood> _moods;
@override Set<Mood> get moods {
  if (_moods is EqualUnmodifiableSetView) return _moods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_moods);
}


/// Create a copy of RecommendCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendConditionCopyWith<_RecommendCondition> get copyWith => __$RecommendConditionCopyWithImpl<_RecommendCondition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendCondition&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.playTimeMinutes, playTimeMinutes) || other.playTimeMinutes == playTimeMinutes)&&const DeepCollectionEquality().equals(other._moods, _moods));
}


@override
int get hashCode => Object.hash(runtimeType,playerCount,playTimeMinutes,const DeepCollectionEquality().hash(_moods));

@override
String toString() {
  return 'RecommendCondition(playerCount: $playerCount, playTimeMinutes: $playTimeMinutes, moods: $moods)';
}


}

/// @nodoc
abstract mixin class _$RecommendConditionCopyWith<$Res> implements $RecommendConditionCopyWith<$Res> {
  factory _$RecommendConditionCopyWith(_RecommendCondition value, $Res Function(_RecommendCondition) _then) = __$RecommendConditionCopyWithImpl;
@override @useResult
$Res call({
 int playerCount, PlayTime playTimeMinutes, Set<Mood> moods
});




}
/// @nodoc
class __$RecommendConditionCopyWithImpl<$Res>
    implements _$RecommendConditionCopyWith<$Res> {
  __$RecommendConditionCopyWithImpl(this._self, this._then);

  final _RecommendCondition _self;
  final $Res Function(_RecommendCondition) _then;

/// Create a copy of RecommendCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerCount = null,Object? playTimeMinutes = null,Object? moods = null,}) {
  return _then(_RecommendCondition(
playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,playTimeMinutes: null == playTimeMinutes ? _self.playTimeMinutes : playTimeMinutes // ignore: cast_nullable_to_non_nullable
as PlayTime,moods: null == moods ? _self._moods : moods // ignore: cast_nullable_to_non_nullable
as Set<Mood>,
  ));
}


}

// dart format on
