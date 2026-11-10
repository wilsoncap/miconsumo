import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/widgets/comunes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/unidad.dart';
import '../state/servicio_form_data.dart';
import '../viewmodel/servicio_form_viewmodel.dart';

class ServicioFormPage extends ConsumerWidget {
  const ServicioFormPage({super.key, required this.servicioId});

  /// `0` significa un servicio nuevo.
  final int servicioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final esNuevo = servicioId == 0;
    final formularioAsync = ref.watch(
      servicioFormViewModelProvider(servicioId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? l10n.nuevoServicio : l10n.editarServicio),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: l10n.verMediciones,
              onPressed: () =>
                  context.push('/servicios/$servicioId/mediciones'),
              icon: const Icon(Icons.speed),
            ),
        ],
      ),
      body: formularioAsync.when(
        loading: () => const EstadoCargando(),
        error: (error, stackTrace) => EstadoError(
          onReintentar: () =>
              ref.invalidate(servicioFormViewModelProvider(servicioId)),
        ),
        data: (data) => _Formulario(servicioId: servicioId, data: data),
      ),
      bottomNavigationBar: formularioAsync.hasValue
          ? _BotonGuardar(servicioId: servicioId, data: formularioAsync.value!)
          : null,
    );
  }
}

class _Formulario extends ConsumerStatefulWidget {
  const _Formulario({required this.servicioId, required this.data});

  final int servicioId;
  final ServicioFormData data;

  @override
  ConsumerState<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends ConsumerState<_Formulario> {
  late final TextEditingController _nombre;
  late final TextEditingController _contrato;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.data.nombre);
    _contrato = TextEditingController(text: widget.data.contrato);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _contrato.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = widget.data;
    final colores = Theme.of(context).colorScheme;

    return ContenidoPage(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          TextField(
            controller: _nombre,
            maxLength: 60,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.nombreServicio,
              helperText: l10n.nombreAyuda,
              errorText: _mensajeErrorNombre(l10n, data.errorNombre),
            ),
            onChanged: ref
                .read(servicioFormViewModelProvider(widget.servicioId).notifier)
                .actualizarNombre,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.unidadMedida,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final unidad in Unidad.values)
                ChoiceChip(
                  label: Text(unidad.simbolo),
                  selected: data.unidad == unidad,
                  onSelected: data.unidadBloqueada
                      ? null
                      : (_) => ref
                            .read(
                              servicioFormViewModelProvider(widget.servicioId)
                                  .notifier,
                            )
                            .actualizarUnidad(unidad),
                ),
            ],
          ),
          if (data.unidadBloqueada) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: colores.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.unidadBloqueada,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colores.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          TextField(
            controller: _contrato,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: l10n.contratoOpcional,
              helperText: l10n.contratoAyuda,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            onChanged: ref
                .read(servicioFormViewModelProvider(widget.servicioId).notifier)
                .actualizarContrato,
          ),
          if (data.errorGeneral != null) ...[
            const SizedBox(height: 16),
            Text(
              data.errorGeneral == ErrorGeneralServicio.unidadBloqueada
                  ? l10n.unidadBloqueada
                  : l10n.errorCarga,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colores.error),
            ),
          ],
        ],
      ),
    );
  }

  String? _mensajeErrorNombre(
    AppLocalizations l10n,
    ErrorNombreServicio? error,
  ) {
    return switch (error) {
      ErrorNombreServicio.vacio => l10n.nombreVacioError,
      ErrorNombreServicio.duplicado => l10n.nombreDuplicadoError,
      null => null,
    };
  }
}

class _BotonGuardar extends ConsumerWidget {
  const _BotonGuardar({required this.servicioId, required this.data});

  final int servicioId;
  final ServicioFormData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: data.guardando ? null : () => _guardar(context, ref),
                child: data.guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.guardar),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _guardar(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final guardado = await ref
        .read(servicioFormViewModelProvider(servicioId).notifier)
        .guardar();
    if (guardado) {
      router.pop();
    } else {
      final actual = ref.read(servicioFormViewModelProvider(servicioId));
      if (actual.hasError) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.errorCarga)));
      }
    }
  }
}
