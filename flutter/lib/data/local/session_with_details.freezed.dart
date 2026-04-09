// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_with_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionWithDetails {

 SessionRecord get session; BoardGameRecord get game; List<ScoreWithPlayer> get scores;
/// Create a copy of SessionWithDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionWithDetailsCopyWith<SessionWithDetails> get copyWith => _$SessionWithDetailsCopyWithImpl<SessionWithDetails>(this as SessionWithDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionWithDetails&&const DeepCollectionEquality().equals(other.session, session)&&const DeepCollectionEquality().equals(other.game, game)&&const DeepCollectionEquality().equals(other.scores, scores));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(session),const DeepCollectionEquality().hash(game),const DeepCollectionEquality().hash(scores));

@override
String toString() {
  return 'SessionWithDetails(session: $session, game: $game, scores: $scores)';
}


}

/// @nodoc
abstract mixin class $SessionWithDetailsCopyWith<$Res>  {
  factory $SessionWithDetailsCopyWith(SessionWithDetails value, $Res Function(SessionWithDetails) _then) = _$SessionWithDetailsCopyWithImpl;
@useResult
$Res call({
 SessionRecord session, BoardGameRecord game, List<ScoreWithPlayer> scores
});




}
/// @nodoc
class _$SessionWithDetailsCopyWithImpl<$Res>
    implements $SessionWithDetailsCopyWith<$Res> {
  _$SessionWithDetailsCopyWithImpl(this._self, this._then);

  final SessionWithDetails _self;
  final $Res Function(SessionWithDetails) _then;

/// Create a copy of SessionWithDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = freezed,Object? game = freezed,Object? scores = null,}) {
  return _then(_self.copyWith(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionRecord,game: freezed == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as BoardGameRecord,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as List<ScoreWithPlayer>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionWithDetails].
extension SessionWithDetailsPatterns on SessionWithDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionWithDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionWithDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionWithDetails value)  $default,){
final _that = this;
switch (_that) {
case _SessionWithDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionWithDetails value)?  $default,){
final _that = this;
switch (_that) {
case _SessionWithDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionRecord session,  BoardGameRecord game,  List<ScoreWithPlayer> scores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionWithDetails() when $default != null:
return $default(_that.session,_that.game,_that.scores);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionRecord session,  BoardGameRecord game,  List<ScoreWithPlayer> scores)  $default,) {final _that = this;
switch (_that) {
case _SessionWithDetails():
return $default(_that.session,_that.game,_that.scores);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionRecord session,  BoardGameRecord game,  List<ScoreWithPlayer> scores)?  $default,) {final _that = this;
switch (_that) {
case _SessionWithDetails() when $default != null:
return $default(_that.session,_that.game,_that.scores);case _:
  return null;

}
}

}

/// @nodoc


class _SessionWithDetails implements SessionWithDetails {
  const _SessionWithDetails({required this.session, required this.game, required final  List<ScoreWithPlayer> scores}): _scores = scores;
  

@override final  SessionRecord session;
@override final  BoardGameRecord game;
 final  List<ScoreWithPlayer> _scores;
@override List<ScoreWithPlayer> get scores {
  if (_scores is EqualUnmodifiableListView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scores);
}


/// Create a copy of SessionWithDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionWithDetailsCopyWith<_SessionWithDetails> get copyWith => __$SessionWithDetailsCopyWithImpl<_SessionWithDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionWithDetails&&const DeepCollectionEquality().equals(other.session, session)&&const DeepCollectionEquality().equals(other.game, game)&&const DeepCollectionEquality().equals(other._scores, _scores));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(session),const DeepCollectionEquality().hash(game),const DeepCollectionEquality().hash(_scores));

@override
String toString() {
  return 'SessionWithDetails(session: $session, game: $game, scores: $scores)';
}


}

/// @nodoc
abstract mixin class _$SessionWithDetailsCopyWith<$Res> implements $SessionWithDetailsCopyWith<$Res> {
  factory _$SessionWithDetailsCopyWith(_SessionWithDetails value, $Res Function(_SessionWithDetails) _then) = __$SessionWithDetailsCopyWithImpl;
@override @useResult
$Res call({
 SessionRecord session, BoardGameRecord game, List<ScoreWithPlayer> scores
});




}
/// @nodoc
class __$SessionWithDetailsCopyWithImpl<$Res>
    implements _$SessionWithDetailsCopyWith<$Res> {
  __$SessionWithDetailsCopyWithImpl(this._self, this._then);

  final _SessionWithDetails _self;
  final $Res Function(_SessionWithDetails) _then;

/// Create a copy of SessionWithDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = freezed,Object? game = freezed,Object? scores = null,}) {
  return _then(_SessionWithDetails(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionRecord,game: freezed == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as BoardGameRecord,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as List<ScoreWithPlayer>,
  ));
}


}

