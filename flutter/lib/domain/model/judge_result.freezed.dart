// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'judge_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JudgeResult {

 String get id; String get question; String get answer; DateTime get createdAt;
/// Create a copy of JudgeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JudgeResultCopyWith<JudgeResult> get copyWith => _$JudgeResultCopyWithImpl<JudgeResult>(this as JudgeResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JudgeResult&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,question,answer,createdAt);

@override
String toString() {
  return 'JudgeResult(id: $id, question: $question, answer: $answer, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $JudgeResultCopyWith<$Res>  {
  factory $JudgeResultCopyWith(JudgeResult value, $Res Function(JudgeResult) _then) = _$JudgeResultCopyWithImpl;
@useResult
$Res call({
 String id, String question, String answer, DateTime createdAt
});




}
/// @nodoc
class _$JudgeResultCopyWithImpl<$Res>
    implements $JudgeResultCopyWith<$Res> {
  _$JudgeResultCopyWithImpl(this._self, this._then);

  final JudgeResult _self;
  final $Res Function(JudgeResult) _then;

/// Create a copy of JudgeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? answer = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JudgeResult].
extension JudgeResultPatterns on JudgeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JudgeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JudgeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JudgeResult value)  $default,){
final _that = this;
switch (_that) {
case _JudgeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JudgeResult value)?  $default,){
final _that = this;
switch (_that) {
case _JudgeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String question,  String answer,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JudgeResult() when $default != null:
return $default(_that.id,_that.question,_that.answer,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String question,  String answer,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _JudgeResult():
return $default(_that.id,_that.question,_that.answer,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String question,  String answer,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _JudgeResult() when $default != null:
return $default(_that.id,_that.question,_that.answer,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _JudgeResult implements JudgeResult {
  const _JudgeResult({required this.id, required this.question, required this.answer, required this.createdAt});
  

@override final  String id;
@override final  String question;
@override final  String answer;
@override final  DateTime createdAt;

/// Create a copy of JudgeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JudgeResultCopyWith<_JudgeResult> get copyWith => __$JudgeResultCopyWithImpl<_JudgeResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JudgeResult&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,question,answer,createdAt);

@override
String toString() {
  return 'JudgeResult(id: $id, question: $question, answer: $answer, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JudgeResultCopyWith<$Res> implements $JudgeResultCopyWith<$Res> {
  factory _$JudgeResultCopyWith(_JudgeResult value, $Res Function(_JudgeResult) _then) = __$JudgeResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, String answer, DateTime createdAt
});




}
/// @nodoc
class __$JudgeResultCopyWithImpl<$Res>
    implements _$JudgeResultCopyWith<$Res> {
  __$JudgeResultCopyWithImpl(this._self, this._then);

  final _JudgeResult _self;
  final $Res Function(_JudgeResult) _then;

/// Create a copy of JudgeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? answer = null,Object? createdAt = null,}) {
  return _then(_JudgeResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
