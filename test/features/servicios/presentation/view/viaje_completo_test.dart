import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/app/router/app_router.dart';
import 'package:miconsumo/core/ui/theme/app_theme.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/estado_vacio.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/fila_de_servicio.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

import '../../../../helpers/repositorio_de_servicios_falso.dart';

/// Prueba del viaje completo: listado → crear → volver al listado.
///
/// Esta es la prueba que faltaba y por la que el listado se quedaba con una foto
/// vieja de los datos. Monta las pantallas reales con el router real, así que
/// cubre también las rutas y la navegación.
void main() {
  late RepositorioDeServiciosFalso repositorio;

  setUp(() {
    repositorio = RepositorioDeServiciosFalso();
  });

  Future<void> montarApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [servicioRepositoryProvider.overrideWithValue(repositorio)],
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) =>
              MaterialApp.router(
                theme: AppTheme.claro(),
                locale: const Locale('es', 'CO'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: ref.watch(appRouterProvider),
              ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Rellena el formulario del detalle y guarda.
  Future<void> crearServicio(
    WidgetTester tester, {
    required String nombre,
    required String unidad,
  }) async {
    await tester.enterText(find.byType(TextField).first, nombre);
    await tester.pump();
    await tester.tap(find.text(unidad));
    await tester.pump();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
  }

  testWidgets('el servicio creado aparece en el listado al volver', (
    WidgetTester tester,
  ) async {
    await montarApp(tester);
    expect(find.byType(EstadoVacio), findsOneWidget);

    await tester.tap(find.text('Registrar el primero'));
    await tester.pumpAndSettle();

    await crearServicio(tester, nombre: 'Luz', unidad: 'kWh');

    expect(find.byType(FilaDeServicio), findsOneWidget);
    expect(find.text('Luz'), findsOneWidget);
    expect(find.byType(EstadoVacio), findsNothing);
  });

  testWidgets('crear dos servicios seguidos los muestra a los dos', (
    WidgetTester tester,
  ) async {
    await montarApp(tester);

    await tester.tap(find.text('Registrar el primero'));
    await tester.pumpAndSettle();
    await crearServicio(tester, nombre: 'Luz', unidad: 'kWh');

    await tester.tap(find.text('Agregar servicio'));
    await tester.pumpAndSettle();
    await crearServicio(tester, nombre: 'Agua', unidad: 'm³');

    expect(find.byType(FilaDeServicio), findsNWidgets(2));
    expect(find.text('Luz'), findsOneWidget);
    expect(find.text('Agua'), findsOneWidget);
  });

  testWidgets('editar un servicio se refleja en el listado', (
    WidgetTester tester,
  ) async {
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
    await montarApp(tester);
    expect(find.text('Luz'), findsOneWidget);

    await tester.tap(find.byType(FilaDeServicio));
    await tester.pumpAndSettle();
    await crearServicio(tester, nombre: 'Luz principal', unidad: 'kWh');

    expect(find.text('Luz principal'), findsOneWidget);
    expect(find.text('Luz'), findsNothing);
  });

  testWidgets('desactivar un servicio se refleja en el listado', (
    WidgetTester tester,
  ) async {
    final int id = (await repositorio.crearServicio(
      nombre: 'Gas',
      unidad: UnidadMedida.kg,
    )).valorOpcional!.id!;
    await montarApp(tester);
    expect(find.text('Inactivo'), findsNothing);

    await repositorio.desactivarServicio(id);
    await tester.pumpAndSettle();

    expect(find.text('Inactivo'), findsOneWidget);
  });
}
