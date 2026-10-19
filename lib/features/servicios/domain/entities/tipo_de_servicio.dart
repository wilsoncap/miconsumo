import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/nombre_de_servicio.dart';
import '../value_objects/unidad_medida.dart';

part 'tipo_de_servicio.freezed.dart';

/// Un servicio recibido en el hogar: luz, agua o gas.
///
/// Entidad del dominio, en Dart puro. `id` es nulo mientras el servicio no se
/// ha guardado: el repositorio lo devuelve con el identificador asignado.
@freezed
abstract class TipoDeServicio with _$TipoDeServicio {
  const factory TipoDeServicio({
    /// Identificador asignado por el sistema. Nulo si aún no se ha guardado.
    int? id,

    /// Nombre del servicio, con su forma normalizada.
    required NombreDeServicio nombre,

    /// Unidad en la que se mide su consumo.
    required UnidadMedida unidad,

    /// Etiqueta de contrato opcional. De uso estrictamente local (FR-013, FR-014).
    String? etiquetaContrato,

    /// Falso cuando el servicio está desactivado. Un servicio nunca se elimina.
    required bool activo,

    /// Marca de captura.
    required DateTime creadoEn,

    /// Marca de última modificación.
    required DateTime actualizadoEn,
  }) = _TipoDeServicio;
}
