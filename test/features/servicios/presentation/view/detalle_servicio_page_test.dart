import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:miconsumo/core/ui/theme/app_theme.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/view/detalle_servicio_page.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/campo_de_texto.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/selector_de_unidad.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

import '../../../../helpers/repositorio_de_servicios_falso.dart';

void main() {
  late RepositorioDeServiciosFalso repositorio;

  setUp(() {
    repositorio = RepositorioDeServiciosFalso();
  });

  Future<void> montar(WidgetTester tester, {int? servicioId}) async {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              DetalleServicioPage(servicioId: servicioId),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [servicioRepositoryProvider.overrideWithValue(repositorio)],
        child: MaterialApp.router(
          theme: AppTheme.claro(),
          locale: const Locale('es', 'CO'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('muestra el formulario de creación con sus campos', (
    WidgetTester tester,
  ) async {
    await montar(tester);

    expect(find.text('Nuevo servicio'), findsOneWidget);
    expect(find.byType(CampoDeTexto), findsNWidgets(2));
    expect(find.byType(SelectorDeUnidad), findsOneWidget);
    expect(find.text('Nombre del servicio'), findsOneWidget);
    expect(find.text('Número de contrato (opcional)'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });

  testWidgets('muestra los errores al guardar sin datos', (
    WidgetTester tester,
  ) async {
    await montar(tester);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe un nombre para el servicio.'), findsOneWidget);
    expect(
      find.text('Elige la unidad en la que se mide el consumo.'),
      findsOneWidget,
    );
    expect(repositorio.servicios, isEmpty);
  });

  testWidgets('guarda un servicio válido con su unidad y su contrato', (
    WidgetTester tester,
  ) async {
    await montar(tester);

    await tester.enterText(find.byType(TextField).first, 'Luz');
    await tester.pump();
    await tester.tap(find.text('kWh'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).last, '12345-2026');
    await tester.pump();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(repositorio.servicios, hasLength(1));
    expect(repositorio.servicios.single.nombre.valor, 'Luz');
    expect(repositorio.servicios.single.unidad, UnidadMedida.kwh);
    expect(repositorio.servicios.single.etiquetaContrato, '12345-2026');
  });

  testWidgets('avisa del nombre duplicado sin salir de la pantalla', (
    WidgetTester tester,
  ) async {
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);

    await montar(tester);
    await tester.enterText(find.byType(TextField).first, 'luz');
    await tester.pump();
    await tester.tap(find.text('kWh'));
    await tester.pump();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Ya tienes un servicio con ese nombre.'), findsOneWidget);
    expect(repositorio.servicios, hasLength(1));
  });

  testWidgets('carga un servicio existente en el formulario', (
    WidgetTester tester,
  ) async {
    final int id = (await repositorio.crearServicio(
      nombre: 'Agua',
      unidad: UnidadMedida.m3,
      etiquetaContrato: '999',
    )).valorOpcional!.id!;

    await montar(tester, servicioId: id);

    expect(find.text('Editar servicio'), findsOneWidget);
    expect(find.text('Agua'), findsOneWidget);
    expect(find.text('999'), findsOneWidget);
  });

  testWidgets('permite editar sin crear un servicio nuevo', (
    WidgetTester tester,
  ) async {
    final int id = (await repositorio.crearServicio(
      nombre: 'Agua',
      unidad: UnidadMedida.m3,
    )).valorOpcional!.id!;

    await montar(tester, servicioId: id);
    await tester.enterText(find.byType(TextField).first, 'Agua potable');
    await tester.pump();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(repositorio.servicios, hasLength(1));
    expect(repositorio.servicios.single.nombre.valor, 'Agua potable');
  });
}
