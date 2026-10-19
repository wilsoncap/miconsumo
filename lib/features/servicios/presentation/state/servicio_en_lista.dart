import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/unidad_visible.dart';

/// Lo mínimo que la fila del listado necesita pintar.
///
/// La View NO recibe la entidad de dominio: así no puede depender de su forma ni
/// acceder a campos que no le corresponden (contrato de ViewModel).
class ServicioEnLista {
  /// Construye el modelo de presentación.
  const ServicioEnLista({
    required this.id,
    required this.nombre,
    required this.unidad,
    required this.activo,
    required this.tieneEtiquetaContrato,
  });

  /// Lo construye a partir de la entidad de dominio.
  ///
  /// Solo se usa con servicios que ya vienen de la base de datos, por lo que el
  /// identificador siempre está presente.
  factory ServicioEnLista.desdeDominio(TipoDeServicio servicio) =>
      ServicioEnLista(
        id: servicio.id!,
        nombre: servicio.nombre.valor,
        unidad: servicio.unidad,
        activo: servicio.activo,
        tieneEtiquetaContrato: servicio.etiquetaContrato != null,
      );

  /// Identificador del servicio.
  final int id;

  /// Nombre tal como lo escribió el usuario.
  final String nombre;

  /// Unidad en la que se mide su consumo.
  final UnidadMedida unidad;

  /// Falso cuando el servicio está desactivado.
  final bool activo;

  /// Verdadero si el servicio tiene etiqueta de contrato.
  final bool tieneEtiquetaContrato;

  /// Símbolo visible de la unidad, listo para pintar.
  String get simboloUnidad => simboloDeUnidad(unidad);
}
