import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/nombre_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';

import '../local/app_database.dart';

/// Traduce entre la fila de Drift y la entidad de dominio.
///
/// Es el único punto donde se conoce la forma guardada, de modo que un cambio de
/// esquema no obligue a tocar el dominio ni la presentación.
extension ServicioFilaMapper on Servicio {
  /// Convierte la fila en la entidad de dominio.
  TipoDeServicio aDominio() => TipoDeServicio(
    id: id,
    nombre: NombreDeServicio(nombre),
    unidad: unidadDesdeCodigo(unidad),
    etiquetaContrato: etiquetaContrato,
    activo: activo,
    creadoEn: creadoEn,
    actualizadoEn: actualizadoEn,
  );
}

/// Código con el que se guarda una unidad de medida en la base de datos.
String codigoDeUnidad(UnidadMedida unidad) => unidad.name;

/// Unidad de medida a partir de su código guardado.
///
/// Lanza [ArgumentError] si el código no corresponde a ninguna unidad conocida:
/// eso solo puede ocurrir si los datos se corrompieron.
UnidadMedida unidadDesdeCodigo(String codigo) => UnidadMedida.values.firstWhere(
  (UnidadMedida unidad) => unidad.name == codigo,
  orElse: () => throw ArgumentError.value(
    codigo,
    'codigo',
    'Unidad de medida desconocida',
  ),
);
