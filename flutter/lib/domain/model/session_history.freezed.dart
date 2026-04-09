// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionHistory {

 int get id; BoardGame get game; List<PlayerScore> get scores; DateTime get playedAt;
/// Create a copy of SessionHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionHistoryCopyWith<SessionHistory> get copyWith => _$SessionHistoryCopyWithImpl<SessionHistory>(this as SessionHistory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.game, game) || other.game == game)&&const DeepCollectionEquality().equals(other.scores, scores)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,game,const DeepCollectionEquality().hash(scores),playedAt);

@override
String toString() {
  return 'SessionHistory(id: $id, game: $game, scores: $scores, playedAt: $playedAt)';
}


}

/// @nodoc
abstract mixin class $SessionHistoryCopyWith<$Res>  {
  factory $SessionHistoryCopyWith(SessionHistory value, $Res Function(SessionHistory) _then) = _$SessionHistoryCopyWithImpl;
@useResult
$Res call({
 int id, BoardGame game, List<PlayerScore> scores, DateTime playedAt
});


$BoardGameCopyWith<$Res> get game;

}
/// @nodoc
class _$SessionHistoryCopyWithImpl<$Res>
    implements $SessionHistoryCopyWith<$Res> {
  _$SessionHistoryCopyWithImpl(this._self, this._then);

  final SessionHistory _self;
  final $Res Function(SessionHistory) _then;

/// Create a copy of SessionHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? game = null,Object? scores = null,Object? playedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as BoardGame,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as List<PlayerScore>,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SessionHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardGameCopyWith<$Res> get game {
  
  return $BoardGameCopyWith<$Res>(_self.game, (value) {
    return _then(_self.copyWith(game: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionHistory].
extension SessionHistoryPatterns on SessionHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionHistory value)  $default,){
final _that = this;
switch (_that) {
case _SessionHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionHistory value)?  $default,){
final _that = this;
switch (_that) {
case _SessionHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  BoardGame game,  List<PlayerScore> scores,  DateTime playedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionHistory() when $default != null:
return $default(_that.id,_that.game,_that.scores,_that.playedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  BoardGame game,  List<PlayerScore> scores,  DateTime playedAt)  $default,) {final _that = this;
switch (_that) {
case _SessionHistory():
return $default(_that.id,_that.game,_that.scores,_that.playedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  BoardGame game,  List<PlayerScore> scores,  DateTime playedAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionHistory() when $default != null:
return $default(_that.id,_that.game,_that.scores,_that.playedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SessionHistory implements SessionHistory {
  const _SessionHistory({required this.id, required this.game, required final  List<PlayerScore> scores, required this.playedAt}): _scores = scores;
  

@override final  int id;
@override final  BoardGame game;
 final  List<PlayerScore> _scores;
@override List<PlayerScore> get scores {
  if (_scores is EqualUnmodifiableListView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scores);
}

@override final  DateTime playedAt;

/// Create a copy of SessionHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionHistoryCopyWith<_SessionHistory> get copyWith => __$SessionHistoryCopyWithImpl<_SessionHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.game, game) || other.game == game)&&const DeepCollectionEquality().equals(other._scores, _scores)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,game,const DeepCollectionEquality().hash(_scores),playedAt);

@override
String toString() {
  return 'SessionHistory(id: $id, game: $game, scores: $scores, playedAt: $playedAt)';
}


}

/// @nodoc
abstract mixin class _$SessionHistoryCopyWith<$Res> implements $SessionHistoryCopyWith<$Res> {
  factory _$SessionHistoryCopyWith(_SessionHistory value, $Res Function(_SessionHistory) _then) = __$SessionHistoryCopyWithImpl;
@override @useResult
$Res call({
 int id, BoardGame game, List<PlayerScore> scores, DateTime playedAt
});


@override $BoardGameCopyWith<$Res> get game;

}
/// @nodoc
class __$SessionHistoryCopyWithImpl<$Res>
    implements _$SessionHistoryCopyWith<$Res> {
  __$SessionHistoryCopyWithImpl(this._self, this._then);

  final _SessionHistory _self;
  final $Res Function(_SessionHistory) _then;

/// Create a copy of SessionHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? game = null,Object? scores = null,Object? playedAt = null,}) {
  return _then(_SessionHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as BoardGame,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as List<PlayerScore>,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SessionHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardGameCopyWith<$Res> get game {
  
  return $BoardGameCopyWith<$Res>(_self.game, (value) {
    return _then(_self.copyWith(game: value));
  });
}
}

// dart format on
