// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateSessionState {

 AsyncValue<BoardGame?> get game; List<String> get playerNames;
/// Create a copy of CreateSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateSessionStateCopyWith<CreateSessionState> get copyWith => _$CreateSessionStateCopyWithImpl<CreateSessionState>(this as CreateSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateSessionState&&(identical(other.game, game) || other.game == game)&&const DeepCollectionEquality().equals(other.playerNames, playerNames));
}


@override
int get hashCode => Object.hash(runtimeType,game,const DeepCollectionEquality().hash(playerNames));

@override
String toString() {
  return 'CreateSessionState(game: $game, playerNames: $playerNames)';
}


}

/// @nodoc
abstract mixin class $CreateSessionStateCopyWith<$Res>  {
  factory $CreateSessionStateCopyWith(CreateSessionState value, $Res Function(CreateSessionState) _then) = _$CreateSessionStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<BoardGame?> game, List<String> playerNames
});




}
/// @nodoc
class _$CreateSessionStateCopyWithImpl<$Res>
    implements $CreateSessionStateCopyWith<$Res> {
  _$CreateSessionStateCopyWithImpl(this._self, this._then);

  final CreateSessionState _self;
  final $Res Function(CreateSessionState) _then;

/// Create a copy of CreateSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? game = null,Object? playerNames = null,}) {
  return _then(_self.copyWith(
game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as AsyncValue<BoardGame?>,playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateSessionState].
extension CreateSessionStatePatterns on CreateSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateSessionState value)  $default,){
final _that = this;
switch (_that) {
case _CreateSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<BoardGame?> game,  List<String> playerNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateSessionState() when $default != null:
return $default(_that.game,_that.playerNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<BoardGame?> game,  List<String> playerNames)  $default,) {final _that = this;
switch (_that) {
case _CreateSessionState():
return $default(_that.game,_that.playerNames);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<BoardGame?> game,  List<String> playerNames)?  $default,) {final _that = this;
switch (_that) {
case _CreateSessionState() when $default != null:
return $default(_that.game,_that.playerNames);case _:
  return null;

}
}

}

/// @nodoc


class _CreateSessionState extends CreateSessionState {
  const _CreateSessionState({this.game = const AsyncValue.loading(), final  List<String> playerNames = const []}): _playerNames = playerNames,super._();
  

@override@JsonKey() final  AsyncValue<BoardGame?> game;
 final  List<String> _playerNames;
@override@JsonKey() List<String> get playerNames {
  if (_playerNames is EqualUnmodifiableListView) return _playerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerNames);
}


/// Create a copy of CreateSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateSessionStateCopyWith<_CreateSessionState> get copyWith => __$CreateSessionStateCopyWithImpl<_CreateSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateSessionState&&(identical(other.game, game) || other.game == game)&&const DeepCollectionEquality().equals(other._playerNames, _playerNames));
}


@override
int get hashCode => Object.hash(runtimeType,game,const DeepCollectionEquality().hash(_playerNames));

@override
String toString() {
  return 'CreateSessionState(game: $game, playerNames: $playerNames)';
}


}

/// @nodoc
abstract mixin class _$CreateSessionStateCopyWith<$Res> implements $CreateSessionStateCopyWith<$Res> {
  factory _$CreateSessionStateCopyWith(_CreateSessionState value, $Res Function(_CreateSessionState) _then) = __$CreateSessionStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<BoardGame?> game, List<String> playerNames
});




}
/// @nodoc
class __$CreateSessionStateCopyWithImpl<$Res>
    implements _$CreateSessionStateCopyWith<$Res> {
  __$CreateSessionStateCopyWithImpl(this._self, this._then);

  final _CreateSessionState _self;
  final $Res Function(_CreateSessionState) _then;

/// Create a copy of CreateSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? game = null,Object? playerNames = null,}) {
  return _then(_CreateSessionState(
game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as AsyncValue<BoardGame?>,playerNames: null == playerNames ? _self._playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
