// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerScore {

 String get playerName; int get score; int get rank;
/// Create a copy of PlayerScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerScoreCopyWith<PlayerScore> get copyWith => _$PlayerScoreCopyWithImpl<PlayerScore>(this as PlayerScore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerScore&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.score, score) || other.score == score)&&(identical(other.rank, rank) || other.rank == rank));
}


@override
int get hashCode => Object.hash(runtimeType,playerName,score,rank);

@override
String toString() {
  return 'PlayerScore(playerName: $playerName, score: $score, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $PlayerScoreCopyWith<$Res>  {
  factory $PlayerScoreCopyWith(PlayerScore value, $Res Function(PlayerScore) _then) = _$PlayerScoreCopyWithImpl;
@useResult
$Res call({
 String playerName, int score, int rank
});




}
/// @nodoc
class _$PlayerScoreCopyWithImpl<$Res>
    implements $PlayerScoreCopyWith<$Res> {
  _$PlayerScoreCopyWithImpl(this._self, this._then);

  final PlayerScore _self;
  final $Res Function(PlayerScore) _then;

/// Create a copy of PlayerScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerName = null,Object? score = null,Object? rank = null,}) {
  return _then(_self.copyWith(
playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerScore].
extension PlayerScorePatterns on PlayerScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerScore value)  $default,){
final _that = this;
switch (_that) {
case _PlayerScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerScore value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerName,  int score,  int rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerScore() when $default != null:
return $default(_that.playerName,_that.score,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerName,  int score,  int rank)  $default,) {final _that = this;
switch (_that) {
case _PlayerScore():
return $default(_that.playerName,_that.score,_that.rank);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerName,  int score,  int rank)?  $default,) {final _that = this;
switch (_that) {
case _PlayerScore() when $default != null:
return $default(_that.playerName,_that.score,_that.rank);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerScore implements PlayerScore {
  const _PlayerScore({required this.playerName, required this.score, this.rank = 0});
  

@override final  String playerName;
@override final  int score;
@override@JsonKey() final  int rank;

/// Create a copy of PlayerScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerScoreCopyWith<_PlayerScore> get copyWith => __$PlayerScoreCopyWithImpl<_PlayerScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerScore&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.score, score) || other.score == score)&&(identical(other.rank, rank) || other.rank == rank));
}


@override
int get hashCode => Object.hash(runtimeType,playerName,score,rank);

@override
String toString() {
  return 'PlayerScore(playerName: $playerName, score: $score, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$PlayerScoreCopyWith<$Res> implements $PlayerScoreCopyWith<$Res> {
  factory _$PlayerScoreCopyWith(_PlayerScore value, $Res Function(_PlayerScore) _then) = __$PlayerScoreCopyWithImpl;
@override @useResult
$Res call({
 String playerName, int score, int rank
});




}
/// @nodoc
class __$PlayerScoreCopyWithImpl<$Res>
    implements _$PlayerScoreCopyWith<$Res> {
  __$PlayerScoreCopyWithImpl(this._self, this._then);

  final _PlayerScore _self;
  final $Res Function(_PlayerScore) _then;

/// Create a copy of PlayerScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerName = null,Object? score = null,Object? rank = null,}) {
  return _then(_PlayerScore(
playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
