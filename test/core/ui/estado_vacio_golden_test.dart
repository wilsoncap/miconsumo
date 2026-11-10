import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/ui/widgets/comunes.dart';

import '../../support/envoltorio.dart';

void main() {
  inicializarFechasEspanol();

  testWidgets('golden del estado vacío en claro', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      envolverWidget(
        Scaffold(
          body: EstadoVacio(
            icono: Icons.speed,
            titulo: 'Todavía no hay lecturas',
            mensaje:
                'Anota el número que muestra tu medidor para empezar a ver '
                'tu consumo.',
            accionTexto: 'Registrar la primera',
            onAccion: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/estado_vacio.png'),
    );
  });
}
