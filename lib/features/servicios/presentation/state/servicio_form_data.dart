import '../../domain/servicio.dart';
import '../../domain/unidad.dart';

enum ErrorNombreServicio { vacio, duplicado }

enum ErrorGeneralServicio { desconocido, unidadBloqueada }

class ServicioFormData {
  const ServicioFormData({
    required this.nombre,
    required this.unidad,
    required this.contrato,
    this.original,
    this.unidadBloqueada = false,
    this.errorNombre,
    this.errorGeneral,
    this.guardando = false,
  });

  final Servicio? original;
  final String nombre;
  final Unidad unidad;
  final String contrato;
  final bool unidadBloqueada;
  final ErrorNombreServicio? errorNombre;
  final ErrorGeneralServicio? errorGeneral;
  final bool guardando;

  bool get esEdicion => original != null;

  ServicioFormData copyWith({
    String? nombre,
    Unidad? unidad,
    String? contrato,
    bool? unidadBloqueada,
    bool? guardando,
    ErrorNombreServicio? errorNombre,
    bool limpiarErrorNombre = false,
    ErrorGeneralServicio? errorGeneral,
    bool limpiarErrorGeneral = false,
  }) {
    return ServicioFormData(
      original: original,
      nombre: nombre ?? this.nombre,
      unidad: unidad ?? this.unidad,
      contrato: contrato ?? this.contrato,
      unidadBloqueada: unidadBloqueada ?? this.unidadBloqueada,
      guardando: guardando ?? this.guardando,
      errorNombre: limpiarErrorNombre ? null : errorNombre ?? this.errorNombre,
      errorGeneral: limpiarErrorGeneral
          ? null
          : errorGeneral ?? this.errorGeneral,
    );
  }
}
