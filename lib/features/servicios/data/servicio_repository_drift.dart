import 'package:drift/drift.dart';

import '../../../core/error/errores.dart';
import '../../../core/utils/texto.dart';
import '../../../app/data/app_database.dart';
import '../domain/servicio.dart';
import '../domain/servicio_repository.dart';
import '../domain/unidad.dart';

class ServicioRepositoryDrift implements ServicioRepository {
  ServicioRepositoryDrift(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Servicio>> observarServicios() {
    final consulta = _db.select(_db.servicios)
      ..orderBy([
        (tabla) => OrderingTerm(expression: tabla.creadoEn),
        (tabla) => OrderingTerm(expression: tabla.id),
      ]);
    return consulta.watch().map(
      (filas) => filas.map(_aDominio).toList(growable: false),
    );
  }

  @override
  Stream<Servicio?> observarServicio(int id) {
    final consulta = _db.select(_db.servicios)
      ..where((tabla) => tabla.id.equals(id));
    return consulta.watchSingleOrNull().map(
      (fila) => fila == null ? null : _aDominio(fila),
    );
  }

  @override
  Future<Servicio?> obtenerServicio(int id) async {
    final consulta = _db.select(_db.servicios)
      ..where((tabla) => tabla.id.equals(id));
    final fila = await consulta.getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  @override
  Future<int> crearServicio({
    required String nombre,
    required Unidad unidad,
    String? etiquetaContrato,
  }) async {
    final nombreLimpio = nombre.trim();
    final normalizado = normalizarNombre(nombreLimpio);
    if (await _existeNormalizado(normalizado)) {
      throw const NombreDuplicadoException();
    }

    final ahora = DateTime.now();
    return _db
        .into(_db.servicios)
        .insert(
          ServiciosCompanion.insert(
            nombre: nombreLimpio,
            nombreNormalizado: normalizado,
            unidad: unidad.name,
            etiquetaContrato: Value(_limpiarContrato(etiquetaContrato)),
            creadoEn: ahora,
            actualizadoEn: ahora,
          ),
        );
  }

  @override
  Future<void> actualizarServicio({
    required int id,
    required String nombre,
    required Unidad unidad,
    String? etiquetaContrato,
  }) async {
    final actual = await obtenerServicio(id);
    if (actual == null) {
      throw const ServicioNoEncontradoException();
    }

    final normalizado = normalizarNombre(nombre);
    if (await _existeNormalizado(normalizado, excluirId: id)) {
      throw const NombreDuplicadoException();
    }

    if (unidad != actual.unidad) {
      final lecturas = await _contarLecturas(id);
      if (lecturas > 0) {
        throw const UnidadBloqueadaException();
      }
    }

    await (_db.update(
      _db.servicios,
    )..where((tabla) => tabla.id.equals(id))).write(
      ServiciosCompanion(
        nombre: Value(nombre.trim()),
        nombreNormalizado: Value(normalizado),
        unidad: Value(unidad.name),
        etiquetaContrato: Value(_limpiarContrato(etiquetaContrato)),
        actualizadoEn: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> cambiarActivo(int id, {required bool activo}) async {
    await (_db.update(
      _db.servicios,
    )..where((tabla) => tabla.id.equals(id))).write(
      ServiciosCompanion(
        activo: Value(activo),
        actualizadoEn: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<bool> existeNombre(String nombre, {int? excluirId}) {
    return _existeNormalizado(normalizarNombre(nombre), excluirId: excluirId);
  }

  Future<bool> _existeNormalizado(String normalizado, {int? excluirId}) async {
    final consulta = _db.select(_db.servicios)
      ..where((tabla) => tabla.nombreNormalizado.equals(normalizado));
    if (excluirId != null) {
      consulta.where((tabla) => tabla.id.equals(excluirId).not());
    }
    return (await consulta.getSingleOrNull()) != null;
  }

  Future<int> _contarLecturas(int servicioId) async {
    final consulta = _db.selectOnly(_db.lecturas)
      ..addColumns([_db.lecturas.id.count()])
      ..where(_db.lecturas.servicioId.equals(servicioId));
    final fila = await consulta.getSingle();
    return fila.read(_db.lecturas.id.count()) ?? 0;
  }

  Servicio _aDominio(ServicioRow fila) {
    return Servicio(
      id: fila.id,
      nombre: fila.nombre,
      nombreNormalizado: fila.nombreNormalizado,
      unidad: Unidad.desdeDb(fila.unidad),
      etiquetaContrato: fila.etiquetaContrato,
      activo: fila.activo,
      creadoEn: fila.creadoEn,
      actualizadoEn: fila.actualizadoEn,
    );
  }

  String? _limpiarContrato(String? contrato) {
    final limpio = contrato?.trim();
    return limpio == null || limpio.isEmpty ? null : limpio;
  }
}
