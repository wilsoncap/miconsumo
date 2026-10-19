/// Motivo por el que una operación de dominio no pudo completarse.
///
/// Los errores de negocio son valores, no excepciones: viajan dentro del
/// resultado para que la presentación los muestre sin tener que capturar nada
/// (ver `contracts/repositorio-servicios.md`).
enum MotivoDeFallo {
  /// El nombre quedó vacío tras recortar espacios (FR-002).
  nombreVacio,

  /// El nombre supera la longitud máxima admitida (FR-002).
  nombreDemasiadoLargo,

  /// Ya existe un servicio con el mismo nombre normalizado (FR-003).
  nombreDuplicado,

  /// No se seleccionó unidad de medida (FR-004).
  unidadRequerida,

  /// Se intentó cambiar la unidad de un servicio con historial (FR-006).
  unidadInmutable,

  /// El identificador no corresponde a ningún servicio.
  servicioNoEncontrado,

  /// Fallo del motor de base de datos.
  almacenamiento,
}

/// Resultado de una operación de dominio.
sealed class Resultado<T> {
  const Resultado();

  /// Verdadero cuando la operación se completó.
  bool get esExito => this is Exito<T>;

  /// El valor si la operación se completó, o `null` si falló.
  T? get valorOpcional => switch (this) {
    Exito(:final valor) => valor,
    Fallo() => null,
  };

  /// El motivo si la operación falló, o `null` si se completó.
  MotivoDeFallo? get motivoOpcional => switch (this) {
    Exito() => null,
    Fallo(:final motivo) => motivo,
  };
}

/// Resultado exitoso.
final class Exito<T> extends Resultado<T> {
  const Exito(this.valor);

  final T valor;
}

/// Resultado fallido.
final class Fallo<T> extends Resultado<T> {
  const Fallo(this.motivo);

  final MotivoDeFallo motivo;
}
