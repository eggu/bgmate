// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bgg_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BggAccount {

 String get username; DateTime get linkedAt; DateTime? get lastSyncedAt;
/// Create a copy of BggAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BggAccountCopyWith<BggAccount> get copyWith => _$BggAccountCopyWithImpl<BggAccount>(this as BggAccount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BggAccount&&(identical(other.username, username) || other.username == username)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode => Object.hash(runtimeType,username,linkedAt,lastSyncedAt);

@override
String toString() {
  return 'BggAccount(username: $username, linkedAt: $linkedAt, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class $BggAccountCopyWith<$Res>  {
  factory $BggAccountCopyWith(BggAccount value, $Res Function(BggAccount) _then) = _$BggAccountCopyWithImpl;
@useResult
$Res call({
 String username, DateTime linkedAt, DateTime? lastSyncedAt
});




}
/// @nodoc
class _$BggAccountCopyWithImpl<$Res>
    implements $BggAccountCopyWith<$Res> {
  _$BggAccountCopyWithImpl(this._self, this._then);

  final BggAccount _self;
  final $Res Function(BggAccount) _then;

/// Create a copy of BggAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? linkedAt = null,Object? lastSyncedAt = freezed,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,linkedAt: null == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BggAccount].
extension BggAccountPatterns on BggAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BggAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BggAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BggAccount value)  $default,){
final _that = this;
switch (_that) {
case _BggAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BggAccount value)?  $default,){
final _that = this;
switch (_that) {
case _BggAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  DateTime linkedAt,  DateTime? lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BggAccount() when $default != null:
return $default(_that.username,_that.linkedAt,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  DateTime linkedAt,  DateTime? lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _BggAccount():
return $default(_that.username,_that.linkedAt,_that.lastSyncedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  DateTime linkedAt,  DateTime? lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _BggAccount() when $default != null:
return $default(_that.username,_that.linkedAt,_that.lastSyncedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BggAccount implements BggAccount {
  const _BggAccount({required this.username, required this.linkedAt, this.lastSyncedAt});
  

@override final  String username;
@override final  DateTime linkedAt;
@override final  DateTime? lastSyncedAt;

/// Create a copy of BggAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BggAccountCopyWith<_BggAccount> get copyWith => __$BggAccountCopyWithImpl<_BggAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BggAccount&&(identical(other.username, username) || other.username == username)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode => Object.hash(runtimeType,username,linkedAt,lastSyncedAt);

@override
String toString() {
  return 'BggAccount(username: $username, linkedAt: $linkedAt, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class _$BggAccountCopyWith<$Res> implements $BggAccountCopyWith<$Res> {
  factory _$BggAccountCopyWith(_BggAccount value, $Res Function(_BggAccount) _then) = __$BggAccountCopyWithImpl;
@override @useResult
$Res call({
 String username, DateTime linkedAt, DateTime? lastSyncedAt
});




}
/// @nodoc
class __$BggAccountCopyWithImpl<$Res>
    implements _$BggAccountCopyWith<$Res> {
  __$BggAccountCopyWithImpl(this._self, this._then);

  final _BggAccount _self;
  final $Res Function(_BggAccount) _then;

/// Create a copy of BggAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? linkedAt = null,Object? lastSyncedAt = freezed,}) {
  return _then(_BggAccount(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,linkedAt: null == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
