import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/fechas.dart';
import '../../../servicios/presentation/providers.dart';
import '../../domain/calculo_consumo.dart';
import '../providers.dart';
import '../state/consumo_state.dart';

class MesConsumoViewModel extends Notifier<DateTime> {
  MesConsumoViewModel(this.servicioId);

  final int servicioId;

  @override
  DateTime build() => primerDiaMes(DateTime.now());

  void irAnterior() {
    state = DateTime(state.year, state.month - 1);
  }

  void irSiguiente() {
    final siguiente = DateTime(state.year, state.month + 1);
    if (!siguiente.isAfter(primerDiaMes(DateTime.now()))) {
      state = siguiente;
    }
  }
}

final mesConsumoProvider = NotifierProvider.autoDispose
    .family<MesConsumoViewModel, DateTime, int>(MesConsumoViewModel.new);

class ConsumoViewModel extends Notifier<ConsumoState> {
  ConsumoViewModel(this.servicioId);

  final int servicioId;

  @override
  ConsumoState build() {
    final servicioAsync = ref.watch(servicioProvider(servicioId));
    final lecturasAsync = ref.watch(lecturasProvider(servicioId));
    final mes = ref.watch(mesConsumoProvider(servicioId));

    if (servicioAsync.isLoading || lecturasAsync.isLoading) {
      return const ConsumoCargando();
    }
    if (servicioAsync.hasError || lecturasAsync.hasError) {
      return const ConsumoError();
    }

    final servicio = servicioAsync.value;
    final lecturas = lecturasAsync.value;
    if (servicio == null || lecturas == null) {
      return const ConsumoError();
    }

    final puedeAvanzar = !DateTime(
      mes.year,
      mes.month + 1,
    ).isAfter(primerDiaMes(DateTime.now()));
    final vigentes = CalculadoraConsumo.vigentesOrdenadas(lecturas);

    if (vigentes.isEmpty) {
      return ConsumoSinLecturas(mes: mes, puedeAvanzar: puedeAvanzar);
    }
    if (vigentes.length == 1) {
      return ConsumoUnaLectura(
        mes: mes,
        unidad: servicio.unidad,
        puedeAvanzar: puedeAvanzar,
      );
    }

    final lecturasDelMes = vigentes.where(
      (lectura) => mismoMes(lectura.fecha, mes),
    );
    if (lecturasDelMes.isEmpty) {
      return ConsumoMesSinLecturas(
        mes: mes,
        unidad: servicio.unidad,
        puedeAvanzar: puedeAvanzar,
      );
    }

    final resumen = CalculadoraConsumo.resumenDelMes(
      lecturas: lecturas,
      mes: mes,
      unidad: servicio.unidad,
    );
    if (resumen.tramos.isEmpty) {
      return ConsumoMesSinConsumo(mes: mes, puedeAvanzar: puedeAvanzar);
    }

    return ConsumoDatos(resumen: resumen, puedeAvanzar: puedeAvanzar);
  }

  void irMesAnterior() {
    ref.read(mesConsumoProvider(servicioId).notifier).irAnterior();
  }

  void irMesSiguiente() {
    ref.read(mesConsumoProvider(servicioId).notifier).irSiguiente();
  }
}

final consumoViewModelProvider = NotifierProvider.autoDispose
    .family<ConsumoViewModel, ConsumoState, int>(ConsumoViewModel.new);
