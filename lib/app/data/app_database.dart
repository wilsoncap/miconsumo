import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ServicioRow')
class Servicios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 60)();
  TextColumn get nombreNormalizado => text().unique()();
  TextColumn get unidad => text()();
  TextColumn get etiquetaContrato => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime()();
  DateTimeColumn get actualizadoEn => dateTime()();
}

@DataClassName('LecturaRow')
class Lecturas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get servicioId => integer().references(Servicios, #id)();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get valor => text()();
  TextColumn get rutaFoto => text().nullable()();
  TextColumn get estado => text().withDefault(const Constant('vigente'))();
  IntColumn get reemplazaA => integer().nullable()();
  DateTimeColumn get creadaEn => dateTime()();
}

@DriftDatabase(tables: [Servicios, Lecturas])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // Migración 1 → 2: crear Lecturas; no tocar Servicios.
      // Reversión: DROP TABLE IF EXISTS lecturas;
      if (from < 2) {
        await migrator.createTable(lecturas);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

Future<AppDatabase> abrirBaseDeDatos() async {
  final directorio = await getApplicationDocumentsDirectory();
  final archivo = File(p.join(directorio.path, 'miconsumo.sqlite'));
  return AppDatabase(NativeDatabase.createInBackground(archivo));
}