/// @nodoc
mixin _$ScoreWithPlayer {

 int get id; int get sessionId; int get score; PlayerRecord get player;
/// Create a copy of ScoreWithPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreWithPlayerCopyWith<ScoreWithPlayer> get copyWith => _$ScoreWithPlayerCopyWithImpl<ScoreWithPlayer>(this as ScoreWithPlayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreWithPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.player, player));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,score,const DeepCollectionEquality().hash(player));

@override
String toString() {
  return 'ScoreWithPlayer(id: $id, sessionId: $sessionId, score: $score, player: $player)';
}


}

/// @nodoc
abstract mixin class $ScoreWithPlayerCopyWith<$Res>  {
  factory $ScoreWithPlayerCopyWith(ScoreWithPlayer value, $Res Function(ScoreWithPlayer) _then) = _$ScoreWithPlayerCopyWithImpl;
@useResult
$Res call({
 int id, int sessionId, int score, PlayerRecord player
});




}
/// @nodoc
class _$ScoreWithPlayerCopyWithImpl<$Res>
    implements $ScoreWithPlayerCopyWith<$Res> {
  _$ScoreWithPlayerCopyWithImpl(this._self, this._then);

  final ScoreWithPlayer _self;
  final $Res Function(ScoreWithPlayer) _then;

/// Create a copy of ScoreWithPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? score = null,Object? player = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,player: freezed == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as PlayerRecord,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreWithPlayer].
extension ScoreWithPlayerPatterns on ScoreWithPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreWithPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreWithPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreWithPlayer value)  $default,){
final _that = this;
switch (_that) {
case _ScoreWithPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreWithPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreWithPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int sessionId,  int score,  PlayerRecord player)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreWithPlayer() when $default != null:
return $default(_that.id,_that.sessionId,_that.score,_that.player);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int sessionId,  int score,  PlayerRecord player)  $default,) {final _that = this;
switch (_that) {
case _ScoreWithPlayer():
return $default(_that.id,_that.sessionId,_that.score,_that.player);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int sessionId,  int score,  PlayerRecord player)?  $default,) {final _that = this;
switch (_that) {
case _ScoreWithPlayer() when $default != null:
return $default(_that.id,_that.sessionId,_that.score,_that.player);case _:
  return null;

}
}

}

/// @nodoc


class _ScoreWithPlayer implements ScoreWithPlayer {
  const _ScoreWithPlayer({required this.id, required this.sessionId, required this.score, required this.player});
  

@override final  int id;
@override final  int sessionId;
@override final  int score;
@override final  PlayerRecord player;

/// Create a copy of ScoreWithPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreWithPlayerCopyWith<_ScoreWithPlayer> get copyWith => __$ScoreWithPlayerCopyWithImpl<_ScoreWithPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreWithPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.player, player));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,score,const DeepCollectionEquality().hash(player));

@override
String toString() {
  return 'ScoreWithPlayer(id: $id, sessionId: $sessionId, score: $score, player: $player)';
}


}

/// @nodoc
abstract mixin class _$ScoreWithPlayerCopyWith<$Res> implements $ScoreWithPlayerCopyWith<$Res> {
  factory _$ScoreWithPlayerCopyWith(_ScoreWithPlayer value, $Res Function(_ScoreWithPlayer) _then) = __$ScoreWithPlayerCopyWithImpl;
@override @useResult
$Res call({
 int id, int sessionId, int score, PlayerRecord player
});




}
/// @nodoc
class __$ScoreWithPlayerCopyWithImpl<$Res>
    implements _$ScoreWithPlayerCopyWith<$Res> {
  __$ScoreWithPlayerCopyWithImpl(this._self, this._then);

  final _ScoreWithPlayer _self;
  final $Res Function(_ScoreWithPlayer) _then;

/// Create a copy of ScoreWithPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? score = null,Object? player = freezed,}) {
  return _then(_ScoreWithPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,player: freezed == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as PlayerRecord,
  ));
}


}

// dart format on
