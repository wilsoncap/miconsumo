import 'package:miconsumo/core/error/resultado.dart';

import '../entities/tipo_de_servicio.dart';
import '../value_objects/unidad_medida.dart';

/// Contrato de acceso a los tipos de servicio.
///
/// Vive en el dominio y no conoce Drift, Flutter ni `go_router`. La capa de
/// datos lo implementa (ver `contracts/repositorio-servicios.md`).
///
/// NO existe operación de borrado: un servicio solo se desactiva (FR-015).
abstract interface class ServicioRepository {
  /// Servicios activos e inactivos, en orden estable por nombre.
  ///
  /// Es un FLUJO, no una foto: vuelve a emitir cada vez que los datos cambian,
  /// sin importar quién los haya cambiado ni desde qué pantalla. Así el listado
  /// no puede quedarse desactualizado.
  Stream<Resultado<List<TipoDeServicio>>> observarServicios();

  /// Un servicio concreto por su identificador.
  Future<Resultado<TipoDeServicio>> obtenerServicio(int id);

  /// Crea un servicio validando nombre, unidad y duplicados.
  Future<Resultado<TipoDeServicio>> crearServicio({
    required String nombre,
    required UnidadMedida unidad,
    String? etiquetaContrato,
  });

  /// Actualiza nombre y etiqueta de contrato. No acepta la unidad: cambiarla
  /// exige pasar por [cambiarUnidad], que aplica la regla de inmutabilidad.
  Future<Resultado<TipoDeServicio>> actualizarServicio({
    required int id,
    required String nombre,
    String? etiquetaContrato,
  });

  /// Cambia la unidad. Falla con [MotivoDeFallo.unidadInmutable] si el servicio
  /// ya tiene mediciones (FR-006).
  Future<Resultado<TipoDeServicio>> cambiarUnidad({
    required int id,
    required UnidadMedida unidad,
  });

  /// Desactiva un servicio sin borrarlo (FR-007).
  Future<Resultado<TipoDeServicio>> desactivarServicio(int id);

  /// Vuelve a activar un servicio desactivado (FR-010).
  Future<Resultado<TipoDeServicio>> reactivarServicio(int id);
}
