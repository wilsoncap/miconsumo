import 'package:drift/drift.dart';
import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/repositories/servicio_repository.dart';
import 'package:miconsumo/features/servicios/domain/usecases/puede_cambiar_unidad.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/nombre_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';

import '../local/app_database.dart';
import '../local/servicios_dao.dart';
import '../mappers/servicio_mapper.dart';

/// Implementación de [ServicioRepository] sobre Drift.
///
/// Traduce cada validación fallida al [MotivoDeFallo] correspondiente, de modo
/// que la presentación reciba valores y no excepciones.
class ServicioRepositoryImpl implements ServicioRepository {
  /// Construye el repositorio.
  ///
  /// [reloj] permite fijar la hora en las pruebas; por defecto usa la del
  /// sistema.
  ServicioRepositoryImpl(this._dao, {DateTime Function()? reloj})
    : _reloj = reloj ?? DateTime.now;

  final ServiciosDao _dao;
  final DateTime Function() _reloj;

  @override
  Stream<Resultado<List<TipoDeServicio>>> observarServicios() async* {
    try {
      await for (final List<Servicio> filas in _dao.observar()) {
        yield Exito<List<TipoDeServicio>>(
          filas.map((Servicio fila) => fila.aDominio()).toList(growable: false),
        );
      }
    } catch (_) {
      // El flujo no se rompe: emite el fallo para que la interfaz pueda
      // ofrecer reintentar.
      yield const Fallo<List<TipoDeServicio>>(MotivoDeFallo.almacenamiento);
    }
  }

  @override
  Future<Resultado<TipoDeServicio>> obtenerServicio(int id) async {
    try {
      final Servicio? fila = await _dao.buscarPorId(id);
      if (fila == null) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
      }
      return Exito<TipoDeServicio>(fila.aDominio());
    } catch (_) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.almacenamiento);
    }
  }

  @override
  Future<Resultado<TipoDeServicio>> crearServicio({
    required String nombre,
    required UnidadMedida unidad,
    String? etiquetaContrato,
  }) async {
    final NombreDeServicio? validado = _validarNombre(nombre);
    if (validado == null) {
      return Fallo<TipoDeServicio>(_motivoDeNombre(nombre));
    }

    try {
      final Servicio? existente = await _dao.buscarPorNombreNormalizado(
        validado.normalizado,
      );
      if (existente != null) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.nombreDuplicado);
      }

      final DateTime ahora = _reloj();
      final Servicio fila = await _dao.insertar(
        ServiciosCompanion.insert(
          nombre: validado.valor,
          nombreNormalizado: validado.normalizado,
          unidad: codigoDeUnidad(unidad),
          etiquetaContrato: Value(_normalizarEtiqueta(etiquetaContrato)),
          creadoEn: ahora,
          actualizadoEn: ahora,
        ),
      );
      return Exito<TipoDeServicio>(fila.aDominio());
    } catch (_) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.almacenamiento);
    }
  }

  @override
  Future<Resultado<TipoDeServicio>> actualizarServicio({
    required int id,
    required String nombre,
    String? etiquetaContrato,
  }) async {
    final NombreDeServicio? validado = _validarNombre(nombre);
    if (validado == null) {
      return Fallo<TipoDeServicio>(_motivoDeNombre(nombre));
    }

    try {
      final Servicio? fila = await _dao.buscarPorId(id);
      if (fila == null) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
      }

      final Servicio? conMismoNombre = await _dao.buscarPorNombreNormalizado(
        validado.normalizado,
      );
      if (conMismoNombre != null && conMismoNombre.id != id) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.nombreDuplicado);
      }

      final Servicio actualizado = await _dao.actualizar(
        ServiciosCompanion(
          id: Value<int>(id),
          nombre: Value<String>(validado.valor),
          nombreNormalizado: Value<String>(validado.normalizado),
          etiquetaContrato: Value<String?>(
            _normalizarEtiqueta(etiquetaContrato),
          ),
          actualizadoEn: Value<DateTime>(_reloj()),
        ),
      );
      return Exito<TipoDeServicio>(actualizado.aDominio());
    } catch (_) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.almacenamiento);
    }
  }

  @override
  Future<Resultado<TipoDeServicio>> cambiarUnidad({
    required int id,
    required UnidadMedida unidad,
  }) async {
    try {
      final Servicio? fila = await _dao.buscarPorId(id);
      if (fila == null) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
      }

      // Todavía no existen mediciones: llegan en una funcionalidad posterior.
      // La regla de FR-006 queda implementada y probada para cuando lleguen.
      const bool tieneMediciones = false;
      if (!puedeCambiarUnidad(tieneMediciones: tieneMediciones)) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.unidadInmutable);
      }

      final Servicio actualizado = await _dao.actualizar(
        ServiciosCompanion(
          id: Value<int>(id),
          unidad: Value<String>(codigoDeUnidad(unidad)),
          actualizadoEn: Value<DateTime>(_reloj()),
        ),
      );
      return Exito<TipoDeServicio>(actualizado.aDominio());
    } catch (_) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.almacenamiento);
    }
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
    try {
      final Servicio? fila = await _dao.buscarPorId(id);
      if (fila == null) {
        return const Fallo<TipoDeServicio>(MotivoDeFallo.servicioNoEncontrado);
      }

      final Servicio actualizado = await _dao.actualizar(
        ServiciosCompanion(
          id: Value<int>(id),
          activo: Value<bool>(activo),
          actualizadoEn: Value<DateTime>(_reloj()),
        ),
      );
      return Exito<TipoDeServicio>(actualizado.aDominio());
    } catch (_) {
      return const Fallo<TipoDeServicio>(MotivoDeFallo.almacenamiento);
    }
  }

  /// Devuelve el nombre validado, o nulo si no es válido.
  NombreDeServicio? _validarNombre(String nombre) {
    final String recortado = nombre.trim();
    if (recortado.isEmpty ||
        recortado.length > NombreDeServicio.longitudMaxima) {
      return null;
    }
    return NombreDeServicio(recortado);
  }

  /// Motivo por el que un nombre no es válido.
  MotivoDeFallo _motivoDeNombre(String nombre) => nombre.trim().isEmpty
      ? MotivoDeFallo.nombreVacio
      : MotivoDeFallo.nombreDemasiadoLargo;

  /// Recorta la etiqueta de contrato y la convierte en ausente si queda vacía.
  String? _normalizarEtiqueta(String? etiqueta) {
    final String recortada = etiqueta?.trim() ?? '';
    return recortada.isEmpty ? null : recortada;
  }
}
