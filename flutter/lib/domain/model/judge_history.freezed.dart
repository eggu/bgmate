// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'judge_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JudgeHistory {

 int get id; String get gameName; String get question; String get answer; DateTime get askedAt;
/// Create a copy of JudgeHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JudgeHistoryCopyWith<JudgeHistory> get copyWith => _$JudgeHistoryCopyWithImpl<JudgeHistory>(this as JudgeHistory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JudgeHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.askedAt, askedAt) || other.askedAt == askedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,gameName,question,answer,askedAt);

@override
String toString() {
  return 'JudgeHistory(id: $id, gameName: $gameName, question: $question, answer: $answer, askedAt: $askedAt)';
}


}

/// @nodoc
abstract mixin class $JudgeHistoryCopyWith<$Res>  {
  factory $JudgeHistoryCopyWith(JudgeHistory value, $Res Function(JudgeHistory) _then) = _$JudgeHistoryCopyWithImpl;
@useResult
$Res call({
 int id, String gameName, String question, String answer, DateTime askedAt
});




}
/// @nodoc
class _$JudgeHistoryCopyWithImpl<$Res>
    implements $JudgeHistoryCopyWith<$Res> {
  _$JudgeHistoryCopyWithImpl(this._self, this._then);

  final JudgeHistory _self;
  final $Res Function(JudgeHistory) _then;

/// Create a copy of JudgeHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameName = null,Object? question = null,Object? answer = null,Object? askedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,askedAt: null == askedAt ? _self.askedAt : askedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JudgeHistory].
extension JudgeHistoryPatterns on JudgeHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JudgeHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JudgeHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JudgeHistory value)  $default,){
final _that = this;
switch (_that) {
case _JudgeHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JudgeHistory value)?  $default,){
final _that = this;
switch (_that) {
case _JudgeHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String gameName,  String question,  String answer,  DateTime askedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JudgeHistory() when $default != null:
return $default(_that.id,_that.gameName,_that.question,_that.answer,_that.askedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String gameName,  String question,  String answer,  DateTime askedAt)  $default,) {final _that = this;
switch (_that) {
case _JudgeHistory():
return $default(_that.id,_that.gameName,_that.question,_that.answer,_that.askedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String gameName,  String question,  String answer,  DateTime askedAt)?  $default,) {final _that = this;
switch (_that) {
case _JudgeHistory() when $default != null:
return $default(_that.id,_that.gameName,_that.question,_that.answer,_that.askedAt);case _:
  return null;

}
}

}

/// @nodoc


class _JudgeHistory implements JudgeHistory {
  const _JudgeHistory({required this.id, required this.gameName, required this.question, required this.answer, required this.askedAt});
  

@override final  int id;
@override final  String gameName;
@override final  String question;
@override final  String answer;
@override final  DateTime askedAt;

/// Create a copy of JudgeHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JudgeHistoryCopyWith<_JudgeHistory> get copyWith => __$JudgeHistoryCopyWithImpl<_JudgeHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JudgeHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.askedAt, askedAt) || other.askedAt == askedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,gameName,question,answer,askedAt);

@override
String toString() {
  return 'JudgeHistory(id: $id, gameName: $gameName, question: $question, answer: $answer, askedAt: $askedAt)';
}


}

/// @nodoc
abstract mixin class _$JudgeHistoryCopyWith<$Res> implements $JudgeHistoryCopyWith<$Res> {
  factory _$JudgeHistoryCopyWith(_JudgeHistory value, $Res Function(_JudgeHistory) _then) = __$JudgeHistoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String gameName, String question, String answer, DateTime askedAt
});




}
/// @nodoc
class __$JudgeHistoryCopyWithImpl<$Res>
    implements _$JudgeHistoryCopyWith<$Res> {
  __$JudgeHistoryCopyWithImpl(this._self, this._then);

  final _JudgeHistory _self;
  final $Res Function(_JudgeHistory) _then;

/// Create a copy of JudgeHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameName = null,Object? question = null,Object? answer = null,Object? askedAt = null,}) {
  return _then(_JudgeHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,askedAt: null == askedAt ? _self.askedAt : askedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
