import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/utils/fechas.dart';
import '../../../../core/utils/numeros.dart';
import '../state/registrar_lectura_state.dart';

class RegistrarLecturaViewModel extends Notifier<RegistrarLecturaState> {
  RegistrarLecturaViewModel(this.servicioId);

  final int servicioId;

  @override
  RegistrarLecturaState build() {
    return RegistrarLecturaState(fecha: soloFecha(DateTime.now()));
  }

  void actualizarFecha(DateTime fecha) {
    state = state.copyWith(fecha: soloFecha(fecha));
  }

  void actualizarValor(String texto) {
    state = state.copyWith(valorTexto: texto, valorInvalido: false);
  }

  void seleccionarFoto(String rutaTemporal) {
    state = state.copyWith(rutaFotoTemporal: rutaTemporal);
  }

  void quitarFoto() {
    state = state.copyWith(quitarFoto: true);
  }

  Future<ResultadoRegistro> registrar({bool confirmarMenor = false}) async {
    final actual = state;
    if (actual.guardando) {
      return const RegistroFallido(MotivoFalloRegistro.errorGuardado);
    }

    final hoy = soloFecha(DateTime.now());
    final dia = soloFecha(actual.fecha);
    if (dia.isAfter(hoy)) {
      return const RegistroFallido(MotivoFalloRegistro.fechaFutura);
    }

    final valor = parsearDecimal(actual.valorTexto);
    if (valor == null || valor < Decimal.zero) {
      state = actual.copyWith(valorInvalido: true);
      return const RegistroFallido(MotivoFalloRegistro.valorInvalido);
    }

    try {
      final servicio = await ref
          .read(servicioRepositoryProvider)
          .obtenerServicio(servicioId);
      if (servicio == null) {
        return const RegistroFallido(MotivoFalloRegistro.errorGuardado);
      }
      if (!servicio.activo) {
        return const RegistroFallido(MotivoFalloRegistro.servicioInactivo);
      }

      final lecturaAnterior = await ref
          .read(lecturaRepositoryProvider)
          .lecturaVigenteAntesDe(servicioId, dia);
      if (lecturaAnterior != null &&
          valor < lecturaAnterior.valor &&
          !confirmarMenor) {
        return RegistroRequiereConfirmacion(
          valor: valor,
          lecturaAnterior: lecturaAnterior.valor,
        );
      }

      state = actual.copyWith(
        guardando: true,
        valorInvalido: false,
        errorGeneral: false,
      );

      String? rutaFoto;
      if (actual.tieneFoto) {
        rutaFoto = await ref
            .read(photoStorageProvider)
            .guardarDesde(actual.rutaFotoTemporal!);
      }

      await ref
          .read(lecturaRepositoryProvider)
          .registrarLectura(
            servicioId: servicioId,
            fecha: dia,
            valor: valor,
            rutaFoto: rutaFoto,
          );

      state = state.copyWith(guardando: false);
      return const RegistroGuardado();
    } catch (_) {
      state = state.copyWith(guardando: false, errorGeneral: true);
      return const RegistroFallido(MotivoFalloRegistro.errorGuardado);
    }
  }
}

final registrarLecturaViewModelProvider = NotifierProvider.autoDispose
    .family<RegistrarLecturaViewModel, RegistrarLecturaState, int>(
      RegistrarLecturaViewModel.new,
    );
