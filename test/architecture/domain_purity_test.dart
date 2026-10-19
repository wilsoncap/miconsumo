import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Verifica la regla de arquitectura de la constitución: la capa de dominio es
/// Dart puro y no puede depender de Flutter, de Drift ni de `go_router`.
///
/// Sin esta prueba, la regla dependería de la disciplina de cada quien.
void main() {
  test('el dominio no importa Flutter, Drift ni go_router', () {
    const String carpetaDeFuncionalidades = 'lib/features';
    const List<String> paquetesProhibidos = <String>[
      'package:flutter/',
      'package:drift/',
      'package:go_router/',
    ];

    final List<String> infracciones = <String>[];
    final Directory raiz = Directory(carpetaDeFuncionalidades);

    for (final FileSystemEntity entidad in raiz.listSync(recursive: true)) {
      if (entidad is! File || !entidad.path.endsWith('.dart')) {
        continue;
      }
      if (!entidad.path.contains('/domain/')) {
        continue;
      }

      final String contenido = entidad.readAsStringSync();
      for (final String paquete in paquetesProhibidos) {
        if (contenido.contains("import '$paquete")) {
          infracciones.add('${entidad.path} importa $paquete');
        }
      }
    }

    expect(infracciones, isEmpty, reason: infracciones.join('\n'));
  });
}
