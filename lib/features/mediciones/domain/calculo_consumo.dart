import 'package:decimal/decimal.dart';

import '../../servicios/domain/unidad.dart';
import 'lectura.dart';

class TramoConsumo {
  const TramoConsumo({
    required this.lecturaId,
    required this.fecha,
    required this.consumo,
    required this.dias,
  });

  final int lecturaId;
  final DateTime fecha;
  final Decimal consumo;
  final int dias;
}

class ResumenConsumo {
  const ResumenConsumo({
    required this.mes,
    required this.tramos,
    required this.total,
    required this.totalAnterior,
    required this.variacionPorcentaje,
    required this.promedioDiario,
    required this.diaMayor,
    required this.diasPeriodo,
    required this.hayConsumoNegativo,
    required this.unidad,
  });

  final DateTime mes;
  final List<TramoConsumo> tramos;
  final Decimal total;
  final Decimal? totalAnterior;
  final Decimal? variacionPorcentaje;
  final Decimal? promedioDiario;
  final TramoConsumo? diaMayor;
  final int diasPeriodo;
  final bool hayConsumoNegativo;
  final Unidad unidad;
}

class CalculadoraConsumo {
  const CalculadoraConsumo._();

  static List<Lectura> vigentesOrdenadas(Iterable<Lectura> lecturas) {
    return lecturas.where((lectura) => lectura.esVigente).toList()
      ..sort((a, b) {
        final porFecha = a.fecha.compareTo(b.fecha);
        return porFecha != 0 ? porFecha : a.id.compareTo(b.id);
      });
  }

  static List<TramoConsumo> tramosDe(Iterable<Lectura> lecturas) {
    final vigentes = vigentesOrdenadas(lecturas);
    final tramos = <TramoConsumo>[];
    for (var i = 1; i < vigentes.length; i++) {
      final anterior = vigentes[i - 1];
      final actual = vigentes[i];
      final dias = actual.fecha.difference(anterior.fecha).inDays;
      tramos.add(
        TramoConsumo(
          lecturaId: actual.id,
          fecha: actual.fecha,
          consumo: actual.valor - anterior.valor,
          dias: dias <= 0 ? 1 : dias,
        ),
      );
    }
    return tramos;
  }

  static Map<int, TramoConsumo> tramosPorLectura(Iterable<Lectura> lecturas) {
    return {for (final tramo in tramosDe(lecturas)) tramo.lecturaId: tramo};
  }

  static ResumenConsumo resumenDelMes({
    required List<Lectura> lecturas,
    required DateTime mes,
    required Unidad unidad,
  }) {
    final inicio = DateTime(mes.year, mes.month);
    final fin = DateTime(mes.year, mes.month + 1);
    final inicioAnterior = DateTime(mes.year, mes.month - 1);
    final tramos = tramosDe(lecturas);
    final tramosMes = tramos
        .where(
          (tramo) => !tramo.fecha.isBefore(inicio) && tramo.fecha.isBefore(fin),
        )
        .toList();
    final tramosAnterior = tramos
        .where(
          (tramo) =>
              !tramo.fecha.isBefore(inicioAnterior) &&
              tramo.fecha.isBefore(inicio),
        )
        .toList();

    final total = tramosMes.fold(Decimal.zero, (suma, t) => suma + t.consumo);
    final totalAnterior = tramosAnterior.isEmpty
        ? null
        : tramosAnterior.fold(Decimal.zero, (suma, t) => suma + t.consumo);

    Decimal? variacion;
    if (totalAnterior != null && totalAnterior != Decimal.zero) {
      final proporcion = ((total - totalAnterior) / totalAnterior).toDecimal(
        scaleOnInfinitePrecision: 6,
      );
      variacion = (proporcion * Decimal.fromInt(100)).round(scale: 2);
    }

    final vigentes = vigentesOrdenadas(lecturas);
    final lecturasMes = vigentes
        .where(
          (lectura) =>
              !lectura.fecha.isBefore(inicio) && lectura.fecha.isBefore(fin),
        )
        .toList();
    final diasPeriodo = lecturasMes.isEmpty ? 0 : lecturasMes.last.fecha.day;
    final promedio = diasPeriodo > 0
        ? (total / Decimal.fromInt(diasPeriodo))
              .toDecimal(scaleOnInfinitePrecision: 6)
              .round(scale: 2)
        : null;

    TramoConsumo? diaMayor;
    for (final tramo in tramosMes) {
      if (diaMayor == null || tramo.consumo > diaMayor.consumo) {
        diaMayor = tramo;
      }
    }

    return ResumenConsumo(
      mes: inicio,
      tramos: tramosMes,
      total: total,
      totalAnterior: totalAnterior,
      variacionPorcentaje: variacion,
      promedioDiario: promedio,
      diaMayor: diaMayor,
      diasPeriodo: diasPeriodo,
      hayConsumoNegativo: tramosMes.any(
        (tramo) => tramo.consumo < Decimal.zero,
      ),
      unidad: unidad,
    );
  }
}
