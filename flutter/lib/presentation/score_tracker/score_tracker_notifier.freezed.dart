// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_tracker_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScoreTrackerState {

 int get bggId; AsyncValue<BoardGame?> get game; List<PlayerScore> get players; bool get isSaving; bool get isSaved;
/// Create a copy of ScoreTrackerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreTrackerStateCopyWith<ScoreTrackerState> get copyWith => _$ScoreTrackerStateCopyWithImpl<ScoreTrackerState>(this as ScoreTrackerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreTrackerState&&(identical(other.bggId, bggId) || other.bggId == bggId)&&(identical(other.game, game) || other.game == game)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}


@override
int get hashCode => Object.hash(runtimeType,bggId,game,const DeepCollectionEquality().hash(players),isSaving,isSaved);

@override
String toString() {
  return 'ScoreTrackerState(bggId: $bggId, game: $game, players: $players, isSaving: $isSaving, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $ScoreTrackerStateCopyWith<$Res>  {
  factory $ScoreTrackerStateCopyWith(ScoreTrackerState value, $Res Function(ScoreTrackerState) _then) = _$ScoreTrackerStateCopyWithImpl;
@useResult
$Res call({
 int bggId, AsyncValue<BoardGame?> game, List<PlayerScore> players, bool isSaving, bool isSaved
});




}
/// @nodoc
class _$ScoreTrackerStateCopyWithImpl<$Res>
    implements $ScoreTrackerStateCopyWith<$Res> {
  _$ScoreTrackerStateCopyWithImpl(this._self, this._then);

  final ScoreTrackerState _self;
  final $Res Function(ScoreTrackerState) _then;

/// Create a copy of ScoreTrackerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bggId = null,Object? game = null,Object? players = null,Object? isSaving = null,Object? isSaved = null,}) {
  return _then(_self.copyWith(
bggId: null == bggId ? _self.bggId : bggId // ignore: cast_nullable_to_non_nullable
as int,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as AsyncValue<BoardGame?>,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<PlayerScore>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreTrackerState].
extension ScoreTrackerStatePatterns on ScoreTrackerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreTrackerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreTrackerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreTrackerState value)  $default,){
final _that = this;
switch (_that) {
case _ScoreTrackerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreTrackerState value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreTrackerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bggId,  AsyncValue<BoardGame?> game,  List<PlayerScore> players,  bool isSaving,  bool isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreTrackerState() when $default != null:
return $default(_that.bggId,_that.game,_that.players,_that.isSaving,_that.isSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bggId,  AsyncValue<BoardGame?> game,  List<PlayerScore> players,  bool isSaving,  bool isSaved)  $default,) {final _that = this;
switch (_that) {
case _ScoreTrackerState():
return $default(_that.bggId,_that.game,_that.players,_that.isSaving,_that.isSaved);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bggId,  AsyncValue<BoardGame?> game,  List<PlayerScore> players,  bool isSaving,  bool isSaved)?  $default,) {final _that = this;
switch (_that) {
case _ScoreTrackerState() when $default != null:
return $default(_that.bggId,_that.game,_that.players,_that.isSaving,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc


class _ScoreTrackerState extends ScoreTrackerState {
  const _ScoreTrackerState({required this.bggId, this.game = const AsyncValue.loading(), final  List<PlayerScore> players = const [], this.isSaving = false, this.isSaved = false}): _players = players,super._();
  

@override final  int bggId;
@override@JsonKey() final  AsyncValue<BoardGame?> game;
 final  List<PlayerScore> _players;
@override@JsonKey() List<PlayerScore> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isSaved;

/// Create a copy of ScoreTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreTrackerStateCopyWith<_ScoreTrackerState> get copyWith => __$ScoreTrackerStateCopyWithImpl<_ScoreTrackerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreTrackerState&&(identical(other.bggId, bggId) || other.bggId == bggId)&&(identical(other.game, game) || other.game == game)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}


@override
int get hashCode => Object.hash(runtimeType,bggId,game,const DeepCollectionEquality().hash(_players),isSaving,isSaved);

@override
String toString() {
  return 'ScoreTrackerState(bggId: $bggId, game: $game, players: $players, isSaving: $isSaving, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$ScoreTrackerStateCopyWith<$Res> implements $ScoreTrackerStateCopyWith<$Res> {
  factory _$ScoreTrackerStateCopyWith(_ScoreTrackerState value, $Res Function(_ScoreTrackerState) _then) = __$ScoreTrackerStateCopyWithImpl;
@override @useResult
$Res call({
 int bggId, AsyncValue<BoardGame?> game, List<PlayerScore> players, bool isSaving, bool isSaved
});




}
/// @nodoc
class __$ScoreTrackerStateCopyWithImpl<$Res>
    implements _$ScoreTrackerStateCopyWith<$Res> {
  __$ScoreTrackerStateCopyWithImpl(this._self, this._then);

  final _ScoreTrackerState _self;
  final $Res Function(_ScoreTrackerState) _then;

/// Create a copy of ScoreTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bggId = null,Object? game = null,Object? players = null,Object? isSaving = null,Object? isSaved = null,}) {
  return _then(_ScoreTrackerState(
bggId: null == bggId ? _self.bggId : bggId // ignore: cast_nullable_to_non_nullable
as int,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as AsyncValue<BoardGame?>,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<PlayerScore>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
