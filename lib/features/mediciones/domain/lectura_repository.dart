import 'package:decimal/decimal.dart';

import 'lectura.dart';

abstract interface class LecturaRepository {
  Stream<List<Lectura>> observarLecturas(int servicioId);

  Future<List<Lectura>> obtenerLecturas(int servicioId);

  Future<int> contarLecturas(int servicioId);

  Future<Lectura?> lecturaVigenteAntesDe(int servicioId, DateTime fecha);

  Future<Lectura?> lecturaVigenteEnDia(int servicioId, DateTime fecha);

  Future<int> registrarLectura({
    required int servicioId,
    required DateTime fecha,
    required Decimal valor,
    String? rutaFoto,
  });
}
