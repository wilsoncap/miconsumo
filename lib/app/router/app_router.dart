import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miconsumo/features/servicios/presentation/view/detalle_servicio_page.dart';
import 'package:miconsumo/features/servicios/presentation/view/lista_servicios_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Rutas de la aplicación, declaradas en un único lugar.
///
/// Ninguna pantalla conoce la ruta de otra: la navegación se pide por aquí.
abstract final class AppRutas {
  /// Listado de servicios.
  static const String servicios = '/servicios';

  /// Alta de un servicio nuevo.
  static const String servicioNuevo = '/servicios/nuevo';

  /// Detalle de un servicio existente.
  static String servicioDetalle(int id) => '/servicios/$id';

  /// Nombre del parámetro de ruta con el identificador del servicio.
  static const String parametroId = 'id';
}

/// Router de la aplicación.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: AppRutas.servicios,
  routes: <RouteBase>[
    GoRoute(
      path: AppRutas.servicios,
      builder: (BuildContext context, GoRouterState state) =>
          const ListaServiciosPage(),
      routes: <RouteBase>[
        // 'nuevo' se declara antes que ':id' para que no lo capture el
        // parámetro.
        GoRoute(
          path: 'nuevo',
          builder: (BuildContext context, GoRouterState state) =>
              const DetalleServicioPage(),
        ),
        GoRoute(
          path: ':${AppRutas.parametroId}',
          builder: (BuildContext context, GoRouterState state) =>
              DetalleServicioPage(
                servicioId: int.tryParse(
                  state.pathParameters[AppRutas.parametroId] ?? '',
                ),
              ),
        ),
      ],
    ),
  ],
);
