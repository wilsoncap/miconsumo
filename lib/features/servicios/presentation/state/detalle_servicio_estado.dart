import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/presentation/state/formulario_de_servicio.dart';

/// Estados posibles de la pantalla de detalle y creación de un servicio.
///
/// La View no recibe la entidad de dominio: solo el formulario y los datos que
/// necesita para pintar.
sealed class DetalleServicioEstado {
  const DetalleServicioEstado();
}

/// Se está cargando el servicio.
final class DetalleCargando extends DetalleServicioEstado {
  /// Construye el estado de carga.
  const DetalleCargando();
}

/// Se está creando un servicio nuevo.
final class DetalleNuevo extends DetalleServicioEstado {
  /// Construye el estado de alta.
  const DetalleNuevo({required this.formulario, this.guardando = false});

  /// Valores en edición.
  final FormularioDeServicio formulario;

  /// Verdadero mientras se guarda, para evitar el doble envío.
  final bool guardando;
}

/// Se está editando un servicio que ya existe.
final class DetalleExistente extends DetalleServicioEstado {
  /// Construye el estado de edición.
  const DetalleExistente({
    required this.id,
    required this.formulario,
    this.guardando = false,
    this.unidadBloqueada = false,
  });

  /// Identificador del servicio en edición.
  final int id;

  /// Valores en edición.
  final FormularioDeServicio formulario;

  /// Verdadero mientras se guarda.
  final bool guardando;

  /// Verdadero cuando el servicio ya tiene mediciones y la unidad no puede
  /// cambiarse (FR-006). En esta funcionalidad siempre es falso, porque aún no
  /// existen mediciones.
  final bool unidadBloqueada;
}

/// El servicio se guardó correctamente.
///
/// El ViewModel no navega: emite este estado y es la View quien decide a dónde
/// ir. Así el ViewModel no depende de `go_router`.
final class DetalleGuardado extends DetalleServicioEstado {
  /// Construye el estado de guardado.
  const DetalleGuardado(this.id);

  /// Identificador del servicio guardado.
  final int id;
}

/// El detalle no pudo cargarse o guardarse.
final class DetalleConError extends DetalleServicioEstado {
  /// Construye el estado de error.
  const DetalleConError(this.motivo);

  /// Motivo del fallo.
  final MotivoDeFallo motivo;
}
