import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';

/// Valores en edición de un servicio, con sus errores de validación por campo.
///
/// La View NO valida nada: muestra lo que este formulario diga. Si validara,
/// habría dos fuentes de verdad y podrían divergir.
class FormularioDeServicio {
  /// Construye el formulario.
  const FormularioDeServicio({
    this.nombre = '',
    this.unidad,
    this.etiquetaContrato = '',
    this.errorNombre,
    this.errorUnidad,
  });

  /// Nombre en edición.
  final String nombre;

  /// Unidad seleccionada, o nula si aún no se ha elegido.
  final UnidadMedida? unidad;

  /// Etiqueta de contrato en edición. Puede quedar vacía (FR-013).
  final String etiquetaContrato;

  /// Motivo por el que el nombre no es válido, o nulo si lo es.
  ///
  /// Se guarda el motivo y no el texto: el ViewModel no puede traducir nada,
  /// porque no importa Flutter. La View resuelve el texto (FR-002, FR-003).
  final MotivoDeFallo? errorNombre;

  /// Motivo por el que la unidad no es válida, o nulo si lo es (FR-004).
  final MotivoDeFallo? errorUnidad;

  /// Verdadero cuando el formulario puede enviarse.
  bool get esValido => nombre.trim().isNotEmpty && unidad != null;

  static const Object _sinCambio = Object();

  /// Copia el formulario cambiando solo lo indicado.
  FormularioDeServicio copyWith({
    String? nombre,
    UnidadMedida? unidad,
    String? etiquetaContrato,
    Object? errorNombre = _sinCambio,
    Object? errorUnidad = _sinCambio,
  }) {
    return FormularioDeServicio(
      nombre: nombre ?? this.nombre,
      unidad: unidad ?? this.unidad,
      etiquetaContrato: etiquetaContrato ?? this.etiquetaContrato,
      errorNombre: identical(errorNombre, _sinCambio)
          ? this.errorNombre
          : errorNombre as MotivoDeFallo?,
      errorUnidad: identical(errorUnidad, _sinCambio)
          ? this.errorUnidad
          : errorUnidad as MotivoDeFallo?,
    );
  }
}
