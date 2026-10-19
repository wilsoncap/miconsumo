import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/presentation/state/servicio_en_lista.dart';

/// Estados posibles de la pantalla del listado de servicios.
///
/// `Vacio` es distinto de `ConDatos` con lista vacía: la interfaz debe poder
/// mostrar un estado vacío con una acción para crear el primer servicio.
sealed class ListaServiciosEstado {
  const ListaServiciosEstado();
}

/// Se está cargando el listado.
final class ListaCargando extends ListaServiciosEstado {
  /// Construye el estado de carga.
  const ListaCargando();
}

/// No hay ningún servicio todavía.
final class ListaVacia extends ListaServiciosEstado {
  /// Construye el estado vacío.
  const ListaVacia();
}

/// Hay servicios que mostrar.
final class ListaConDatos extends ListaServiciosEstado {
  /// Construye el estado con datos.
  const ListaConDatos({required this.servicios, this.errorParcial});

  /// Servicios a mostrar, en orden estable.
  final List<ServicioEnLista> servicios;

  /// Motivo por el que falló la última acción, si falló.
  ///
  /// Permite avisar sin perder los datos que ya están en pantalla.
  final MotivoDeFallo? errorParcial;
}

/// El listado no pudo cargarse.
final class ListaConError extends ListaServiciosEstado {
  /// Construye el estado de error.
  const ListaConError(this.motivo);

  /// Motivo del fallo.
  final MotivoDeFallo motivo;
}
