// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tipo_de_servicio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TipoDeServicio {

/// Identificador asignado por el sistema. Nulo si aún no se ha guardado.
 int? get id;/// Nombre del servicio, con su forma normalizada.
 NombreDeServicio get nombre;/// Unidad en la que se mide su consumo.
 UnidadMedida get unidad;/// Etiqueta de contrato opcional. De uso estrictamente local (FR-013, FR-014).
 String? get etiquetaContrato;/// Falso cuando el servicio está desactivado. Un servicio nunca se elimina.
 bool get activo;/// Marca de captura.
 DateTime get creadoEn;/// Marca de última modificación.
 DateTime get actualizadoEn;
/// Create a copy of TipoDeServicio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TipoDeServicioCopyWith<TipoDeServicio> get copyWith => _$TipoDeServicioCopyWithImpl<TipoDeServicio>(this as TipoDeServicio, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TipoDeServicio;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TipoDeServicio&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre)&&(identical(other.unidad, _this.unidad) || other.unidad == _this.unidad)&&(identical(other.etiquetaContrato, _this.etiquetaContrato) || other.etiquetaContrato == _this.etiquetaContrato)&&(identical(other.activo, _this.activo) || other.activo == _this.activo)&&(identical(other.creadoEn, _this.creadoEn) || other.creadoEn == _this.creadoEn)&&(identical(other.actualizadoEn, _this.actualizadoEn) || other.actualizadoEn == _this.actualizadoEn));
}


@override
int get hashCode {
  final _this = this as TipoDeServicio;
  return Object.hash(runtimeType,_this.id,_this.nombre,_this.unidad,_this.etiquetaContrato,_this.activo,_this.creadoEn,_this.actualizadoEn);
}

@override
String toString() {
  final _this = this as TipoDeServicio;
  return 'TipoDeServicio(id: ${_this.id}, nombre: ${_this.nombre}, unidad: ${_this.unidad}, etiquetaContrato: ${_this.etiquetaContrato}, activo: ${_this.activo}, creadoEn: ${_this.creadoEn}, actualizadoEn: ${_this.actualizadoEn})';
}


}

