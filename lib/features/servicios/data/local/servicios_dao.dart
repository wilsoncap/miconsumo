import 'package:drift/drift.dart';

import 'app_database.dart';

part 'servicios_dao.g.dart';

/// Acceso a la tabla de servicios.
///
/// No expone ninguna operación de borrado: es deliberado (FR-015).
@DriftAccessor(tables: [Servicios])
class ServiciosDao extends DatabaseAccessor<AppDatabase>
    with _$ServiciosDaoMixin {
  ServiciosDao(super.db);

  /// Todos los servicios, activos e inactivos, en orden estable por nombre
  /// normalizado, para que la interfaz no "salte" entre reconstrucciones.
  Future<List<Servicio>> listar() {
    final SimpleSelectStatement<$ServiciosTable, Servicio> consulta = select(
      servicios,
    )..orderBy([(t) => OrderingTerm.asc(t.nombreNormalizado)]);
    return consulta.get();
  }

  /// Flujo con todos los servicios.
  ///
  /// Vuelve a emitir ante cualquier cambio en la tabla, venga de donde venga.
  /// Es lo que permite que el listado se actualice solo y no se quede con una
  /// foto vieja de los datos.
  Stream<List<Servicio>> observar() {
    final SimpleSelectStatement<$ServiciosTable, Servicio> consulta = select(
      servicios,
    )..orderBy([(t) => OrderingTerm.asc(t.nombreNormalizado)]);
    return consulta.watch();
  }

  /// Un servicio por su identificador, o nulo si no existe.
  Future<Servicio?> buscarPorId(int id) {
    final SimpleSelectStatement<$ServiciosTable, Servicio> consulta = select(
      servicios,
    )..where((t) => t.id.equals(id));
    return consulta.getSingleOrNull();
  }

  /// Busca por nombre normalizado, para detectar duplicados (FR-003).
  Future<Servicio?> buscarPorNombreNormalizado(String normalizado) {
    final SimpleSelectStatement<$ServiciosTable, Servicio> consulta = select(
      servicios,
    )..where((t) => t.nombreNormalizado.equals(normalizado));
    return consulta.getSingleOrNull();
  }

  /// Inserta y devuelve la fila creada, con su identificador asignado.
  Future<Servicio> insertar(ServiciosCompanion datos) =>
      into(servicios).insertReturning(datos);

  /// Actualiza una fila existente y devuelve el resultado.
  Future<Servicio> actualizar(ServiciosCompanion datos) async {
    final List<Servicio> filas = await (update(
      servicios,
    )..where((t) => t.id.equals(datos.id.value))).writeReturning(datos);
    return filas.single;
  }
}
