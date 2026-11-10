import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/error/errores.dart';
import '../../domain/unidad.dart';
import '../state/servicio_form_data.dart';

class ServicioFormViewModel extends AsyncNotifier<ServicioFormData> {
  ServicioFormViewModel(this.servicioId);

  /// `0` significa un servicio nuevo.
  final int servicioId;

  @override
  Future<ServicioFormData> build() async {
    if (servicioId == 0) {
      return const ServicioFormData(
        nombre: '',
        unidad: Unidad.kwh,
        contrato: '',
      );
    }

    final servicio = await ref
        .read(servicioRepositoryProvider)
        .obtenerServicio(servicioId);
    if (servicio == null) {
      throw const ServicioNoEncontradoException();
    }
    final lecturas = await ref
        .read(lecturaRepositoryProvider)
        .contarLecturas(servicioId);

    return ServicioFormData(
      original: servicio,
      nombre: servicio.nombre,
      unidad: servicio.unidad,
      contrato: servicio.etiquetaContrato ?? '',
      unidadBloqueada: lecturas > 0,
    );
  }

  void actualizarNombre(String nombre) {
    final actual = state.value;
    if (actual == null) return;
    state = AsyncData(
      actual.copyWith(nombre: nombre, limpiarErrorNombre: true),
    );
  }

  void actualizarUnidad(Unidad unidad) {
    final actual = state.value;
    if (actual == null || actual.unidadBloqueada) return;
    state = AsyncData(actual.copyWith(unidad: unidad));
  }

  void actualizarContrato(String contrato) {
    final actual = state.value;
    if (actual == null) return;
    state = AsyncData(actual.copyWith(contrato: contrato));
  }

  Future<bool> guardar() async {
    final actual = state.value;
    if (actual == null || actual.guardando) return false;

    final nombre = actual.nombre.trim();
    if (nombre.isEmpty) {
      state = AsyncData(
        actual.copyWith(errorNombre: ErrorNombreServicio.vacio),
      );
      return false;
    }

    final repositorio = ref.read(servicioRepositoryProvider);
    state = AsyncData(
      actual.copyWith(
        guardando: true,
        limpiarErrorNombre: true,
        limpiarErrorGeneral: true,
      ),
    );

    try {
      final duplicado = await repositorio.existeNombre(
        nombre,
        excluirId: actual.original?.id,
      );
      if (duplicado) {
        state = AsyncData(
          actual.copyWith(
            guardando: false,
            errorNombre: ErrorNombreServicio.duplicado,
          ),
        );
        return false;
      }

      if (actual.original == null) {
        await repositorio.crearServicio(
          nombre: nombre,
          unidad: actual.unidad,
          etiquetaContrato: actual.contrato,
        );
      } else {
        await repositorio.actualizarServicio(
          id: actual.original!.id,
          nombre: nombre,
          unidad: actual.unidad,
          etiquetaContrato: actual.contrato,
        );
      }
      state = AsyncData(actual.copyWith(guardando: false));
      return true;
    } on NombreDuplicadoException {
      state = AsyncData(
        actual.copyWith(
          guardando: false,
          errorNombre: ErrorNombreServicio.duplicado,
        ),
      );
      return false;
    } on UnidadBloqueadaException {
      state = AsyncData(
        actual.copyWith(
          guardando: false,
          errorGeneral: ErrorGeneralServicio.unidadBloqueada,
        ),
      );
      return false;
    } catch (_) {
      state = AsyncData(
        actual.copyWith(
          guardando: false,
          errorGeneral: ErrorGeneralServicio.desconocido,
        ),
      );
      return false;
    }
  }
}

final servicioFormViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<ServicioFormViewModel, ServicioFormData, int>(
      ServicioFormViewModel.new,
    );
