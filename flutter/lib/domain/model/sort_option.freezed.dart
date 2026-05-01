// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sort_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SortOption {

 SortField get field; SortOrder get order;
/// Create a copy of SortOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SortOptionCopyWith<SortOption> get copyWith => _$SortOptionCopyWithImpl<SortOption>(this as SortOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SortOption&&(identical(other.field, field) || other.field == field)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,field,order);

@override
String toString() {
  return 'SortOption(field: $field, order: $order)';
}


}

/// @nodoc
abstract mixin class $SortOptionCopyWith<$Res>  {
  factory $SortOptionCopyWith(SortOption value, $Res Function(SortOption) _then) = _$SortOptionCopyWithImpl;
@useResult
$Res call({
 SortField field, SortOrder order
});




}
/// @nodoc
class _$SortOptionCopyWithImpl<$Res>
    implements $SortOptionCopyWith<$Res> {
  _$SortOptionCopyWithImpl(this._self, this._then);

  final SortOption _self;
  final $Res Function(SortOption) _then;

/// Create a copy of SortOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? order = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as SortField,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as SortOrder,
  ));
}

}


/// Adds pattern-matching-related methods to [SortOption].
extension SortOptionPatterns on SortOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SortOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SortOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SortOption value)  $default,){
final _that = this;
switch (_that) {
case _SortOption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SortOption value)?  $default,){
final _that = this;
switch (_that) {
case _SortOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SortField field,  SortOrder order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SortOption() when $default != null:
return $default(_that.field,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SortField field,  SortOrder order)  $default,) {final _that = this;
switch (_that) {
case _SortOption():
return $default(_that.field,_that.order);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SortField field,  SortOrder order)?  $default,) {final _that = this;
switch (_that) {
case _SortOption() when $default != null:
return $default(_that.field,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _SortOption extends SortOption {
  const _SortOption({this.field = SortField.addedAt, this.order = SortOrder.desc}): super._();
  

@override@JsonKey() final  SortField field;
@override@JsonKey() final  SortOrder order;

/// Create a copy of SortOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SortOptionCopyWith<_SortOption> get copyWith => __$SortOptionCopyWithImpl<_SortOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SortOption&&(identical(other.field, field) || other.field == field)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,field,order);

@override
String toString() {
  return 'SortOption(field: $field, order: $order)';
}


}

/// @nodoc
abstract mixin class _$SortOptionCopyWith<$Res> implements $SortOptionCopyWith<$Res> {
  factory _$SortOptionCopyWith(_SortOption value, $Res Function(_SortOption) _then) = __$SortOptionCopyWithImpl;
@override @useResult
$Res call({
 SortField field, SortOrder order
});




}
/// @nodoc
class __$SortOptionCopyWithImpl<$Res>
    implements _$SortOptionCopyWith<$Res> {
  __$SortOptionCopyWithImpl(this._self, this._then);

  final _SortOption _self;
  final $Res Function(_SortOption) _then;

/// Create a copy of SortOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? order = null,}) {
  return _then(_SortOption(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as SortField,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as SortOrder,
  ));
}


}

// dart format on
