// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DbError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DbError()';
}


}

/// @nodoc
class $DbErrorCopyWith<$Res>  {
$DbErrorCopyWith(DbError _, $Res Function(DbError) __);
}


/// Adds pattern-matching-related methods to [DbError].
extension DbErrorPatterns on DbError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DbError_EmptyUrl value)?  emptyUrl,TResult Function( DbError_EmptySql value)?  emptySql,TResult Function( DbError_PoolNotInitialized value)?  poolNotInitialized,TResult Function( DbError_Connect value)?  connect,TResult Function( DbError_Query value)?  query,TResult Function( DbError_Execute value)?  execute,TResult Function( DbError_Column value)?  column,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DbError_EmptyUrl() when emptyUrl != null:
return emptyUrl(_that);case DbError_EmptySql() when emptySql != null:
return emptySql(_that);case DbError_PoolNotInitialized() when poolNotInitialized != null:
return poolNotInitialized(_that);case DbError_Connect() when connect != null:
return connect(_that);case DbError_Query() when query != null:
return query(_that);case DbError_Execute() when execute != null:
return execute(_that);case DbError_Column() when column != null:
return column(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DbError_EmptyUrl value)  emptyUrl,required TResult Function( DbError_EmptySql value)  emptySql,required TResult Function( DbError_PoolNotInitialized value)  poolNotInitialized,required TResult Function( DbError_Connect value)  connect,required TResult Function( DbError_Query value)  query,required TResult Function( DbError_Execute value)  execute,required TResult Function( DbError_Column value)  column,}){
final _that = this;
switch (_that) {
case DbError_EmptyUrl():
return emptyUrl(_that);case DbError_EmptySql():
return emptySql(_that);case DbError_PoolNotInitialized():
return poolNotInitialized(_that);case DbError_Connect():
return connect(_that);case DbError_Query():
return query(_that);case DbError_Execute():
return execute(_that);case DbError_Column():
return column(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DbError_EmptyUrl value)?  emptyUrl,TResult? Function( DbError_EmptySql value)?  emptySql,TResult? Function( DbError_PoolNotInitialized value)?  poolNotInitialized,TResult? Function( DbError_Connect value)?  connect,TResult? Function( DbError_Query value)?  query,TResult? Function( DbError_Execute value)?  execute,TResult? Function( DbError_Column value)?  column,}){
final _that = this;
switch (_that) {
case DbError_EmptyUrl() when emptyUrl != null:
return emptyUrl(_that);case DbError_EmptySql() when emptySql != null:
return emptySql(_that);case DbError_PoolNotInitialized() when poolNotInitialized != null:
return poolNotInitialized(_that);case DbError_Connect() when connect != null:
return connect(_that);case DbError_Query() when query != null:
return query(_that);case DbError_Execute() when execute != null:
return execute(_that);case DbError_Column() when column != null:
return column(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  emptyUrl,TResult Function()?  emptySql,TResult Function()?  poolNotInitialized,TResult Function( String field0)?  connect,TResult Function( String field0)?  query,TResult Function( String field0)?  execute,TResult Function( BigInt index,  String message)?  column,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DbError_EmptyUrl() when emptyUrl != null:
return emptyUrl();case DbError_EmptySql() when emptySql != null:
return emptySql();case DbError_PoolNotInitialized() when poolNotInitialized != null:
return poolNotInitialized();case DbError_Connect() when connect != null:
return connect(_that.field0);case DbError_Query() when query != null:
return query(_that.field0);case DbError_Execute() when execute != null:
return execute(_that.field0);case DbError_Column() when column != null:
return column(_that.index,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  emptyUrl,required TResult Function()  emptySql,required TResult Function()  poolNotInitialized,required TResult Function( String field0)  connect,required TResult Function( String field0)  query,required TResult Function( String field0)  execute,required TResult Function( BigInt index,  String message)  column,}) {final _that = this;
switch (_that) {
case DbError_EmptyUrl():
return emptyUrl();case DbError_EmptySql():
return emptySql();case DbError_PoolNotInitialized():
return poolNotInitialized();case DbError_Connect():
return connect(_that.field0);case DbError_Query():
return query(_that.field0);case DbError_Execute():
return execute(_that.field0);case DbError_Column():
return column(_that.index,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  emptyUrl,TResult? Function()?  emptySql,TResult? Function()?  poolNotInitialized,TResult? Function( String field0)?  connect,TResult? Function( String field0)?  query,TResult? Function( String field0)?  execute,TResult? Function( BigInt index,  String message)?  column,}) {final _that = this;
switch (_that) {
case DbError_EmptyUrl() when emptyUrl != null:
return emptyUrl();case DbError_EmptySql() when emptySql != null:
return emptySql();case DbError_PoolNotInitialized() when poolNotInitialized != null:
return poolNotInitialized();case DbError_Connect() when connect != null:
return connect(_that.field0);case DbError_Query() when query != null:
return query(_that.field0);case DbError_Execute() when execute != null:
return execute(_that.field0);case DbError_Column() when column != null:
return column(_that.index,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DbError_EmptyUrl extends DbError {
  const DbError_EmptyUrl(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_EmptyUrl);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DbError.emptyUrl()';
}


}




/// @nodoc


class DbError_EmptySql extends DbError {
  const DbError_EmptySql(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_EmptySql);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DbError.emptySql()';
}


}




/// @nodoc


class DbError_PoolNotInitialized extends DbError {
  const DbError_PoolNotInitialized(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_PoolNotInitialized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DbError.poolNotInitialized()';
}


}




/// @nodoc


class DbError_Connect extends DbError {
  const DbError_Connect(this.field0): super._();
  

 final  String field0;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbError_ConnectCopyWith<DbError_Connect> get copyWith => _$DbError_ConnectCopyWithImpl<DbError_Connect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_Connect&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'DbError.connect(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $DbError_ConnectCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbError_ConnectCopyWith(DbError_Connect value, $Res Function(DbError_Connect) _then) = _$DbError_ConnectCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$DbError_ConnectCopyWithImpl<$Res>
    implements $DbError_ConnectCopyWith<$Res> {
  _$DbError_ConnectCopyWithImpl(this._self, this._then);

  final DbError_Connect _self;
  final $Res Function(DbError_Connect) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(DbError_Connect(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DbError_Query extends DbError {
  const DbError_Query(this.field0): super._();
  

 final  String field0;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbError_QueryCopyWith<DbError_Query> get copyWith => _$DbError_QueryCopyWithImpl<DbError_Query>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_Query&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'DbError.query(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $DbError_QueryCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbError_QueryCopyWith(DbError_Query value, $Res Function(DbError_Query) _then) = _$DbError_QueryCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$DbError_QueryCopyWithImpl<$Res>
    implements $DbError_QueryCopyWith<$Res> {
  _$DbError_QueryCopyWithImpl(this._self, this._then);

  final DbError_Query _self;
  final $Res Function(DbError_Query) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(DbError_Query(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DbError_Execute extends DbError {
  const DbError_Execute(this.field0): super._();
  

 final  String field0;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbError_ExecuteCopyWith<DbError_Execute> get copyWith => _$DbError_ExecuteCopyWithImpl<DbError_Execute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_Execute&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'DbError.execute(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $DbError_ExecuteCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbError_ExecuteCopyWith(DbError_Execute value, $Res Function(DbError_Execute) _then) = _$DbError_ExecuteCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$DbError_ExecuteCopyWithImpl<$Res>
    implements $DbError_ExecuteCopyWith<$Res> {
  _$DbError_ExecuteCopyWithImpl(this._self, this._then);

  final DbError_Execute _self;
  final $Res Function(DbError_Execute) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(DbError_Execute(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DbError_Column extends DbError {
  const DbError_Column({required this.index, required this.message}): super._();
  

 final  BigInt index;
 final  String message;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbError_ColumnCopyWith<DbError_Column> get copyWith => _$DbError_ColumnCopyWithImpl<DbError_Column>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError_Column&&(identical(other.index, index) || other.index == index)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,index,message);

@override
String toString() {
  return 'DbError.column(index: $index, message: $message)';
}


}

/// @nodoc
abstract mixin class $DbError_ColumnCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbError_ColumnCopyWith(DbError_Column value, $Res Function(DbError_Column) _then) = _$DbError_ColumnCopyWithImpl;
@useResult
$Res call({
 BigInt index, String message
});




}
/// @nodoc
class _$DbError_ColumnCopyWithImpl<$Res>
    implements $DbError_ColumnCopyWith<$Res> {
  _$DbError_ColumnCopyWithImpl(this._self, this._then);

  final DbError_Column _self;
  final $Res Function(DbError_Column) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? message = null,}) {
  return _then(DbError_Column(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
