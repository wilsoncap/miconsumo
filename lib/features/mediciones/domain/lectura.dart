import 'package:decimal/decimal.dart';

enum EstadoLectura {
  vigente('vigente'),
  reemplazada('reemplazada');

  const EstadoLectura(this.valorDb);

  final String valorDb;

  static EstadoLectura desdeDb(String valor) {
    return EstadoLectura.values.firstWhere(
      (estado) => estado.valorDb == valor,
      orElse: () =>
          throw ArgumentError('Estado de lectura desconocido: $valor'),
    );
  }
}

class Lectura {
  const Lectura({
    required this.id,
    required this.servicioId,
    required this.fecha,
    required this.valor,
    required this.estado,
    required this.creadaEn,
    this.rutaFoto,
    this.reemplazaA,
  });

  final int id;
  final int servicioId;
  final DateTime fecha;
  final Decimal valor;
  final String? rutaFoto;
  final EstadoLectura estado;
  final int? reemplazaA;
  final DateTime creadaEn;

  bool get esVigente => estado == EstadoLectura.vigente;
  bool get tieneFoto => rutaFoto != null && rutaFoto!.isNotEmpty;
}
