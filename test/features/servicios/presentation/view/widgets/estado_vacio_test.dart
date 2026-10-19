import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/estado_vacio.dart';

import '../../../../../helpers/envoltorio_de_prueba.dart';

void main() {
  testWidgets('pinta el título, el mensaje y la acción', (
    WidgetTester tester,
  ) async {
    await montarComponente(
      tester,
      EstadoVacio(
        titulo: 'Todavía no tienes servicios',
        mensaje: 'Registra la luz, el agua o el gas.',
        textoAccion: 'Registrar el primero',
        alPulsar: () {},
      ),
    );

    expect(find.text('Todavía no tienes servicios'), findsOneWidget);
    expect(find.text('Registra la luz, el agua o el gas.'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
  });

  testWidgets('avisa cuando se pulsa la acción', (WidgetTester tester) async {
    int pulsaciones = 0;
    await montarComponente(
      tester,
      EstadoVacio(
        titulo: 'Vacío',
        mensaje: 'Nada que mostrar',
        textoAccion: 'Crear',
        alPulsar: () => pulsaciones++,
      ),
    );

    await tester.tap(find.text('Crear'));
    await tester.pump();

    expect(pulsaciones, 1);
  });

  testWidgets('la acción tiene un área táctil de al menos 48 dp', (
    WidgetTester tester,
  ) async {
    await montarComponente(
      tester,
      EstadoVacio(
        titulo: 'Vacío',
        mensaje: 'Nada que mostrar',
        textoAccion: 'Crear',
        alPulsar: () {},
      ),
    );

    final double alto = tester.getSize(find.byType(FilledButton)).height;
    expect(alto, greaterThanOrEqualTo(48));
  });
}
