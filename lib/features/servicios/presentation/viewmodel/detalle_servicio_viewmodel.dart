import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/repositories/servicio_repository.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/nombre_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/state/detalle_servicio_estado.dart';
import 'package:miconsumo/features/servicios/presentation/state/formulario_de_servicio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detalle_servicio_viewmodel.g.dart';

/// ViewModel de la pantalla de detalle y creación de un servicio.
///
/// NO importa Flutter y NO navega: cuando el guardado sale bien emite
/// [DetalleGuardado] y es la View quien decide a dónde ir.
@riverpod
class DetalleServicioViewModel extends _$DetalleServicioViewModel {
  @override
  DetalleServicioEstado build() => const DetalleCargando();

  /// Prepara el formulario para crear un servicio nuevo.
  void iniciarNuevo() {
    state = const DetalleNuevo(formulario: FormularioDeServicio());
  }

  /// Carga un servicio existente y lo vuelca en el formulario.
  Future<void> cargar(int id) async {
    state = const DetalleCargando();

    final Resultado<TipoDeServicio> resultado = await ref
        .read(servicioRepositoryProvider)
        .obtenerServicio(id);

    state = switch (resultado) {
      Exito(:final TipoDeServicio valor) => DetalleExistente(
        id: id,
        formulario: FormularioDeServicio(
          nombre: valor.nombre.valor,
          unidad: valor.unidad,
          etiquetaContrato: valor.etiquetaContrato ?? '',
        ),
      ),
      Fallo(:final MotivoDeFallo motivo) => DetalleConError(motivo),
    };
  }

  /// Actualiza el nombre y limpia su error.
  ///
  /// No se valida mientras se escribe: mostrar errores en cada pulsación es
  /// ruidoso. La validación ocurre al guardar.
  void cambiarNombre(String texto) {
    _actualizarFormulario(
      (FormularioDeServicio f) => f.copyWith(nombre: texto, errorNombre: null),
    );
  }

  /// Actualiza la unidad y limpia su error.
  void cambiarUnidad(UnidadMedida unidad) {
    _actualizarFormulario(
      (FormularioDeServicio f) => f.copyWith(unidad: unidad, errorUnidad: null),
    );
  }

  /// Actualiza la etiqueta de contrato opcional.
  void cambiarEtiquetaContrato(String texto) {
    _actualizarFormulario(
      (FormularioDeServicio f) => f.copyWith(etiquetaContrato: texto),
    );
  }

  /// Valida y persiste el servicio.
  Future<void> guardar() async {
    final FormularioDeServicio formulario = _formularioActual;
    if (!formulario.esValido) {
      _marcarErroresDeValidacion(formulario);
      return;
    }

    final DetalleServicioEstado anterior = state;
    if (_estaGuardando) {
      return;
    }
    state = _conFormulario(formulario, guardando: true);

    final ServicioRepository repositorio = ref.read(servicioRepositoryProvider);
    final String nombre = formulario.nombre;
    final UnidadMedida unidad = formulario.unidad!;
    final String etiqueta = formulario.etiquetaContrato;

    final Resultado<TipoDeServicio> resultado = switch (anterior) {
      DetalleExistente(:final int id) => await repositorio.actualizarServicio(
        id: id,
        nombre: nombre,
        etiquetaContrato: etiqueta,
      ),
      _ => await repositorio.crearServicio(
        nombre: nombre,
        unidad: unidad,
        etiquetaContrato: etiqueta,
      ),
    };

    state = switch (resultado) {
      Exito(:final TipoDeServicio valor) => DetalleGuardado(valor.id!),
      Fallo(:final MotivoDeFallo motivo) when _esErrorDeNombre(motivo) =>
        _conFormulario(formulario.copyWith(errorNombre: motivo)),
      Fallo(:final MotivoDeFallo motivo) => DetalleConError(motivo),
    };
  }

  /// Valida el nombre y la unidad antes de llamar al repositorio.
  void _marcarErroresDeValidacion(FormularioDeServicio formulario) {
    final String recortado = formulario.nombre.trim();
    state = _conFormulario(
      formulario.copyWith(
        errorNombre: switch (recortado) {
          '' => MotivoDeFallo.nombreVacio,
          _ when recortado.length > NombreDeServicio.longitudMaxima =>
            MotivoDeFallo.nombreDemasiadoLargo,
          _ => null,
        },
        errorUnidad: formulario.unidad == null
            ? MotivoDeFallo.unidadRequerida
            : null,
      ),
    );
  }

  /// Verdadero si el fallo debe mostrarse junto al campo de nombre.
  bool _esErrorDeNombre(MotivoDeFallo motivo) => switch (motivo) {
    MotivoDeFallo.nombreVacio ||
    MotivoDeFallo.nombreDemasiadoLargo ||
    MotivoDeFallo.nombreDuplicado => true,
    _ => false,
  };

  /// El formulario del estado actual, o uno vacío si no aplica.
  FormularioDeServicio get _formularioActual => switch (state) {
    DetalleNuevo(:final FormularioDeServicio formulario) => formulario,
    DetalleExistente(:final FormularioDeServicio formulario) => formulario,
    _ => const FormularioDeServicio(),
  };

  /// Verdadero mientras hay un guardado en curso.
  bool get _estaGuardando => switch (state) {
    DetalleNuevo(:final bool guardando) => guardando,
    DetalleExistente(:final bool guardando) => guardando,
    _ => false,
  };

  /// Aplica un cambio al formulario conservando el resto del estado.
  void _actualizarFormulario(
    FormularioDeServicio Function(FormularioDeServicio) cambio,
  ) {
    final DetalleServicioEstado actual = state;
    if (actual is DetalleNuevo || actual is DetalleExistente) {
      state = _conFormulario(cambio(_formularioActual));
    }
  }

  /// Reconstruye el estado con otro formulario.
  DetalleServicioEstado _conFormulario(
    FormularioDeServicio formulario, {
    bool guardando = false,
  }) {
    return switch (state) {
      DetalleExistente(:final int id, :final bool unidadBloqueada) =>
        DetalleExistente(
          id: id,
          formulario: formulario,
          guardando: guardando,
          unidadBloqueada: unidadBloqueada,
        ),
      DetalleNuevo() => DetalleNuevo(
        formulario: formulario,
        guardando: guardando,
      ),
      _ => state,
    };
  }
}
