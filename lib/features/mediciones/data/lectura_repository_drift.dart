import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import '../../../app/data/app_database.dart';
import '../../../core/utils/fechas.dart';
import '../domain/lectura.dart';
import '../domain/lectura_repository.dart';

class LecturaRepositoryDrift implements LecturaRepository {
  LecturaRepositoryDrift(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Lectura>> observarLecturas(int servicioId) {
    final consulta = _db.select(_db.lecturas)
      ..where((tabla) => tabla.servicioId.equals(servicioId))
      ..orderBy([
        (tabla) =>
            OrderingTerm(expression: tabla.fecha, mode: OrderingMode.desc),
        (tabla) => OrderingTerm(expression: tabla.id, mode: OrderingMode.desc),
      ]);
    return consulta.watch().map(
      (filas) => filas.map(_aDominio).toList(growable: false),
    );
  }

  @override
  Future<List<Lectura>> obtenerLecturas(int servicioId) async {
    final consulta = _db.select(_db.lecturas)
      ..where((tabla) => tabla.servicioId.equals(servicioId))
      ..orderBy([
        (tabla) =>
            OrderingTerm(expression: tabla.fecha, mode: OrderingMode.desc),
        (tabla) => OrderingTerm(expression: tabla.id, mode: OrderingMode.desc),
      ]);
    final filas = await consulta.get();
    return filas.map(_aDominio).toList(growable: false);
  }

  @override
  Future<int> contarLecturas(int servicioId) async {
    final consulta = _db.selectOnly(_db.lecturas)
      ..addColumns([_db.lecturas.id.count()])
      ..where(_db.lecturas.servicioId.equals(servicioId));
    final fila = await consulta.getSingle();
    return fila.read(_db.lecturas.id.count()) ?? 0;
  }

  @override
  Future<Lectura?> lecturaVigenteAntesDe(int servicioId, DateTime fecha) async {
    final dia = soloFecha(fecha);
    final lecturas = await obtenerLecturas(servicioId);
    final anteriores = lecturas
        .where((lectura) => lectura.esVigente && lectura.fecha.isBefore(dia))
        .toList();
    return anteriores.isEmpty ? null : anteriores.first;
  }

  @override
  Future<Lectura?> lecturaVigenteEnDia(int servicioId, DateTime fecha) async {
    final dia = soloFecha(fecha);
    final lecturas = await obtenerLecturas(servicioId);
    for (final lectura in lecturas) {
      if (lectura.esVigente && _mismoDia(lectura.fecha, dia)) {
        return lectura;
      }
    }
    return null;
  }

  @override
  Future<int> registrarLectura({
    required int servicioId,
    required DateTime fecha,
    required Decimal valor,
    String? rutaFoto,
  }) {
    return _db.transaction(() async {
      final dia = soloFecha(fecha);
      final filas = await (_db.select(
        _db.lecturas,
      )..where((tabla) => tabla.servicioId.equals(servicioId))).get();
      final vigentesDelDia =
          filas
              .where(
                (fila) =>
                    fila.estado == EstadoLectura.vigente.valorDb &&
                    _mismoDia(fila.fecha, dia),
              )
              .toList()
            ..sort((a, b) => a.id.compareTo(b.id));

      for (final fila in vigentesDelDia) {
        await (_db.update(
          _db.lecturas,
        )..where((tabla) => tabla.id.equals(fila.id))).write(
          LecturasCompanion(estado: Value(EstadoLectura.reemplazada.valorDb)),
        );
      }

      return _db
          .into(_db.lecturas)
          .insert(
            LecturasCompanion.insert(
              servicioId: servicioId,
              fecha: dia,
              valor: valor.toString(),
              rutaFoto: Value(rutaFoto),
              estado: Value(EstadoLectura.vigente.valorDb),
              reemplazaA: Value(
                vigentesDelDia.isEmpty ? null : vigentesDelDia.last.id,
              ),
              creadaEn: DateTime.now(),
            ),
          );
    });
  }

  Lectura _aDominio(LecturaRow fila) {
    return Lectura(
      id: fila.id,
      servicioId: fila.servicioId,
      fecha: soloFecha(fila.fecha),
      valor: Decimal.parse(fila.valor),
      rutaFoto: fila.rutaFoto,
      estado: EstadoLectura.desdeDb(fila.estado),
      reemplazaA: fila.reemplazaA,
      creadaEn: fila.creadaEn,
    );
  }

  bool _mismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
