import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miconsumo/app/router/app_router.dart';
import 'package:miconsumo/core/ui/mensaje_de_fallo.dart';
import 'package:miconsumo/core/ui/widgets/estado_de_error.dart';
import 'package:miconsumo/features/servicios/presentation/state/lista_servicios_estado.dart';
import 'package:miconsumo/features/servicios/presentation/state/servicio_en_lista.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/estado_vacio.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/fila_de_servicio.dart';
import 'package:miconsumo/features/servicios/presentation/viewmodel/lista_servicios_viewmodel.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

/// Pantalla que lista los servicios del hogar.
///
/// Solo compone: lee el estado del ViewModel y lo traduce a componentes. No
/// construye partes visuales propias ni contiene lógica de negocio.
class ListaServiciosPage extends ConsumerWidget {
  /// Construye la pantalla.
  const ListaServiciosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations textos = AppLocalizations.of(context);
    final ListaServiciosEstado estado = ref.watch(
      listaServiciosViewModelProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(textos.listaServiciosTitulo)),
      floatingActionButton: estado is ListaConDatos
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRutas.servicioNuevo),
              icon: const Icon(Icons.add),
              label: Text(textos.listaServiciosAgregar),
            )
          : null,
      body: switch (estado) {
        ListaCargando() => const Center(child: CircularProgressIndicator()),
        ListaVacia() => EstadoVacio(
          titulo: textos.listaServiciosVaciaTitulo,
          mensaje: textos.listaServiciosVaciaMensaje,
          textoAccion: textos.listaServiciosVaciaAccion,
          alPulsar: () => context.push(AppRutas.servicioNuevo),
        ),
        ListaConDatos(:final List<ServicioEnLista> servicios) => _Listado(
          servicios: servicios,
        ),
        ListaConError(:final motivo) => EstadoDeError(
          mensaje: mensajeDeFallo(textos, motivo),
          textoAccion: textos.accionReintentar,
          alReintentar: () =>
              ref.read(listaServiciosViewModelProvider.notifier).reintentar(),
        ),
      },
    );
  }
}

/// Listado de servicios, con constructor perezoso.
class _Listado extends StatelessWidget {
  const _Listado({required this.servicios});

  final List<ServicioEnLista> servicios;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: servicios.length,
      itemBuilder: (BuildContext context, int indice) {
        final ServicioEnLista servicio = servicios[indice];
        return FilaDeServicio(
          servicio: servicio,
          alPulsar: () => context.push(AppRutas.servicioDetalle(servicio.id)),
        );
      },
    );
  }
}
