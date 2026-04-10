// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LlmRequest {

 List<LlmMessage> get messages; String? get systemPrompt; int get maxTokens;
/// Create a copy of LlmRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LlmRequestCopyWith<LlmRequest> get copyWith => _$LlmRequestCopyWithImpl<LlmRequest>(this as LlmRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LlmRequest&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),systemPrompt,maxTokens);

@override
String toString() {
  return 'LlmRequest(messages: $messages, systemPrompt: $systemPrompt, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class $LlmRequestCopyWith<$Res>  {
  factory $LlmRequestCopyWith(LlmRequest value, $Res Function(LlmRequest) _then) = _$LlmRequestCopyWithImpl;
@useResult
$Res call({
 List<LlmMessage> messages, String? systemPrompt, int maxTokens
});




}
/// @nodoc
class _$LlmRequestCopyWithImpl<$Res>
    implements $LlmRequestCopyWith<$Res> {
  _$LlmRequestCopyWithImpl(this._self, this._then);

  final LlmRequest _self;
  final $Res Function(LlmRequest) _then;

/// Create a copy of LlmRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? systemPrompt = freezed,Object? maxTokens = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<LlmMessage>,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LlmRequest].
extension LlmRequestPatterns on LlmRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LlmRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LlmRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LlmRequest value)  $default,){
final _that = this;
switch (_that) {
case _LlmRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LlmRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LlmRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LlmMessage> messages,  String? systemPrompt,  int maxTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LlmRequest() when $default != null:
return $default(_that.messages,_that.systemPrompt,_that.maxTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LlmMessage> messages,  String? systemPrompt,  int maxTokens)  $default,) {final _that = this;
switch (_that) {
case _LlmRequest():
return $default(_that.messages,_that.systemPrompt,_that.maxTokens);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LlmMessage> messages,  String? systemPrompt,  int maxTokens)?  $default,) {final _that = this;
switch (_that) {
case _LlmRequest() when $default != null:
return $default(_that.messages,_that.systemPrompt,_that.maxTokens);case _:
  return null;

}
}

}

/// @nodoc


class _LlmRequest implements LlmRequest {
  const _LlmRequest({required final  List<LlmMessage> messages, this.systemPrompt = null, this.maxTokens = 4096}): _messages = messages;
  

 final  List<LlmMessage> _messages;
@override List<LlmMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  String? systemPrompt;
@override@JsonKey() final  int maxTokens;

/// Create a copy of LlmRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LlmRequestCopyWith<_LlmRequest> get copyWith => __$LlmRequestCopyWithImpl<_LlmRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LlmRequest&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),systemPrompt,maxTokens);

@override
String toString() {
  return 'LlmRequest(messages: $messages, systemPrompt: $systemPrompt, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class _$LlmRequestCopyWith<$Res> implements $LlmRequestCopyWith<$Res> {
  factory _$LlmRequestCopyWith(_LlmRequest value, $Res Function(_LlmRequest) _then) = __$LlmRequestCopyWithImpl;
@override @useResult
$Res call({
 List<LlmMessage> messages, String? systemPrompt, int maxTokens
});




}
/// @nodoc
class __$LlmRequestCopyWithImpl<$Res>
    implements _$LlmRequestCopyWith<$Res> {
  __$LlmRequestCopyWithImpl(this._self, this._then);

  final _LlmRequest _self;
  final $Res Function(_LlmRequest) _then;

/// Create a copy of LlmRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? systemPrompt = freezed,Object? maxTokens = null,}) {
  return _then(_LlmRequest(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<LlmMessage>,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LlmMessage {

 String get role; String get content;
/// Create a copy of LlmMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LlmMessageCopyWith<LlmMessage> get copyWith => _$LlmMessageCopyWithImpl<LlmMessage>(this as LlmMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LlmMessage&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,role,content);

@override
String toString() {
  return 'LlmMessage(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class $LlmMessageCopyWith<$Res>  {
  factory $LlmMessageCopyWith(LlmMessage value, $Res Function(LlmMessage) _then) = _$LlmMessageCopyWithImpl;
@useResult
$Res call({
 String role, String content
});




}
/// @nodoc
class _$LlmMessageCopyWithImpl<$Res>
    implements $LlmMessageCopyWith<$Res> {
  _$LlmMessageCopyWithImpl(this._self, this._then);

  final LlmMessage _self;
  final $Res Function(LlmMessage) _then;

/// Create a copy of LlmMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? content = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LlmMessage].
extension LlmMessagePatterns on LlmMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LlmMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LlmMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LlmMessage value)  $default,){
final _that = this;
switch (_that) {
case _LlmMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LlmMessage value)?  $default,){
final _that = this;
switch (_that) {
case _LlmMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LlmMessage() when $default != null:
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String content)  $default,) {final _that = this;
switch (_that) {
case _LlmMessage():
return $default(_that.role,_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String content)?  $default,) {final _that = this;
switch (_that) {
case _LlmMessage() when $default != null:
return $default(_that.role,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _LlmMessage implements LlmMessage {
  const _LlmMessage({required this.role, required this.content});
  

@override final  String role;
@override final  String content;

/// Create a copy of LlmMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LlmMessageCopyWith<_LlmMessage> get copyWith => __$LlmMessageCopyWithImpl<_LlmMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LlmMessage&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,role,content);

@override
String toString() {
  return 'LlmMessage(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class _$LlmMessageCopyWith<$Res> implements $LlmMessageCopyWith<$Res> {
  factory _$LlmMessageCopyWith(_LlmMessage value, $Res Function(_LlmMessage) _then) = __$LlmMessageCopyWithImpl;
@override @useResult
$Res call({
 String role, String content
});




}
/// @nodoc
class __$LlmMessageCopyWithImpl<$Res>
    implements _$LlmMessageCopyWith<$Res> {
  __$LlmMessageCopyWithImpl(this._self, this._then);

  final _LlmMessage _self;
  final $Res Function(_LlmMessage) _then;

/// Create a copy of LlmMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? content = null,}) {
  return _then(_LlmMessage(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
