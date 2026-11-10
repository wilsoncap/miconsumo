import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/app/data/app_database.dart';
import 'package:miconsumo/core/error/errores.dart';
import 'package:miconsumo/features/mediciones/data/lectura_repository_drift.dart';
import 'package:miconsumo/features/mediciones/data/photo_storage.dart';
import 'package:miconsumo/features/mediciones/domain/lectura.dart';
import 'package:miconsumo/features/servicios/data/servicio_repository_drift.dart';
import 'package:miconsumo/features/servicios/domain/unidad.dart';

void main() {
  late AppDatabase db;
  late ServicioRepositoryDrift servicios;
  late LecturaRepositoryDrift lecturas;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    servicios = ServicioRepositoryDrift(db);
    lecturas = LecturaRepositoryDrift(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ServicioRepositoryDrift', () {
    test('crea servicios y evita nombres duplicados con acentos', () async {
      final id = await servicios.crearServicio(
        nombre: 'Luz',
        unidad: Unidad.kwh,
        etiquetaContrato: '12345-2026',
      );
      expect(id, isPositive);
      expect(await servicios.obtenerServicio(id), isNotNull);
      expect(
        () => servicios.crearServicio(nombre: 'LÚZ', unidad: Unidad.kwh),
        throwsA(isA<NombreDuplicadoException>()),
      );
    });

    test('bloquea el cambio de unidad cuando ya hay lecturas', () async {
      final id = await servicios.crearServicio(
        nombre: 'Agua',
        unidad: Unidad.m3,
      );
      await lecturas.registrarLectura(
        servicioId: id,
        fecha: DateTime(2026, 11, 1),
        valor: Decimal.parse('100'),
      );

      expect(
        () => servicios.actualizarServicio(
          id: id,
          nombre: 'Agua',
          unidad: Unidad.kg,
        ),
        throwsA(isA<UnidadBloqueadaException>()),
      );
    });

    test('activa y desactiva sin borrar', () async {
      final id = await servicios.crearServicio(
        nombre: 'Gas',
        unidad: Unidad.m3,
      );
      await servicios.cambiarActivo(id, activo: false);
      expect((await servicios.obtenerServicio(id))!.activo, isFalse);
      await servicios.cambiarActivo(id, activo: true);
      expect((await servicios.obtenerServicio(id))!.activo, isTrue);
    });
  });

  group('LecturaRepositoryDrift', () {
    test('corrige una lectura del mismo día y conserva la anterior', () async {
      final servicioId = await servicios.crearServicio(
        nombre: 'Luz',
        unidad: Unidad.kwh,
      );
      final primera = await lecturas.registrarLectura(
        servicioId: servicioId,
        fecha: DateTime(2026, 11, 13),
        valor: Decimal.parse('44970'),
      );
      final segunda = await lecturas.registrarLectura(
        servicioId: servicioId,
        fecha: DateTime(2026, 11, 13),
        valor: Decimal.parse('44978'),
      );

      final todas = await lecturas.obtenerLecturas(servicioId);
      final anterior = todas.firstWhere((lectura) => lectura.id == primera);
      final actual = todas.firstWhere((lectura) => lectura.id == segunda);

      expect(actual.esVigente, isTrue);
      expect(actual.valor, Decimal.parse('44978'));
      expect(actual.reemplazaA, primera);
      expect(anterior.estado, EstadoLectura.reemplazada);
    });

    test('busca la lectura vigente anterior a una fecha', () async {
      final servicioId = await servicios.crearServicio(
        nombre: 'Luz',
        unidad: Unidad.kwh,
      );
      await lecturas.registrarLectura(
        servicioId: servicioId,
        fecha: DateTime(2026, 11, 1),
        valor: Decimal.parse('100'),
      );
      await lecturas.registrarLectura(
        servicioId: servicioId,
        fecha: DateTime(2026, 11, 10),
        valor: Decimal.parse('150'),
      );

      final anterior = await lecturas.lecturaVigenteAntesDe(
        servicioId,
        DateTime(2026, 11, 20),
      );
      expect(anterior?.valor, Decimal.parse('150'));
    });

    test('guarda la ruta de foto y no la pierde al corregir', () async {
      final servicioId = await servicios.crearServicio(
        nombre: 'Luz',
        unidad: Unidad.kwh,
      );
      await lecturas.registrarLectura(
        servicioId: servicioId,
        fecha: DateTime(2026, 11, 29),
        valor: Decimal.parse('45151'),
        rutaFoto: 'fotos_medidor/medidor_1.jpg',
      );
      await lecturas.registrarLectura(
        servicioId: servicioId,
        fecha: DateTime(2026, 11, 29),
        valor: Decimal.parse('45152'),
      );

      final todas = await lecturas.obtenerLecturas(servicioId);
      expect(
        todas.any(
          (lectura) => lectura.rutaFoto == 'fotos_medidor/medidor_1.jpg',
        ),
        isTrue,
      );
    });
  });

  group('AlmacenamientoFotosLocal', () {
    test('copia la foto con un nombre nuevo y nunca sobrescribe', () async {
      final raiz = await Directory.systemTemp.createTemp('miconsumo_fotos_');
      addTearDown(() => raiz.delete(recursive: true));
      final origen = File('${raiz.path}/origen.jpg')..writeAsStringSync('foto');

      final almacenamiento = AlmacenamientoFotosLocal(
        directorioBase: () async => raiz,
      );
      final primera = await almacenamiento.guardarDesde(origen.path);
      final segunda = await almacenamiento.guardarDesde(origen.path);

      expect(primera, isNot(segunda));
      expect(await almacenamiento.existe(primera), isTrue);
      expect(await almacenamiento.existe(segunda), isTrue);
      expect(File('${raiz.path}/$primera').readAsStringSync(), 'foto');
    });
  });
}
