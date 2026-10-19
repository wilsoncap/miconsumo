import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miconsumo/core/ui/theme/app_tokens.dart';
import 'package:miconsumo/l10n/app_localizations.dart';
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
          const PantallaTemporal(),
      routes: <RouteBase>[
        GoRoute(
          path: 'nuevo',
          builder: (BuildContext context, GoRouterState state) =>
              const PantallaTemporal(),
        ),
        GoRoute(
          path: ':${AppRutas.parametroId}',
          builder: (BuildContext context, GoRouterState state) =>
              const PantallaTemporal(),
        ),
      ],
    ),
  ],
);

/// TEMPORAL: pantalla provisional que sustituyen las pantallas de la historia 1.
///
/// Existe para que el proyecto arranque y se pueda comprobar que el tema, la
/// base de datos y la navegación funcionan. Se elimina en T037.
class PantallaTemporal extends StatelessWidget {
  /// Construye la pantalla provisional.
  const PantallaTemporal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).appTitle)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.tokens.espacioXl),
          child: Text(
            AppLocalizations.of(context).pantallaTemporalMensaje,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
