import '../../../servicios/domain/unidad.dart';
import '../../domain/calculo_consumo.dart';

sealed class ConsumoState {
  const ConsumoState();
}

final class ConsumoCargando extends ConsumoState {
  const ConsumoCargando();
}

final class ConsumoError extends ConsumoState {
  const ConsumoError();
}

final class ConsumoSinLecturas extends ConsumoState {
  const ConsumoSinLecturas({required this.mes, required this.puedeAvanzar});

  final DateTime mes;
  final bool puedeAvanzar;
}

final class ConsumoUnaLectura extends ConsumoState {
  const ConsumoUnaLectura({
    required this.mes,
    required this.unidad,
    required this.puedeAvanzar,
  });

  final DateTime mes;
  final Unidad unidad;
  final bool puedeAvanzar;
}

final class ConsumoMesSinLecturas extends ConsumoState {
  const ConsumoMesSinLecturas({
    required this.mes,
    required this.unidad,
    required this.puedeAvanzar,
  });

  final DateTime mes;
  final Unidad unidad;
  final bool puedeAvanzar;
}

final class ConsumoMesSinConsumo extends ConsumoState {
  const ConsumoMesSinConsumo({required this.mes, required this.puedeAvanzar});

  final DateTime mes;
  final bool puedeAvanzar;
}

final class ConsumoDatos extends ConsumoState {
  const ConsumoDatos({required this.resumen, required this.puedeAvanzar});

  final ResumenConsumo resumen;
  final bool puedeAvanzar;
}
