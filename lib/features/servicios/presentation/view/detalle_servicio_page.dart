import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miconsumo/core/ui/mensaje_de_fallo.dart';
import 'package:miconsumo/core/ui/theme/app_tokens.dart';
import 'package:miconsumo/core/ui/widgets/estado_de_error.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/nombre_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/state/detalle_servicio_estado.dart';
import 'package:miconsumo/features/servicios/presentation/state/formulario_de_servicio.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/campo_de_texto.dart';
import 'package:miconsumo/features/servicios/presentation/view/widgets/selector_de_unidad.dart';
import 'package:miconsumo/features/servicios/presentation/viewmodel/detalle_servicio_viewmodel.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

/// Pantalla de detalle y creación de un servicio.
///
/// Solo compone: lee el formulario del ViewModel y lo traduce a componentes. El
/// único trabajo propio es mantener los controladores de texto y decidir a dónde
/// ir cuando el guardado termina (el ViewModel no navega).
class DetalleServicioPage extends ConsumerStatefulWidget {
  /// Construye la pantalla.
  ///
  /// Si [servicioId] es nulo, se está creando un servicio nuevo.
  const DetalleServicioPage({this.servicioId, super.key});

  /// Identificador del servicio en edición, o nulo si es nuevo.
  final int? servicioId;

  @override
  ConsumerState<DetalleServicioPage> createState() =>
      _DetalleServicioPageState();
}

class _DetalleServicioPageState extends ConsumerState<DetalleServicioPage> {
  late final TextEditingController _nombre;
  late final TextEditingController _etiqueta;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController();
    _etiqueta = TextEditingController();

    // Se hace después del primer fotograma para no modificar el estado del
    // proveedor durante la construcción del widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final DetalleServicioViewModel viewModel = ref.read(
        detalleServicioViewModelProvider.notifier,
      );
      final int? id = widget.servicioId;
      if (id == null) {
        viewModel.iniciarNuevo();
      } else {
        unawaited(viewModel.cargar(id));
      }
    });
  }

  @override
  void dispose() {
    _nombre.dispose();
    _etiqueta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations textos = AppLocalizations.of(context);
    final AppTokens tokens = context.tokens;
    final DetalleServicioEstado estado = ref.watch(
      detalleServicioViewModelProvider,
    );
    final DetalleServicioViewModel viewModel = ref.read(
      detalleServicioViewModelProvider.notifier,
    );

    // La navegación no la decide el ViewModel: él emite el estado y aquí se
    // reacciona.
    ref.listen<DetalleServicioEstado>(detalleServicioViewModelProvider, (
      DetalleServicioEstado? anterior,
      DetalleServicioEstado siguiente,
    ) {
      if (siguiente is DetalleGuardado) {
        if (context.canPop()) {
          context.pop();
        }
        return;
      }
      _sincronizarControladores(siguiente);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.servicioId == null
              ? textos.detalleServicioTituloNuevo
              : textos.detalleServicioTituloEditar,
        ),
      ),
      body: switch (estado) {
        DetalleCargando() => const Center(child: CircularProgressIndicator()),
        DetalleNuevo(:final FormularioDeServicio formulario) => _Formulario(
          formulario: formulario,
          controladorNombre: _nombre,
          controladorEtiqueta: _etiqueta,
          alCambiarNombre: viewModel.cambiarNombre,
          alCambiarUnidad: viewModel.cambiarUnidad,
          alCambiarEtiqueta: viewModel.cambiarEtiquetaContrato,
          alGuardar: viewModel.guardar,
        ),
        DetalleExistente(
          :final FormularioDeServicio formulario,
          :final bool unidadBloqueada,
        ) =>
          _Formulario(
            formulario: formulario,
            controladorNombre: _nombre,
            controladorEtiqueta: _etiqueta,
            alCambiarNombre: viewModel.cambiarNombre,
            alCambiarUnidad: viewModel.cambiarUnidad,
            alCambiarEtiqueta: viewModel.cambiarEtiquetaContrato,
            alGuardar: viewModel.guardar,
            unidadBloqueada: unidadBloqueada,
          ),
        DetalleGuardado() => const SizedBox.shrink(),
        DetalleConError(:final motivo) => EstadoDeError(
          mensaje: mensajeDeFallo(textos, motivo),
          textoAccion: textos.accionReintentar,
          alReintentar: () {
            final int? id = widget.servicioId;
            if (id == null) {
              viewModel.iniciarNuevo();
            } else {
              unawaited(viewModel.cargar(id));
            }
          },
        ),
      },
      bottomNavigationBar: switch (estado) {
        DetalleNuevo() || DetalleExistente() => Padding(
          padding: EdgeInsets.all(tokens.espacioLg),
          child: FilledButton(
            onPressed: _guardando(estado) ? null : viewModel.guardar,
            child: Text(textos.accionGuardar),
          ),
        ),
        _ => null,
      },
    );
  }

  /// Copia a los controladores lo que el ViewModel tenga cargado.
  void _sincronizarControladores(DetalleServicioEstado estado) {
    final FormularioDeServicio? formulario = switch (estado) {
      DetalleNuevo(:final FormularioDeServicio formulario) => formulario,
      DetalleExistente(:final FormularioDeServicio formulario) => formulario,
      _ => null,
    };
    if (formulario == null) {
      return;
    }
    if (_nombre.text != formulario.nombre) {
      _nombre.text = formulario.nombre;
    }
    if (_etiqueta.text != formulario.etiquetaContrato) {
      _etiqueta.text = formulario.etiquetaContrato;
    }
  }

  /// Verdadero mientras hay un guardado en curso.
  bool _guardando(DetalleServicioEstado estado) => switch (estado) {
    DetalleNuevo(:final bool guardando) => guardando,
    DetalleExistente(:final bool guardando) => guardando,
    _ => false,
  };
}

