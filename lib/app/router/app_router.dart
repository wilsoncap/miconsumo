import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/mediciones/presentation/view/consumo_page.dart';
import '../../features/mediciones/presentation/view/foto_viewer_page.dart';
import '../../features/mediciones/presentation/view/mediciones_page.dart';
import '../../features/mediciones/presentation/view/registrar_lectura_page.dart';
import '../../features/servicios/presentation/view/mis_servicios_page.dart';
import '../../features/servicios/presentation/view/servicio_form_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MisServiciosPage()),
      GoRoute(
        path: '/servicios/nuevo',
        builder: (context, state) => const ServicioFormPage(servicioId: 0),
      ),
      GoRoute(
        path: '/servicios/:id/editar',
        builder: (context, state) => ServicioFormPage(
          servicioId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/servicios/:id/mediciones',
        builder: (context, state) => MedicionesPage(
          servicioId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/servicios/:id/mediciones/nueva',
        builder: (context, state) => RegistrarLecturaPage(
          servicioId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/servicios/:id/consumo',
        builder: (context, state) => ConsumoPage(
          servicioId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/foto',
        builder: (context, state) =>
            FotoViewerPage(rutaRelativa: state.uri.queryParameters['ruta']),
      ),
    ],
  );
});
