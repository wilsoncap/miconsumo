import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/utils/fechas.dart';
import 'package:miconsumo/core/utils/numeros.dart';
import 'package:miconsumo/core/utils/texto.dart';
import 'package:miconsumo/features/mediciones/domain/calculo_consumo.dart';
import 'package:miconsumo/features/mediciones/domain/lectura.dart';
import 'package:miconsumo/features/servicios/domain/unidad.dart';

import '../../../support/envoltorio.dart';

Lectura lectura(
  int id,
  DateTime fecha,
  String valor, {
  EstadoLectura estado = EstadoLectura.vigente,
}) {
  return Lectura(
    id: id,
    servicioId: 1,
    fecha: fecha,
    valor: Decimal.parse(valor),
    estado: estado,
    creadaEn: fecha,
  );
}

void main() {
  inicializarFechasEspanol();

  group('normalización y formato', () {
    test('normaliza nombres sin acentos ni mayúsculas', () {
      expect(normalizarNombre('  LÚZ  '), 'luz');
      expect(normalizarNombre('Gas   Natural'), 'gas natural');
      expect(normalizarNombre('Jamón'), 'jamon');
    });

    test('formatea decimales sin usar double', () {
      expect(formatearDecimal(Decimal.parse('45151')), '45.151');
      expect(
        formatearDecimal(Decimal.parse('10.66'), maxDecimales: 2),
        '10,66',
      );
      expect(formatearDecimal(Decimal.parse('0.83'), maxDecimales: 2), '0,83');
      expect(formatearPorcentaje(Decimal.parse('-6.7')), '−6,7 %');
      expect(formatearPorcentaje(Decimal.parse('7.67')), '+7,7 %');
    });

    test('acepta coma y punto como separador decimal', () {
      expect(parsearDecimal('45,151'), Decimal.parse('45.151'));
      expect(parsearDecimal('45.151'), Decimal.parse('45.151'));
      expect(parsearDecimal('0'), Decimal.zero);
      expect(parsearDecimal('1,2,3'), isNull);
      expect(parsearDecimal(''), isNull);
      expect(parsearDecimal('abc'), isNull);
    });

    test('formatea fechas en español de Colombia', () {
      final fecha = DateTime(2026, 11, 29);
      expect(formatearFechaCorta(fecha), '29 nov');
      expect(formatearFechaLarga(fecha), '29 noviembre 2026');
      expect(formatearMes(fecha), 'noviembre 2026');
    });
  });

  group('CalculadoraConsumo', () {
    test('calcula el resumen de Luz con datos de ejemplo', () {
      final lecturas = [
        lectura(1, DateTime(2026, 9, 30), '44555'),
        lectura(2, DateTime(2026, 10, 31), '44842'),
        lectura(3, DateTime(2026, 11, 1), '44850'),
        lectura(4, DateTime(2026, 11, 5), '44892'),
        lectura(5, DateTime(2026, 11, 9), '44935'),
        lectura(6, DateTime(2026, 11, 13), '44978'),
        lectura(
          99,
          DateTime(2026, 11, 13),
          '44970',
          estado: EstadoLectura.reemplazada,
        ),
        lectura(7, DateTime(2026, 11, 17), '45020'),
        lectura(8, DateTime(2026, 11, 21), '45063'),
        lectura(9, DateTime(2026, 11, 25), '45106'),
        lectura(10, DateTime(2026, 11, 29), '45151'),
      ];

      final resumen = CalculadoraConsumo.resumenDelMes(
        lecturas: lecturas,
        mes: DateTime(2026, 11),
        unidad: Unidad.kwh,
      );

      expect(resumen.tramos.length, 8);
      expect(resumen.total, Decimal.parse('309'));
      expect(resumen.totalAnterior, Decimal.parse('287'));
      expect(resumen.variacionPorcentaje, Decimal.parse('7.67'));
      expect(resumen.promedioDiario, Decimal.parse('10.66'));
      expect(resumen.diasPeriodo, 29);
      expect(resumen.diaMayor?.consumo, Decimal.parse('45'));
      expect(resumen.diaMayor?.fecha, DateTime(2026, 11, 29));
      expect(resumen.hayConsumoNegativo, isFalse);
      expect(resumen.tramos.any((tramo) => tramo.lecturaId == 99), isFalse);
    });

    test('calcula el resumen de Gas con variación negativa', () {
      final lecturas = [
        lectura(1, DateTime(2026, 9, 30), '3380'),
        lectura(2, DateTime(2026, 10, 31), '3410'),
        lectura(3, DateTime(2026, 11, 2), '3415'),
        lectura(4, DateTime(2026, 11, 9), '3421'),
        lectura(5, DateTime(2026, 11, 16), '3427'),
        lectura(6, DateTime(2026, 11, 23), '3433'),
        lectura(7, DateTime(2026, 11, 29), '3438'),
      ];

      final resumen = CalculadoraConsumo.resumenDelMes(
        lecturas: lecturas,
        mes: DateTime(2026, 11),
        unidad: Unidad.m3,
      );

      expect(resumen.total, Decimal.parse('28'));
      expect(resumen.totalAnterior, Decimal.parse('30'));
      expect(resumen.variacionPorcentaje, Decimal.parse('-6.67'));
      expect(formatearPorcentaje(resumen.variacionPorcentaje!), '−6,7 %');
      expect(resumen.promedioDiario, Decimal.parse('0.97'));
      expect(resumen.diaMayor?.fecha, DateTime(2026, 11, 9));
    });

    test('omite la variación cuando el mes anterior es cero', () {
      final lecturas = [
        lectura(1, DateTime(2026, 9, 30), '100'),
        lectura(2, DateTime(2026, 10, 31), '100'),
        lectura(3, DateTime(2026, 11, 5), '105'),
      ];

      final resumen = CalculadoraConsumo.resumenDelMes(
        lecturas: lecturas,
        mes: DateTime(2026, 11),
        unidad: Unidad.kwh,
      );

      expect(resumen.totalAnterior, Decimal.zero);
      expect(resumen.variacionPorcentaje, isNull);
    });

    test('marca el consumo negativo', () {
      final lecturas = [
        lectura(1, DateTime(2026, 11, 1), '100'),
        lectura(2, DateTime(2026, 11, 5), '90'),
      ];

      final resumen = CalculadoraConsumo.resumenDelMes(
        lecturas: lecturas,
        mes: DateTime(2026, 11),
        unidad: Unidad.kwh,
      );

      expect(resumen.total, Decimal.parse('-10'));
      expect(resumen.hayConsumoNegativo, isTrue);
    });

    test('la primera lectura no produce consumo', () {
      final lecturas = [lectura(1, DateTime(2026, 11, 1), '100')];
      expect(CalculadoraConsumo.tramosDe(lecturas), isEmpty);
    });

    test('calcula los días que abarca un tramo', () {
      final lecturas = [
        lectura(1, DateTime(2026, 11, 1), '100'),
        lectura(2, DateTime(2026, 11, 4), '112'),
      ];
      final tramo = CalculadoraConsumo.tramosDe(lecturas).single;
      expect(tramo.consumo, Decimal.parse('12'));
      expect(tramo.dias, 3);
    });
  });
}
