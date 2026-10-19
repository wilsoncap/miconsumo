import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/core/ui/theme/app_theme.dart';
import 'package:miconsumo/core/ui/widgets/estado_de_error.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/view/lista_servicios_page.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/estado_vacio.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/fila_de_servicio.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

import '../../../../helpers/repositorio_de_servicios_falso.dart';

void main() {
  late RepositorioDeServiciosFalso repositorio;

  setUp(() {
    repositorio = RepositorioDeServiciosFalso();
  });

  Future<void> montar(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [servicioRepositoryProvider.overrideWithValue(repositorio)],
        child: MaterialApp(
          theme: AppTheme.claro(),
          locale: const Locale('es', 'CO'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ListaServiciosPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('muestra el estado vacío con su acción', (
    WidgetTester tester,
  ) async {
    await montar(tester);

    expect(find.byType(EstadoVacio), findsOneWidget);
    expect(find.text('Todavía no tienes servicios'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
  });

  testWidgets('no ofrece el botón de agregar cuando está vacío', (
    WidgetTester tester,
  ) async {
    await montar(tester);

    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('muestra una fila por servicio con su unidad', (
    WidgetTester tester,
  ) async {
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
    await repositorio.crearServicio(nombre: 'Agua', unidad: UnidadMedida.m3);

    await montar(tester);

    expect(find.byType(FilaDeServicio), findsNWidgets(2));
    expect(find.text('Luz'), findsOneWidget);
    expect(find.text('kWh'), findsOneWidget);
    expect(find.text('Agua'), findsOneWidget);
    expect(find.text('m³'), findsOneWidget);
    expect(find.byType(EstadoVacio), findsNothing);
  });

  testWidgets('ofrece el botón de agregar cuando ya hay servicios', (
    WidgetTester tester,
  ) async {
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);

    await montar(tester);

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Agregar servicio'), findsOneWidget);
  });

  testWidgets('muestra el estado de error con acción para reintentar', (
    WidgetTester tester,
  ) async {
    repositorio = RepositorioDeServiciosFalso(
      motivoDeFallo: MotivoDeFallo.almacenamiento,
    );

    await montar(tester);

    expect(find.byType(EstadoDeError), findsOneWidget);
    expect(
      find.text('No pudimos guardar los cambios. Inténtalo de nuevo.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
