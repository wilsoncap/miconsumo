import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/state/servicio_en_lista.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/fila_de_servicio.dart';

import '../../../../../helpers/envoltorio_de_prueba.dart';

void main() {
  const ServicioEnLista servicioActivo = ServicioEnLista(
    id: 1,
    nombre: 'Luz',
    unidad: UnidadMedida.kwh,
    activo: true,
    tieneEtiquetaContrato: false,
  );

  const ServicioEnLista servicioInactivo = ServicioEnLista(
    id: 2,
    nombre: 'Gas',
    unidad: UnidadMedida.kg,
    activo: false,
    tieneEtiquetaContrato: true,
  );

  testWidgets('pinta el nombre y el símbolo de la unidad', (
    WidgetTester tester,
  ) async {
    await montarComponente(
      tester,
      FilaDeServicio(servicio: servicioActivo, alPulsar: () {}),
    );

    expect(find.text('Luz'), findsOneWidget);
    expect(find.text('kWh'), findsOneWidget);
  });

  testWidgets(
    'no muestra la marca de inactivo cuando el servicio está activo',
    (WidgetTester tester) async {
      await montarComponente(
        tester,
        FilaDeServicio(servicio: servicioActivo, alPulsar: () {}),
      );

      expect(find.text('Inactivo'), findsNothing);
    },
  );

  testWidgets(
    'muestra la marca de inactivo cuando el servicio está desactivado',
    (WidgetTester tester) async {
      await montarComponente(
        tester,
        FilaDeServicio(servicio: servicioInactivo, alPulsar: () {}),
      );

      expect(find.text('Inactivo'), findsOneWidget);
    },
  );

  testWidgets('anuncia nombre, unidad y estado a accesibilidad', (
    WidgetTester tester,
  ) async {
    await montarComponente(
      tester,
      FilaDeServicio(servicio: servicioInactivo, alPulsar: () {}),
    );

    expect(
      find.bySemanticsLabel('Gas, kg, Inactivo, Con número de contrato'),
      findsOneWidget,
    );
  });

  testWidgets('avisa cuando se pulsa la fila', (WidgetTester tester) async {
    int pulsaciones = 0;
    await montarComponente(
      tester,
      FilaDeServicio(servicio: servicioActivo, alPulsar: () => pulsaciones++),
    );

    await tester.tap(find.byType(FilaDeServicio));
    await tester.pump();

    expect(pulsaciones, 1);
  });

  testWidgets('la fila tiene un área táctil de al menos 48 dp', (
    WidgetTester tester,
  ) async {
    await montarComponente(
      tester,
      FilaDeServicio(servicio: servicioActivo, alPulsar: () {}),
    );

    final Size tamano = tester.getSize(find.byType(ListTile));
    expect(tamano.height, greaterThanOrEqualTo(48));
  });
}
