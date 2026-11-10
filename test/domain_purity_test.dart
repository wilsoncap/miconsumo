import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('el dominio no depende de Flutter, Drift ni go_router', () {
    final archivos = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((archivo) => archivo.path.contains('/domain/'))
        .where((archivo) => archivo.path.endsWith('.dart'));

    expect(archivos, isNotEmpty);

    for (final archivo in archivos) {
      final contenido = archivo.readAsStringSync();
      expect(
        contenido.contains('package:flutter/'),
        isFalse,
        reason: '${archivo.path} no debe importar Flutter',
      );
      expect(
        contenido.contains('package:drift/'),
        isFalse,
        reason: '${archivo.path} no debe importar Drift',
      );
      expect(
        contenido.contains('package:go_router/'),
        isFalse,
        reason: '${archivo.path} no debe importar go_router',
      );
      expect(
        contenido.contains('package:path_provider/'),
        isFalse,
        reason: '${archivo.path} no debe importar path_provider',
      );
    }
  });
}
