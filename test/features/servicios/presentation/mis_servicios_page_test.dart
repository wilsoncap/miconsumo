import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/features/servicios/domain/unidad.dart';
import 'package:miconsumo/features/servicios/presentation/providers.dart';
import 'package:miconsumo/features/servicios/presentation/view/mis_servicios_page.dart';

import '../../../support/envoltorio.dart';
import '../../../support/fakes.dart';

void main() {
  inicializarFechasEspanol();

  testWidgets('muestra el estado vacío sin servicios', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          serviciosProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: envolverWidget(const MisServiciosPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis servicios'), findsOneWidget);
    expect(find.text('Todavía no tienes servicios'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('lista servicios con unidad, contrato y estado', (tester) async {
    final luz = servicioDePrueba(id: 1, nombre: 'Luz');
    final gas = servicioDePrueba(
      id: 2,
      nombre: 'Gas',
      unidad: Unidad.m3,
      activo: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          serviciosProvider.overrideWith((ref) => Stream.value([luz, gas])),
        ],
        child: envolverWidget(const MisServiciosPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Luz'), findsOneWidget);
    expect(find.text('kWh'), findsOneWidget);
    expect(find.text('Gas'), findsOneWidget);
    expect(find.text('m³'), findsOneWidget);
    expect(find.text('Inactivo'), findsOneWidget);
    expect(find.byIcon(Icons.toggle_off), findsOneWidget);
    expect(find.byIcon(Icons.toggle_on), findsOneWidget);
    expect(find.text('Agregar servicio'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
