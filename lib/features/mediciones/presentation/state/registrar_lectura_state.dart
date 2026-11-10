import 'package:decimal/decimal.dart';

class RegistrarLecturaState {
  const RegistrarLecturaState({
    required this.fecha,
    this.valorTexto = '',
    this.rutaFotoTemporal,
    this.valorInvalido = false,
    this.errorGeneral = false,
    this.guardando = false,
  });

  final DateTime fecha;
  final String valorTexto;
  final String? rutaFotoTemporal;
  final bool valorInvalido;
  final bool errorGeneral;
  final bool guardando;

  bool get tieneFoto =>
      rutaFotoTemporal != null && rutaFotoTemporal!.isNotEmpty;

  RegistrarLecturaState copyWith({
    DateTime? fecha,
    String? valorTexto,
    String? rutaFotoTemporal,
    bool quitarFoto = false,
    bool? valorInvalido,
    bool? errorGeneral,
    bool? guardando,
  }) {
    return RegistrarLecturaState(
      fecha: fecha ?? this.fecha,
      valorTexto: valorTexto ?? this.valorTexto,
      rutaFotoTemporal: quitarFoto
          ? null
          : rutaFotoTemporal ?? this.rutaFotoTemporal,
      valorInvalido: valorInvalido ?? this.valorInvalido,
      errorGeneral: errorGeneral ?? this.errorGeneral,
      guardando: guardando ?? this.guardando,
    );
  }
}

enum MotivoFalloRegistro {
  servicioInactivo,
  fechaFutura,
  valorInvalido,
  errorGuardado,
}

sealed class ResultadoRegistro {
  const ResultadoRegistro();
}

final class RegistroGuardado extends ResultadoRegistro {
  const RegistroGuardado();
}

final class RegistroRequiereConfirmacion extends ResultadoRegistro {
  const RegistroRequiereConfirmacion({
    required this.valor,
    required this.lecturaAnterior,
  });

  final Decimal valor;
  final Decimal lecturaAnterior;
}

final class RegistroFallido extends ResultadoRegistro {
  const RegistroFallido(this.motivo);

  final MotivoFalloRegistro motivo;
}
