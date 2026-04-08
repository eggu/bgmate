// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardGame {

 int get bggId; String get name; int get yearPublished; String get thumbnail; int get minPlayers; int get maxPlayers; int get playingTime; String get description; bool get isInCollection;
/// Create a copy of BoardGame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardGameCopyWith<BoardGame> get copyWith => _$BoardGameCopyWithImpl<BoardGame>(this as BoardGame, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardGame&&(identical(other.bggId, bggId) || other.bggId == bggId)&&(identical(other.name, name) || other.name == name)&&(identical(other.yearPublished, yearPublished) || other.yearPublished == yearPublished)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.minPlayers, minPlayers) || other.minPlayers == minPlayers)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.playingTime, playingTime) || other.playingTime == playingTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.isInCollection, isInCollection) || other.isInCollection == isInCollection));
}


@override
int get hashCode => Object.hash(runtimeType,bggId,name,yearPublished,thumbnail,minPlayers,maxPlayers,playingTime,description,isInCollection);

@override
String toString() {
  return 'BoardGame(bggId: $bggId, name: $name, yearPublished: $yearPublished, thumbnail: $thumbnail, minPlayers: $minPlayers, maxPlayers: $maxPlayers, playingTime: $playingTime, description: $description, isInCollection: $isInCollection)';
}


}

/// @nodoc
abstract mixin class $BoardGameCopyWith<$Res>  {
  factory $BoardGameCopyWith(BoardGame value, $Res Function(BoardGame) _then) = _$BoardGameCopyWithImpl;
@useResult
$Res call({
 int bggId, String name, int yearPublished, String thumbnail, int minPlayers, int maxPlayers, int playingTime, String description, bool isInCollection
});




}
/// @nodoc
class _$BoardGameCopyWithImpl<$Res>
    implements $BoardGameCopyWith<$Res> {
  _$BoardGameCopyWithImpl(this._self, this._then);

  final BoardGame _self;
  final $Res Function(BoardGame) _then;

/// Create a copy of BoardGame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bggId = null,Object? name = null,Object? yearPublished = null,Object? thumbnail = null,Object? minPlayers = null,Object? maxPlayers = null,Object? playingTime = null,Object? description = null,Object? isInCollection = null,}) {
  return _then(_self.copyWith(
bggId: null == bggId ? _self.bggId : bggId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,yearPublished: null == yearPublished ? _self.yearPublished : yearPublished // ignore: cast_nullable_to_non_nullable
as int,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,minPlayers: null == minPlayers ? _self.minPlayers : minPlayers // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,playingTime: null == playingTime ? _self.playingTime : playingTime // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isInCollection: null == isInCollection ? _self.isInCollection : isInCollection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardGame].
extension BoardGamePatterns on BoardGame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardGame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardGame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardGame value)  $default,){
final _that = this;
switch (_that) {
case _BoardGame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardGame value)?  $default,){
final _that = this;
switch (_that) {
case _BoardGame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bggId,  String name,  int yearPublished,  String thumbnail,  int minPlayers,  int maxPlayers,  int playingTime,  String description,  bool isInCollection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardGame() when $default != null:
return $default(_that.bggId,_that.name,_that.yearPublished,_that.thumbnail,_that.minPlayers,_that.maxPlayers,_that.playingTime,_that.description,_that.isInCollection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bggId,  String name,  int yearPublished,  String thumbnail,  int minPlayers,  int maxPlayers,  int playingTime,  String description,  bool isInCollection)  $default,) {final _that = this;
switch (_that) {
case _BoardGame():
return $default(_that.bggId,_that.name,_that.yearPublished,_that.thumbnail,_that.minPlayers,_that.maxPlayers,_that.playingTime,_that.description,_that.isInCollection);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bggId,  String name,  int yearPublished,  String thumbnail,  int minPlayers,  int maxPlayers,  int playingTime,  String description,  bool isInCollection)?  $default,) {final _that = this;
switch (_that) {
case _BoardGame() when $default != null:
return $default(_that.bggId,_that.name,_that.yearPublished,_that.thumbnail,_that.minPlayers,_that.maxPlayers,_that.playingTime,_that.description,_that.isInCollection);case _:
  return null;

}
}

}

/// @nodoc


class _BoardGame implements BoardGame {
  const _BoardGame({required this.bggId, required this.name, required this.yearPublished, this.thumbnail = '', this.minPlayers = 0, this.maxPlayers = 0, this.playingTime = 0, this.description = '', this.isInCollection = false});
  

@override final  int bggId;
@override final  String name;
@override final  int yearPublished;
@override@JsonKey() final  String thumbnail;
@override@JsonKey() final  int minPlayers;
@override@JsonKey() final  int maxPlayers;
@override@JsonKey() final  int playingTime;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isInCollection;

/// Create a copy of BoardGame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardGameCopyWith<_BoardGame> get copyWith => __$BoardGameCopyWithImpl<_BoardGame>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardGame&&(identical(other.bggId, bggId) || other.bggId == bggId)&&(identical(other.name, name) || other.name == name)&&(identical(other.yearPublished, yearPublished) || other.yearPublished == yearPublished)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.minPlayers, minPlayers) || other.minPlayers == minPlayers)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.playingTime, playingTime) || other.playingTime == playingTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.isInCollection, isInCollection) || other.isInCollection == isInCollection));
}


@override
int get hashCode => Object.hash(runtimeType,bggId,name,yearPublished,thumbnail,minPlayers,maxPlayers,playingTime,description,isInCollection);

@override
String toString() {
  return 'BoardGame(bggId: $bggId, name: $name, yearPublished: $yearPublished, thumbnail: $thumbnail, minPlayers: $minPlayers, maxPlayers: $maxPlayers, playingTime: $playingTime, description: $description, isInCollection: $isInCollection)';
}


}

/// @nodoc
abstract mixin class _$BoardGameCopyWith<$Res> implements $BoardGameCopyWith<$Res> {
  factory _$BoardGameCopyWith(_BoardGame value, $Res Function(_BoardGame) _then) = __$BoardGameCopyWithImpl;
@override @useResult
$Res call({
 int bggId, String name, int yearPublished, String thumbnail, int minPlayers, int maxPlayers, int playingTime, String description, bool isInCollection
});




}
/// @nodoc
class __$BoardGameCopyWithImpl<$Res>
    implements _$BoardGameCopyWith<$Res> {
  __$BoardGameCopyWithImpl(this._self, this._then);

  final _BoardGame _self;
  final $Res Function(_BoardGame) _then;

/// Create a copy of BoardGame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bggId = null,Object? name = null,Object? yearPublished = null,Object? thumbnail = null,Object? minPlayers = null,Object? maxPlayers = null,Object? playingTime = null,Object? description = null,Object? isInCollection = null,}) {
  return _then(_BoardGame(
bggId: null == bggId ? _self.bggId : bggId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,yearPublished: null == yearPublished ? _self.yearPublished : yearPublished // ignore: cast_nullable_to_non_nullable
as int,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,minPlayers: null == minPlayers ? _self.minPlayers : minPlayers // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,playingTime: null == playingTime ? _self.playingTime : playingTime // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isInCollection: null == isInCollection ? _self.isInCollection : isInCollection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
