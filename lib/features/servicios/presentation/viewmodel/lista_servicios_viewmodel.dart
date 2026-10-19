import 'dart:async';

import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/repositories/servicio_repository.dart';
import 'package:miconsumo/features/servicios/presentation/state/lista_servicios_estado.dart';
import 'package:miconsumo/features/servicios/presentation/state/servicio_en_lista.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lista_servicios_viewmodel.g.dart';

/// ViewModel del listado de servicios.
///
/// Se SUSCRIBE al flujo de datos del repositorio en lugar de pedir una foto una
/// sola vez. Así el listado se actualiza solo cuando algo cambia, sin importar
/// quién lo haya cambiado ni desde qué pantalla.
///
/// NO importa Flutter: usa `package:riverpod_annotation` y `package:riverpod`,
/// nunca `flutter_riverpod`. Por eso se puede probar sin `WidgetTester`.
@riverpod
class ListaServiciosViewModel extends _$ListaServiciosViewModel {
  @override
  ListaServiciosEstado build() {
    final ServicioRepository repositorio = ref.watch(
      servicioRepositoryProvider,
    );
    final StreamSubscription<Resultado<List<TipoDeServicio>>> suscripcion =
        repositorio.observarServicios().listen(_alRecibirDatos);
    ref.onDispose(() => unawaited(suscripcion.cancel()));

    return const ListaCargando();
  }

  /// Vuelve a suscribirse al flujo de datos.
  ///
  /// Se usa desde el estado de error: como el flujo ya terminó, la única forma
  /// de volver a intentarlo es reconstruir el ViewModel.
  void reintentar() => ref.invalidateSelf();

  /// Traduce cada emisión del flujo al estado de la interfaz.
  void _alRecibirDatos(Resultado<List<TipoDeServicio>> resultado) {
    state = switch (resultado) {
      Exito(:final List<TipoDeServicio> valor) when valor.isEmpty =>
        const ListaVacia(),
      Exito(:final List<TipoDeServicio> valor) => ListaConDatos(
        servicios: valor
            .map(ServicioEnLista.desdeDominio)
            .toList(growable: false),
      ),
      Fallo(:final MotivoDeFallo motivo) => ListaConError(motivo),
    };
  }
}