/// @nodoc
abstract mixin class $TipoDeServicioCopyWith<$Res>  {
  factory $TipoDeServicioCopyWith(TipoDeServicio value, $Res Function(TipoDeServicio) _then) = _$TipoDeServicioCopyWithImpl;
@useResult
$Res call({
 int? id, NombreDeServicio nombre, UnidadMedida unidad, String? etiquetaContrato, bool activo, DateTime creadoEn, DateTime actualizadoEn
});




}
/// @nodoc
class _$TipoDeServicioCopyWithImpl<$Res>
    implements $TipoDeServicioCopyWith<$Res> {
  _$TipoDeServicioCopyWithImpl(this._self, this._then);

  final TipoDeServicio _self;
  final $Res Function(TipoDeServicio) _then;

/// Create a copy of TipoDeServicio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nombre = null,Object? unidad = null,Object? etiquetaContrato = freezed,Object? activo = null,Object? creadoEn = null,Object? actualizadoEn = null,}) {
  return _then(TipoDeServicio(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as NombreDeServicio,unidad: null == unidad ? _self.unidad : unidad // ignore: cast_nullable_to_non_nullable
as UnidadMedida,etiquetaContrato: freezed == etiquetaContrato ? _self.etiquetaContrato : etiquetaContrato // ignore: cast_nullable_to_non_nullable
as String?,activo: null == activo ? _self.activo : activo // ignore: cast_nullable_to_non_nullable
as bool,creadoEn: null == creadoEn ? _self.creadoEn : creadoEn // ignore: cast_nullable_to_non_nullable
as DateTime,actualizadoEn: null == actualizadoEn ? _self.actualizadoEn : actualizadoEn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TipoDeServicio].
extension TipoDeServicioPatterns on TipoDeServicio {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TipoDeServicio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TipoDeServicio() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TipoDeServicio value)  $default,){
final _that = this;
switch (_that) {
case _TipoDeServicio():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TipoDeServicio value)?  $default,){
final _that = this;
switch (_that) {
case _TipoDeServicio() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  NombreDeServicio nombre,  UnidadMedida unidad,  String? etiquetaContrato,  bool activo,  DateTime creadoEn,  DateTime actualizadoEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TipoDeServicio() when $default != null:
return $default(_that.id,_that.nombre,_that.unidad,_that.etiquetaContrato,_that.activo,_that.creadoEn,_that.actualizadoEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  NombreDeServicio nombre,  UnidadMedida unidad,  String? etiquetaContrato,  bool activo,  DateTime creadoEn,  DateTime actualizadoEn)  $default,) {final _that = this;
switch (_that) {
case _TipoDeServicio():
return $default(_that.id,_that.nombre,_that.unidad,_that.etiquetaContrato,_that.activo,_that.creadoEn,_that.actualizadoEn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  NombreDeServicio nombre,  UnidadMedida unidad,  String? etiquetaContrato,  bool activo,  DateTime creadoEn,  DateTime actualizadoEn)?  $default,) {final _that = this;
switch (_that) {
case _TipoDeServicio() when $default != null:
return $default(_that.id,_that.nombre,_that.unidad,_that.etiquetaContrato,_that.activo,_that.creadoEn,_that.actualizadoEn);case _:
  return null;

}
}

}

/// @nodoc


class _TipoDeServicio implements TipoDeServicio {
  const _TipoDeServicio({this.id, required this.nombre, required this.unidad, this.etiquetaContrato, required this.activo, required this.creadoEn, required this.actualizadoEn});
  

/// Identificador asignado por el sistema. Nulo si aún no se ha guardado.
@override final  int? id;
/// Nombre del servicio, con su forma normalizada.
@override final  NombreDeServicio nombre;
/// Unidad en la que se mide su consumo.
@override final  UnidadMedida unidad;
/// Etiqueta de contrato opcional. De uso estrictamente local (FR-013, FR-014).
@override final  String? etiquetaContrato;
/// Falso cuando el servicio está desactivado. Un servicio nunca se elimina.
@override final  bool activo;
/// Marca de captura.
@override final  DateTime creadoEn;
/// Marca de última modificación.
@override final  DateTime actualizadoEn;

/// Create a copy of TipoDeServicio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TipoDeServicioCopyWith<_TipoDeServicio> get copyWith => __$TipoDeServicioCopyWithImpl<_TipoDeServicio>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TipoDeServicio&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.unidad, unidad) || other.unidad == unidad)&&(identical(other.etiquetaContrato, etiquetaContrato) || other.etiquetaContrato == etiquetaContrato)&&(identical(other.activo, activo) || other.activo == activo)&&(identical(other.creadoEn, creadoEn) || other.creadoEn == creadoEn)&&(identical(other.actualizadoEn, actualizadoEn) || other.actualizadoEn == actualizadoEn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,nombre,unidad,etiquetaContrato,activo,creadoEn,actualizadoEn);
}

@override
String toString() {
    return 'TipoDeServicio(id: $id, nombre: $nombre, unidad: $unidad, etiquetaContrato: $etiquetaContrato, activo: $activo, creadoEn: $creadoEn, actualizadoEn: $actualizadoEn)';
}


}

/// @nodoc
abstract mixin class _$TipoDeServicioCopyWith<$Res> implements $TipoDeServicioCopyWith<$Res> {
  factory _$TipoDeServicioCopyWith(_TipoDeServicio value, $Res Function(_TipoDeServicio) _then) = __$TipoDeServicioCopyWithImpl;
@override @useResult
$Res call({
 int? id, NombreDeServicio nombre, UnidadMedida unidad, String? etiquetaContrato, bool activo, DateTime creadoEn, DateTime actualizadoEn
});




}
/// @nodoc
class __$TipoDeServicioCopyWithImpl<$Res>
    implements _$TipoDeServicioCopyWith<$Res> {
  __$TipoDeServicioCopyWithImpl(this._self, this._then);

  final _TipoDeServicio _self;
  final $Res Function(_TipoDeServicio) _then;

/// Create a copy of TipoDeServicio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nombre = null,Object? unidad = null,Object? etiquetaContrato = freezed,Object? activo = null,Object? creadoEn = null,Object? actualizadoEn = null,}) {
  return _then(_TipoDeServicio(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as NombreDeServicio,unidad: null == unidad ? _self.unidad : unidad // ignore: cast_nullable_to_non_nullable
as UnidadMedida,etiquetaContrato: freezed == etiquetaContrato ? _self.etiquetaContrato : etiquetaContrato // ignore: cast_nullable_to_non_nullable
as String?,activo: null == activo ? _self.activo : activo // ignore: cast_nullable_to_non_nullable
as bool,creadoEn: null == creadoEn ? _self.creadoEn : creadoEn // ignore: cast_nullable_to_non_nullable
as DateTime,actualizadoEn: null == actualizadoEn ? _self.actualizadoEn : actualizadoEn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
