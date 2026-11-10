import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:miconsumo/core/utils/texto.dart';
import 'package:miconsumo/features/mediciones/data/photo_storage.dart';
import 'package:miconsumo/features/mediciones/domain/lectura.dart';
import 'package:miconsumo/features/mediciones/domain/lectura_repository.dart';
import 'package:miconsumo/features/servicios/domain/servicio.dart';
import 'package:miconsumo/features/servicios/domain/servicio_repository.dart';
import 'package:miconsumo/features/servicios/domain/unidad.dart';

Servicio servicioDePrueba({
  int id = 1,
  String nombre = 'Luz',
  Unidad unidad = Unidad.kwh,
  bool activo = true,
}) {
  final ahora = DateTime(2026, 11, 1);
  return Servicio(
    id: id,
    nombre: nombre,
    nombreNormalizado: nombre.toLowerCase(),
    unidad: unidad,
    activo: activo,
    creadoEn: ahora,
    actualizadoEn: ahora,
  );
}

Lectura lecturaDePrueba({
  required int id,
  required DateTime fecha,
  required String valor,
  int servicioId = 1,
  EstadoLectura estado = EstadoLectura.vigente,
}) {
  return Lectura(
    id: id,
    servicioId: servicioId,
    fecha: fecha,
    valor: Decimal.parse(valor),
    estado: estado,
    creadaEn: fecha,
  );
}

class FakeServicioRepository implements ServicioRepository {
  FakeServicioRepository(this.servicio);

  Servicio? servicio;
  String? ultimoCreado;

  @override
  Future<void> actualizarServicio({
    required int id,
    required String nombre,
    required Unidad unidad,
    String? etiquetaContrato,
  }) async {
    final actual = servicio;
    if (actual == null) return;
    servicio = Servicio(
      id: actual.id,
      nombre: nombre,
      nombreNormalizado: nombre.toLowerCase(),
      unidad: unidad,
      etiquetaContrato: etiquetaContrato,
      activo: actual.activo,
      creadoEn: actual.creadoEn,
      actualizadoEn: DateTime.now(),
    );
  }

  @override
  Future<void> cambiarActivo(int id, {required bool activo}) async {
    final actual = servicio;
    if (actual == null) return;
    servicio = Servicio(
      id: actual.id,
      nombre: actual.nombre,
      nombreNormalizado: actual.nombreNormalizado,
      unidad: actual.unidad,
      etiquetaContrato: actual.etiquetaContrato,
      activo: activo,
      creadoEn: actual.creadoEn,
      actualizadoEn: DateTime.now(),
    );
  }

  @override
  Future<int> crearServicio({
    required String nombre,
    required Unidad unidad,
    String? etiquetaContrato,
  }) async {
    ultimoCreado = nombre;
    return 1;
  }

  @override
  Future<bool> existeNombre(String nombre, {int? excluirId}) async {
    final actual = servicio;
    if (actual == null || actual.id == excluirId) return false;
    return normalizarNombre(actual.nombre) == normalizarNombre(nombre);
  }

  @override
  Future<Servicio?> obtenerServicio(int id) async => servicio;

  @override
  Stream<Servicio?> observarServicio(int id) => Stream.value(servicio);

  @override
  Stream<List<Servicio>> observarServicios() => Stream.value([?servicio]);
}

class FakeLecturaRepository implements LecturaRepository {
  FakeLecturaRepository([List<Lectura>? lecturas]) : lecturas = lecturas ?? [];

  final List<Lectura> lecturas;

  @override
  Future<int> contarLecturas(int servicioId) async =>
      lecturas.where((lectura) => lectura.servicioId == servicioId).length;

  @override
  Future<Lectura?> lecturaVigenteAntesDe(int servicioId, DateTime fecha) async {
    final anteriores =
        lecturas
            .where(
              (lectura) =>
                  lectura.servicioId == servicioId &&
                  lectura.esVigente &&
                  lectura.fecha.isBefore(fecha),
            )
            .toList()
          ..sort((a, b) => b.fecha.compareTo(a.fecha));
    return anteriores.isEmpty ? null : anteriores.first;
  }

  @override
  Future<Lectura?> lecturaVigenteEnDia(int servicioId, DateTime fecha) async {
    for (final lectura in lecturas) {
      if (lectura.servicioId == servicioId &&
          lectura.esVigente &&
          lectura.fecha.year == fecha.year &&
          lectura.fecha.month == fecha.month &&
          lectura.fecha.day == fecha.day) {
        return lectura;
      }
    }
    return null;
  }

  @override
  Future<List<Lectura>> obtenerLecturas(int servicioId) async =>
      lecturas.where((lectura) => lectura.servicioId == servicioId).toList();

  @override
  Stream<List<Lectura>> observarLecturas(int servicioId) =>
      Stream.value(lecturas.where((l) => l.servicioId == servicioId).toList());

  @override
  Future<int> registrarLectura({
    required int servicioId,
    required DateTime fecha,
    required Decimal valor,
    String? rutaFoto,
  }) async {
    final nuevoId = lecturas.isEmpty
        ? 1
        : lecturas
                  .map((lectura) => lectura.id)
                  .reduce((a, b) => a > b ? a : b) +
              1;
    lecturas.add(
      Lectura(
        id: nuevoId,
        servicioId: servicioId,
        fecha: fecha,
        valor: valor,
        rutaFoto: rutaFoto,
        estado: EstadoLectura.vigente,
        creadaEn: DateTime.now(),
      ),
    );
    return nuevoId;
  }
}

class FakePhotoStorage implements PhotoStorage {
  final List<String> guardadas = [];

  @override
  Future<bool> existe(String rutaRelativa) async => false;

  @override
  Future<String> guardarDesde(String rutaOrigen) async {
    final ruta = 'fotos/foto_${guardadas.length + 1}.jpg';
    guardadas.add(ruta);
    return ruta;
  }

  @override
  Future<File?> resolver(String rutaRelativa) async => null;
}
