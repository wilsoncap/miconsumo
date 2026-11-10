import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/app/di/providers.dart';
import 'package:miconsumo/features/mediciones/domain/lectura.dart';
import 'package:miconsumo/features/mediciones/presentation/view/consumo_page.dart';
import 'package:miconsumo/features/mediciones/presentation/view/mediciones_page.dart';
import 'package:miconsumo/features/mediciones/presentation/view/registrar_lectura_page.dart';
import 'package:miconsumo/features/servicios/presentation/view/servicio_form_page.dart';

import '../../../support/envoltorio.dart';
import '../../../support/fakes.dart';

void main() {
  inicializarFechasEspanol();

  Widget conRepositorios({required Widget page, List<Lectura>? lecturas}) {
    return ProviderScope(
      overrides: [
        servicioRepositoryProvider.overrideWithValue(
          FakeServicioRepository(servicioDePrueba()),
        ),
        lecturaRepositoryProvider.overrideWithValue(
          FakeLecturaRepository(lecturas),
        ),
      ],
      child: envolverWidget(page),
    );
  }

  testWidgets('el formulario nuevo muestra nombre, unidad y guardar', (
    tester,
  ) async {
    await tester.pumpWidget(
      conRepositorios(page: const ServicioFormPage(servicioId: 0)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nuevo servicio'), findsOneWidget);
    expect(find.text('Nombre del servicio'), findsOneWidget);
    expect(find.text('kWh'), findsOneWidget);
    expect(find.text('m³'), findsOneWidget);
    expect(find.text('kg'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });

  testWidgets('la pantalla de registro muestra fecha, lectura y foto', (
    tester,
  ) async {
    await tester.pumpWidget(
      conRepositorios(page: const RegistrarLecturaPage(servicioId: 1)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Registrar lectura'), findsOneWidget);
    expect(find.text('Luz'), findsOneWidget);
    expect(find.textContaining('Fecha de la lectura:'), findsOneWidget);
    expect(find.text('Lectura del medidor'), findsOneWidget);
    expect(find.text('Foto del medidor (opcional)'), findsOneWidget);
    expect(find.text('Tomar foto'), findsOneWidget);
    expect(find.text('Elegir de la galería'), findsOneWidget);
  });

  testWidgets('el historial muestra lecturas y su consumo', (tester) async {
    final hoy = DateTime.now();
    final lecturas = [
      lecturaDePrueba(
        id: 1,
        fecha: DateTime(hoy.year, hoy.month, 1),
        valor: '100',
      ),
      lecturaDePrueba(
        id: 2,
        fecha: DateTime(hoy.year, hoy.month, 2),
        valor: '112',
      ),
    ];

    await tester.pumpWidget(
      conRepositorios(
        page: const MedicionesPage(servicioId: 1),
        lecturas: lecturas,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mediciones'), findsOneWidget);
    expect(find.text('112 kWh'), findsOneWidget);
    expect(find.text('100 kWh'), findsOneWidget);
    expect(find.text('Sin consumo aún'), findsOneWidget);
    expect(find.text('12 kWh'), findsOneWidget);
    expect(find.text('Registrar lectura'), findsOneWidget);
  });

  testWidgets('consumo muestra la gráfica y las tarjetas', (tester) async {
    final hoy = DateTime.now();
    final lecturas = [
      lecturaDePrueba(
        id: 1,
        fecha: DateTime(hoy.year, hoy.month - 1, 20),
        valor: '80',
      ),
      lecturaDePrueba(
        id: 2,
        fecha: DateTime(hoy.year, hoy.month, 1),
        valor: '100',
      ),
      lecturaDePrueba(
        id: 3,
        fecha: DateTime(hoy.year, hoy.month, 2),
        valor: '112',
      ),
    ];

    await tester.pumpWidget(
      conRepositorios(
        page: const ConsumoPage(servicioId: 1),
        lecturas: lecturas,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Consumo'), findsOneWidget);
    expect(find.text('Este mes'), findsOneWidget);
    expect(find.text('Mes anterior'), findsOneWidget);
    expect(find.text('Variación'), findsOneWidget);
    expect(find.text('Promedio diario'), findsOneWidget);
    expect(find.text('Día de mayor consumo'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