/// Formulario de alta y edición, compuesto por componentes.
class _Formulario extends StatelessWidget {
  const _Formulario({
    required this.formulario,
    required this.controladorNombre,
    required this.controladorEtiqueta,
    required this.alCambiarNombre,
    required this.alCambiarUnidad,
    required this.alCambiarEtiqueta,
    required this.alGuardar,
    this.unidadBloqueada = false,
  });

  final FormularioDeServicio formulario;
  final TextEditingController controladorNombre;
  final TextEditingController controladorEtiqueta;
  final ValueChanged<String> alCambiarNombre;
  final ValueChanged<UnidadMedida> alCambiarUnidad;
  final ValueChanged<String> alCambiarEtiqueta;
  final Future<void> Function() alGuardar;
  final bool unidadBloqueada;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations textos = AppLocalizations.of(context);
    final AppTokens tokens = context.tokens;

    return SingleChildScrollView(
      padding: EdgeInsets.all(tokens.espacioLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CampoDeTexto(
            etiqueta: textos.campoNombreEtiqueta,
            ayuda: textos.campoNombreAyuda,
            controlador: controladorNombre,
            alCambiar: alCambiarNombre,
            error: formulario.errorNombre == null
                ? null
                : mensajeDeFallo(textos, formulario.errorNombre!),
            longitudMaxima: NombreDeServicio.longitudMaxima,
          ),
          SizedBox(height: tokens.espacioLg),
          SelectorDeUnidad(
            etiqueta: textos.campoUnidadEtiqueta,
            valor: formulario.unidad,
            alCambiar: alCambiarUnidad,
            habilitado: !unidadBloqueada,
            motivoBloqueo: textos.campoUnidadBloqueada,
            error: formulario.errorUnidad == null
                ? null
                : mensajeDeFallo(textos, formulario.errorUnidad!),
          ),
          SizedBox(height: tokens.espacioLg),
          CampoDeTexto(
            etiqueta: textos.campoEtiquetaContratoEtiqueta,
            ayuda: textos.campoEtiquetaContratoAyuda,
            controlador: controladorEtiqueta,
            alCambiar: alCambiarEtiqueta,
          ),
        ],
      ),
    );
  }
}
