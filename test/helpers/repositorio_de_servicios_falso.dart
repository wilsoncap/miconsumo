import 'dart:async';

import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/repositories/servicio_repository.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/nombre_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';

/// Repositorio de mentira para probar los ViewModel sin base de datos.
///
/// Permite dos cosas que con Drift serían difíciles de provocar: forzar un fallo
/// concreto y controlar el orden de los datos devueltos. Además emite cambios
/// por su flujo, igual que el repositorio real.
class RepositorioDeServiciosFalso implements ServicioRepository {
  /// Construye el repositorio falso.
  ///
  /// Si se indica [motivoDeFallo], todas las operaciones fallan con ese motivo.
  RepositorioDeServiciosFalso({this.motivoDeFallo});

  /// Motivo con el que fallan todas las operaciones, o nulo para funcionar.
  final MotivoDeFallo? motivoDeFallo;

  /// Servicios que devuelve el listado.
  final List<TipoDeServicio> servicios = <TipoDeServicio>[];

  final StreamController<List<TipoDeServicio>> _cambios =
      StreamController<List<TipoDeServicio>>.broadcast();

  int _siguienteId = 1;

  /// Hora que se usa para la creación y la modificación.
  DateTime ahora = DateTime(2026, 10, 18, 12);

  /// Cierra el flujo de cambios.
  Future<void> dispose() => _cambios.close();

  @override
  Stream<Resultado<List<TipoDeServicio>>> observarServicios() async* {
    final MotivoDeFallo? motivo = motivoDeFallo;
    if (motivo != null) {
      yield Fallo<List<TipoDeServicio>>(motivo);
      return;
    }

    yield Exito<List<TipoDeServicio>>(
      List<TipoDeServicio>.unmodifiable(servicios),
    );
    yield* _cambios.stream.map(
      (List<TipoDeServicio> lista) =>
          Exito<List<TipoDeServicio>>(List<TipoDeServicio>.unmodifiable(lista)),
    );
  }

  @override
  Future<Resultado<TipoDeServicio>> obtenerServicio(int id) async {
    final MotivoDeFallo? motivo = motivoDeFallo;
    if (motivo != null) {
      return Fallo<TipoDeServicio>(motivo);
    }
    final int indice = servicios.indexWhere((TipoDeServicio s) => s.id == id);
    if (indice < 0) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
    }
    return Exito<TipoDeServicio>(servicios[indice]);
  }

  @override
  Future<Resultado<TipoDeServicio>> crearServicio({
    required String nombre,
    required UnidadMedida unidad,
    String? etiquetaContrato,
  }) async {
    final MotivoDeFallo? motivo = motivoDeFallo;
    if (motivo != null) {
      return Fallo<TipoDeServicio>(motivo);
    }

    final String recortado = nombre.trim();
    if (recortado.isEmpty) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.nombreVacio);
    }
    final NombreDeServicio validado = NombreDeServicio(recortado);
    final bool duplicado = servicios.any(
      (TipoDeServicio s) => s.nombre.normalizado == validado.normalizado,
    );
    if (duplicado) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.nombreDuplicado);
    }

    final TipoDeServicio creado = TipoDeServicio(
      id: _siguienteId++,
      nombre: validado,
      unidad: unidad,
      etiquetaContrato: _normalizar(etiquetaContrato),
      activo: true,
      creadoEn: ahora,
      actualizadoEn: ahora,
    );
    servicios.add(creado);
    _notificar();
    return Exito<TipoDeServicio>(creado);
  }

  @override
  Future<Resultado<TipoDeServicio>> actualizarServicio({
    required int id,
    required String nombre,
    String? etiquetaContrato,
  }) async {
    final MotivoDeFallo? motivo = motivoDeFallo;
    if (motivo != null) {
      return Fallo<TipoDeServicio>(motivo);
    }

    final int indice = servicios.indexWhere((TipoDeServicio s) => s.id == id);
    if (indice < 0) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
    }

    final NombreDeServicio validado = NombreDeServicio(nombre.trim());
    final bool duplicado = servicios.any(
      (TipoDeServicio s) =>
          s.id != id && s.nombre.normalizado == validado.normalizado,
    );
    if (duplicado) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.nombreDuplicado);
    }

    final TipoDeServicio actualizado = servicios[indice].copyWith(
      nombre: validado,
      etiquetaContrato: _normalizar(etiquetaContrato),
      actualizadoEn: ahora,
    );
    servicios[indice] = actualizado;
    _notificar();
    return Exito<TipoDeServicio>(actualizado);
  }

  @override
  Future<Resultado<TipoDeServicio>> cambiarUnidad({
    required int id,
    required UnidadMedida unidad,
  }) async {
    final MotivoDeFallo? motivo = motivoDeFallo;
    if (motivo != null) {
      return Fallo<TipoDeServicio>(motivo);
    }

    final int indice = servicios.indexWhere((TipoDeServicio s) => s.id == id);
    if (indice < 0) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
    }

    final TipoDeServicio actualizado = servicios[indice].copyWith(
      unidad: unidad,
      actualizadoEn: ahora,
    );
    servicios[indice] = actualizado;
    _notificar();
    return Exito<TipoDeServicio>(actualizado);
  }

  @override
  Future<Resultado<TipoDeServicio>> desactivarServicio(int id) =>
      _cambiarEstado(id, activo: false);

  @override
  Future<Resultado<TipoDeServicio>> reactivarServicio(int id) =>
      _cambiarEstado(id, activo: true);

  Future<Resultado<TipoDeServicio>> _cambiarEstado(
    int id, {
    required bool activo,
  }) async {
    final MotivoDeFallo? motivo = motivoDeFallo;
    if (motivo != null) {
      return Fallo<TipoDeServicio>(motivo);
    }

    final int indice = servicios.indexWhere((TipoDeServicio s) => s.id == id);
    if (indice < 0) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
    }

    final TipoDeServicio actualizado = servicios[indice].copyWith(
      activo: activo,
      actualizadoEn: ahora,
    );
    servicios[indice] = actualizado;
    _notificar();
    return Exito<TipoDeServicio>(actualizado);
  }

  /// Avisa a los suscriptores de que los datos cambiaron.
  void _notificar() {
    if (!_cambios.isClosed) {
      _cambios.add(List<TipoDeServicio>.of(servicios));
    }
  }

  String? _normalizar(String? etiqueta) {
    final String recortada = etiqueta?.trim() ?? '';
    return recortada.isEmpty ? null : recortada;
  }
}
