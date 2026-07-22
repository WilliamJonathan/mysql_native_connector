// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CellValue {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CellValue()';
}


}

/// @nodoc
class $CellValueCopyWith<$Res>  {
$CellValueCopyWith(CellValue _, $Res Function(CellValue) __);
}


/// Adds pattern-matching-related methods to [CellValue].
extension CellValuePatterns on CellValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CellValue_Null value)?  null_,TResult Function( CellValue_Bool value)?  bool,TResult Function( CellValue_Int64 value)?  int64,TResult Function( CellValue_Float64 value)?  float64,TResult Function( CellValue_Text value)?  text,TResult Function( CellValue_Bytes value)?  bytes,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CellValue_Null() when null_ != null:
return null_(_that);case CellValue_Bool() when bool != null:
return bool(_that);case CellValue_Int64() when int64 != null:
return int64(_that);case CellValue_Float64() when float64 != null:
return float64(_that);case CellValue_Text() when text != null:
return text(_that);case CellValue_Bytes() when bytes != null:
return bytes(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CellValue_Null value)  null_,required TResult Function( CellValue_Bool value)  bool,required TResult Function( CellValue_Int64 value)  int64,required TResult Function( CellValue_Float64 value)  float64,required TResult Function( CellValue_Text value)  text,required TResult Function( CellValue_Bytes value)  bytes,}){
final _that = this;
switch (_that) {
case CellValue_Null():
return null_(_that);case CellValue_Bool():
return bool(_that);case CellValue_Int64():
return int64(_that);case CellValue_Float64():
return float64(_that);case CellValue_Text():
return text(_that);case CellValue_Bytes():
return bytes(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CellValue_Null value)?  null_,TResult? Function( CellValue_Bool value)?  bool,TResult? Function( CellValue_Int64 value)?  int64,TResult? Function( CellValue_Float64 value)?  float64,TResult? Function( CellValue_Text value)?  text,TResult? Function( CellValue_Bytes value)?  bytes,}){
final _that = this;
switch (_that) {
case CellValue_Null() when null_ != null:
return null_(_that);case CellValue_Bool() when bool != null:
return bool(_that);case CellValue_Int64() when int64 != null:
return int64(_that);case CellValue_Float64() when float64 != null:
return float64(_that);case CellValue_Text() when text != null:
return text(_that);case CellValue_Bytes() when bytes != null:
return bytes(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  null_,TResult Function( bool field0)?  bool,TResult Function( PlatformInt64 field0)?  int64,TResult Function( double field0)?  float64,TResult Function( String field0)?  text,TResult Function( Uint8List field0)?  bytes,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CellValue_Null() when null_ != null:
return null_();case CellValue_Bool() when bool != null:
return bool(_that.field0);case CellValue_Int64() when int64 != null:
return int64(_that.field0);case CellValue_Float64() when float64 != null:
return float64(_that.field0);case CellValue_Text() when text != null:
return text(_that.field0);case CellValue_Bytes() when bytes != null:
return bytes(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  null_,required TResult Function( bool field0)  bool,required TResult Function( PlatformInt64 field0)  int64,required TResult Function( double field0)  float64,required TResult Function( String field0)  text,required TResult Function( Uint8List field0)  bytes,}) {final _that = this;
switch (_that) {
case CellValue_Null():
return null_();case CellValue_Bool():
return bool(_that.field0);case CellValue_Int64():
return int64(_that.field0);case CellValue_Float64():
return float64(_that.field0);case CellValue_Text():
return text(_that.field0);case CellValue_Bytes():
return bytes(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  null_,TResult? Function( bool field0)?  bool,TResult? Function( PlatformInt64 field0)?  int64,TResult? Function( double field0)?  float64,TResult? Function( String field0)?  text,TResult? Function( Uint8List field0)?  bytes,}) {final _that = this;
switch (_that) {
case CellValue_Null() when null_ != null:
return null_();case CellValue_Bool() when bool != null:
return bool(_that.field0);case CellValue_Int64() when int64 != null:
return int64(_that.field0);case CellValue_Float64() when float64 != null:
return float64(_that.field0);case CellValue_Text() when text != null:
return text(_that.field0);case CellValue_Bytes() when bytes != null:
return bytes(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class CellValue_Null extends CellValue {
  const CellValue_Null(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue_Null);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CellValue.null_()';
}


}




/// @nodoc


class CellValue_Bool extends CellValue {
  const CellValue_Bool(this.field0): super._();
  

 final  bool field0;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellValue_BoolCopyWith<CellValue_Bool> get copyWith => _$CellValue_BoolCopyWithImpl<CellValue_Bool>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue_Bool&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'CellValue.bool(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CellValue_BoolCopyWith<$Res> implements $CellValueCopyWith<$Res> {
  factory $CellValue_BoolCopyWith(CellValue_Bool value, $Res Function(CellValue_Bool) _then) = _$CellValue_BoolCopyWithImpl;
@useResult
$Res call({
 bool field0
});




}
/// @nodoc
class _$CellValue_BoolCopyWithImpl<$Res>
    implements $CellValue_BoolCopyWith<$Res> {
  _$CellValue_BoolCopyWithImpl(this._self, this._then);

  final CellValue_Bool _self;
  final $Res Function(CellValue_Bool) _then;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CellValue_Bool(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CellValue_Int64 extends CellValue {
  const CellValue_Int64(this.field0): super._();
  

 final  PlatformInt64 field0;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellValue_Int64CopyWith<CellValue_Int64> get copyWith => _$CellValue_Int64CopyWithImpl<CellValue_Int64>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue_Int64&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'CellValue.int64(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CellValue_Int64CopyWith<$Res> implements $CellValueCopyWith<$Res> {
  factory $CellValue_Int64CopyWith(CellValue_Int64 value, $Res Function(CellValue_Int64) _then) = _$CellValue_Int64CopyWithImpl;
@useResult
$Res call({
 PlatformInt64 field0
});




}
/// @nodoc
class _$CellValue_Int64CopyWithImpl<$Res>
    implements $CellValue_Int64CopyWith<$Res> {
  _$CellValue_Int64CopyWithImpl(this._self, this._then);

  final CellValue_Int64 _self;
  final $Res Function(CellValue_Int64) _then;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CellValue_Int64(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class CellValue_Float64 extends CellValue {
  const CellValue_Float64(this.field0): super._();
  

 final  double field0;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellValue_Float64CopyWith<CellValue_Float64> get copyWith => _$CellValue_Float64CopyWithImpl<CellValue_Float64>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue_Float64&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'CellValue.float64(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CellValue_Float64CopyWith<$Res> implements $CellValueCopyWith<$Res> {
  factory $CellValue_Float64CopyWith(CellValue_Float64 value, $Res Function(CellValue_Float64) _then) = _$CellValue_Float64CopyWithImpl;
@useResult
$Res call({
 double field0
});




}
/// @nodoc
class _$CellValue_Float64CopyWithImpl<$Res>
    implements $CellValue_Float64CopyWith<$Res> {
  _$CellValue_Float64CopyWithImpl(this._self, this._then);

  final CellValue_Float64 _self;
  final $Res Function(CellValue_Float64) _then;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CellValue_Float64(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class CellValue_Text extends CellValue {
  const CellValue_Text(this.field0): super._();
  

 final  String field0;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellValue_TextCopyWith<CellValue_Text> get copyWith => _$CellValue_TextCopyWithImpl<CellValue_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue_Text&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'CellValue.text(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CellValue_TextCopyWith<$Res> implements $CellValueCopyWith<$Res> {
  factory $CellValue_TextCopyWith(CellValue_Text value, $Res Function(CellValue_Text) _then) = _$CellValue_TextCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$CellValue_TextCopyWithImpl<$Res>
    implements $CellValue_TextCopyWith<$Res> {
  _$CellValue_TextCopyWithImpl(this._self, this._then);

  final CellValue_Text _self;
  final $Res Function(CellValue_Text) _then;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CellValue_Text(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CellValue_Bytes extends CellValue {
  const CellValue_Bytes(this.field0): super._();
  

 final  Uint8List field0;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellValue_BytesCopyWith<CellValue_Bytes> get copyWith => _$CellValue_BytesCopyWithImpl<CellValue_Bytes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellValue_Bytes&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'CellValue.bytes(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CellValue_BytesCopyWith<$Res> implements $CellValueCopyWith<$Res> {
  factory $CellValue_BytesCopyWith(CellValue_Bytes value, $Res Function(CellValue_Bytes) _then) = _$CellValue_BytesCopyWithImpl;
@useResult
$Res call({
 Uint8List field0
});




}
/// @nodoc
class _$CellValue_BytesCopyWithImpl<$Res>
    implements $CellValue_BytesCopyWith<$Res> {
  _$CellValue_BytesCopyWithImpl(this._self, this._then);

  final CellValue_Bytes _self;
  final $Res Function(CellValue_Bytes) _then;

/// Create a copy of CellValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CellValue_Bytes(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

// dart format on
