import 'package:drift/drift.dart';

import 'servicios_dao.dart';

part 'app_database.g.dart';

/// Tabla de tipos de servicio.
///
/// El índice único sobre `nombreNormalizado` refuerza en la base de datos la
/// regla de unicidad de FR-003, que el dominio calcula en `NombreDeServicio`.
/// No hay ninguna columna de borrado: un servicio solo se desactiva (FR-015).
@TableIndex(
  name: 'servicios_nombre_normalizado',
  columns: {#nombreNormalizado},
  unique: true,
)
class Servicios extends Table {
  /// Identificador asignado por el sistema.
  IntColumn get id => integer().autoIncrement()();

  /// Nombre tal como lo escribió el usuario.
  TextColumn get nombre => text().withLength(min: 1, max: 60)();

  /// Forma normalizada del nombre, sin acentos y en minúsculas.
  TextColumn get nombreNormalizado => text()();

  /// Código de la unidad de medida (`kwh`, `m3`, `kg`).
  TextColumn get unidad => text()();

  /// Etiqueta de contrato opcional. De uso estrictamente local.
  TextColumn get etiquetaContrato => text().nullable()();

  /// Falso cuando el servicio está desactivado.
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  /// Marca de captura.
  DateTimeColumn get creadoEn => dateTime()();

  /// Marca de última modificación.
  DateTimeColumn get actualizadoEn => dateTime()();
}

/// Base de datos local de la aplicación.
///
/// Esquema versión 1. Toda migración futura DEBE declararse en `onUpgrade` y
/// acompañarse de una prueba que verifique que los datos sobreviven.
@DriftDatabase(tables: [Servicios], daos: [ServiciosDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Todavía no hay migraciones: el esquema sigue en la versión 1.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
