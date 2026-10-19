import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/selector_de_unidad.dart';

import '../../../../../helpers/envoltorio_de_prueba.dart';

void main() {
  testWidgets('ofrece las tres unidades del catálogo', (
    WidgetTester tester,
  ) async {
    await montarComponente(
      tester,
      SelectorDeUnidad(
        etiqueta: 'Unidad de medida',
        valor: UnidadMedida.kwh,
        alCambiar: (_) {},
      ),
    );

    expect(find.text('kWh'), findsOneWidget);
    expect(find.text('m³'), findsOneWidget);
    expect(find.text('kg'), findsOneWidget);
  });

  testWidgets('marca la unidad seleccionada', (WidgetTester tester) async {
    await montarComponente(
      tester,
      SelectorDeUnidad(
        etiqueta: 'Unidad de medida',
        valor: UnidadMedida.m3,
        alCambiar: (_) {},
      ),
    );

    final ChoiceChip seleccionado = tester.widget<ChoiceChip>(
      find.byWidgetPredicate((Widget w) => w is ChoiceChip && w.selected),
    );
    expect((seleccionado.label as Text).data, 'm³');
  });

  testWidgets('avisa cuando se elige otra unidad', (WidgetTester tester) async {
    UnidadMedida? elegida;
    await montarComponente(
      tester,
      SelectorDeUnidad(
        etiqueta: 'Unidad de medida',
        valor: UnidadMedida.kwh,
        alCambiar: (UnidadMedida unidad) => elegida = unidad,
      ),
    );

    await tester.tap(find.text('kg'));
    await tester.pump();

    expect(elegida, UnidadMedida.kg);
  });

  testWidgets('muestra el error cuando lo hay', (WidgetTester tester) async {
    await montarComponente(
      tester,
      SelectorDeUnidad(
        etiqueta: 'Unidad de medida',
        valor: null,
        alCambiar: (_) {},
        error: 'Elige la unidad en la que se mide el consumo.',
      ),
    );

    expect(
      find.text('Elige la unidad en la que se mide el consumo.'),
      findsOneWidget,
    );
  });

  testWidgets('bloqueado explica el motivo y no permite cambiar', (
    WidgetTester tester,
  ) async {
    bool cambio = false;
    await montarComponente(
      tester,
      SelectorDeUnidad(
        etiqueta: 'Unidad de medida',
        valor: UnidadMedida.m3,
        alCambiar: (_) => cambio = true,
        habilitado: false,
        motivoBloqueo:
            'No puedes cambiar la unidad porque ya tiene mediciones.',
      ),
    );

    expect(
      find.text('No puedes cambiar la unidad porque ya tiene mediciones.'),
      findsOneWidget,
    );

    await tester.tap(find.text('kg'));
    await tester.pump();

    expect(cambio, isFalse, reason: 'el selector está deshabilitado');
  });
}
