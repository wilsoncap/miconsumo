import 'package:decimal/decimal.dart';

/// Formatea un decimal con separador de miles y coma decimal.
///
/// No convierte el valor a `double`: trabaja sobre la representación textual.
String formatearDecimal(Decimal valor, {int maxDecimales = 3}) {
  var texto = valor.toStringAsFixed(maxDecimales);
  if (texto.contains('.')) {
    texto = texto.replaceFirst(RegExp(r'0+$'), '');
    if (texto.endsWith('.')) {
      texto = texto.substring(0, texto.length - 1);
    }
  }

  final partes = texto.split('.');
  final entero = partes.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  if (partes.length == 1) return entero;
  return '$entero,${partes[1]}';
}

String formatearPorcentaje(Decimal valor) {
  final signo = valor > Decimal.zero
      ? '+'
      : valor < Decimal.zero
      ? '−'
      : '';
  final absoluto = valor.abs();
  return '$signo${formatearDecimal(absoluto, maxDecimales: 1)} %';
}

String formatearMoneda(Decimal valor) {
  final entero = valor.round().toBigInt().toString();
  final conMiles = entero.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return r'$ ' + conMiles;
}

/// Acepta coma o punto como separador decimal.
Decimal? parsearDecimal(String texto) {
  final limpio = texto.trim().replaceAll(' ', '');
  if (!RegExp(r'^\d+(?:[.,]\d+)?$').hasMatch(limpio)) return null;
  return Decimal.tryParse(limpio.replaceAll(',', '.'));
}
