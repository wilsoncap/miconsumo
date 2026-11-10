import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/ui/widgets/comunes.dart';
import '../../../../core/utils/fechas.dart';
import '../../../../core/utils/numeros.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../servicios/domain/servicio.dart';
import '../../../servicios/presentation/providers.dart';
import '../state/registrar_lectura_state.dart';
import '../viewmodel/registrar_lectura_viewmodel.dart';

class RegistrarLecturaPage extends ConsumerWidget {
  const RegistrarLecturaPage({super.key, required this.servicioId});

  final int servicioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final servicioAsync = ref.watch(servicioProvider(servicioId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registrarLectura)),
      body: servicioAsync.when(
        loading: () => const EstadoCargando(),
        error: (error, stackTrace) => EstadoError(
          onReintentar: () => ref.invalidate(servicioProvider(servicioId)),
        ),
        data: (servicio) {
          if (servicio == null) {
            return EstadoError(
              onReintentar: () => ref.invalidate(servicioProvider(servicioId)),
            );
          }
          return _FormularioLectura(
            servicio: servicio,
            estado: ref.watch(registrarLecturaViewModelProvider(servicioId)),
          );
        },
      ),
      bottomNavigationBar: servicioAsync.hasValue && servicioAsync.value != null
          ? _BotonRegistrar(
              servicio: servicioAsync.value!,
              estado: ref.watch(registrarLecturaViewModelProvider(servicioId)),
            )
          : null,
    );
  }
}

class _FormularioLectura extends ConsumerStatefulWidget {
  const _FormularioLectura({required this.servicio, required this.estado});

  final Servicio servicio;
  final RegistrarLecturaState estado;

  @override
  ConsumerState<_FormularioLectura> createState() => _FormularioLecturaState();
}

class _FormularioLecturaState extends ConsumerState<_FormularioLectura> {
  late final TextEditingController _valor;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _valor = TextEditingController(text: widget.estado.valorTexto);
  }

  @override
  void dispose() {
    _valor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final estado = widget.estado;
    final servicio = widget.servicio;
    final colores = Theme.of(context).colorScheme;
    final unidad = servicio.unidad.simbolo;

    return ContenidoPage(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          if (!servicio.activo) ...[
            AvisoAdvertencia(mensaje: l10n.servicioInactivoAviso),
            const SizedBox(height: 16),
          ],
          Text(
            servicio.nombre,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _elegirFecha(context),
              icon: const Icon(Icons.event),
              label: Text(l10n.fechaLectura(formatearFechaLarga(estado.fecha))),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _valor,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: l10n.lecturaMedidor,
              helperText: l10n.lecturaAyuda,
              suffixText: unidad,
              errorText: estado.valorInvalido ? l10n.valorInvalidoError : null,
            ),
            onChanged: ref
                .read(registrarLecturaViewModelProvider(servicio.id).notifier)
                .actualizarValor,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.fotoOpcionalTitulo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.fotoRefuerza,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colores.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          if (!estado.tieneFoto)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _tomarFoto(context),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.tomarFoto),
                ),
                OutlinedButton.icon(
                  onPressed: () => _elegirDeGaleria(context),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.elegirGaleria),
                ),
              ],
            )
          else
            _FotoElegida(
              ruta: estado.rutaFotoTemporal!,
              onVer: () => _verFoto(context),
              onQuitar: () => ref
                  .read(registrarLecturaViewModelProvider(servicio.id).notifier)
                  .quitarFoto(),
            ),
          if (estado.errorGeneral) ...[
            const SizedBox(height: 16),
            Text(
              l10n.errorCarga,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colores.error),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _elegirFecha(BuildContext context) async {
    final estado = widget.estado;
    final hoy = soloFecha(DateTime.now());
    final fecha = await showDatePicker(
      context: context,
      initialDate: estado.fecha,
      firstDate: DateTime(2000),
      lastDate: hoy,
      locale: const Locale('es', 'CO'),
    );
    if (fecha != null && mounted) {
      ref
          .read(registrarLecturaViewModelProvider(widget.servicio.id).notifier)
          .actualizarFecha(fecha);
    }
  }

  Future<void> _tomarFoto(BuildContext context) async {
    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (foto != null && mounted) {
      ref
          .read(registrarLecturaViewModelProvider(widget.servicio.id).notifier)
          .seleccionarFoto(foto.path);
    }
  }

  Future<void> _elegirDeGaleria(BuildContext context) async {
    final foto = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (foto != null && mounted) {
      ref
          .read(registrarLecturaViewModelProvider(widget.servicio.id).notifier)
          .seleccionarFoto(foto.path);
    }
  }

  Future<void> _verFoto(BuildContext context) async {
    final ruta = widget.estado.rutaFotoTemporal;
    if (ruta == null) return;
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Image.file(File(ruta), fit: BoxFit.contain),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cerrar),
          ),
        ],
      ),
    );
  }
}

class _FotoElegida extends StatelessWidget {
  const _FotoElegida({
    required this.ruta,
    required this.onVer,
    required this.onQuitar,
  });

  final String ruta;
  final VoidCallback onVer;
  final VoidCallback onQuitar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(ruta),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 80,
              height: 80,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.fotoLista,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: [
                  TextButton(onPressed: onVer, child: Text(l10n.verFoto)),
                  TextButton(onPressed: onQuitar, child: Text(l10n.quitarFoto)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BotonRegistrar extends ConsumerWidget {
  const _BotonRegistrar({required this.servicio, required this.estado});

  final Servicio servicio;
  final RegistrarLecturaState estado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final habilitado = servicio.activo && !estado.guardando;

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
                onPressed: habilitado ? () => _registrar(context, ref) : null,
                child: estado.guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.registrar),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registrar(BuildContext context, WidgetRef ref) async {
    final resultado = await ref
        .read(registrarLecturaViewModelProvider(servicio.id).notifier)
        .registrar();
    if (!context.mounted) return;
    await procesarResultadoRegistro(
      context,
      ref,
      servicio: servicio,
      resultado: resultado,
    );
  }
}

Future<void> procesarResultadoRegistro(
  BuildContext context,
  WidgetRef ref, {
  required Servicio servicio,
  required ResultadoRegistro resultado,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  final unidad = servicio.unidad.simbolo;

  switch (resultado) {
    case RegistroGuardado():
      router.pop();
    case RegistroRequiereConfirmacion():
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded),
          title: Text(l10n.lecturaMenorTitulo),
          content: Text(
            l10n.lecturaMenorMensaje(
              formatearDecimal(resultado.valor),
              formatearDecimal(resultado.lecturaAnterior),
              unidad,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancelar),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.guardarIgual),
            ),
          ],
        ),
      );
      if (confirmar == true && context.mounted) {
        final segundo = await ref
            .read(registrarLecturaViewModelProvider(servicio.id).notifier)
            .registrar(confirmarMenor: true);
        if (context.mounted) {
          await procesarResultadoRegistro(
            context,
            ref,
            servicio: servicio,
            resultado: segundo,
          );
        }
      }
    case RegistroFallido():
      switch (resultado.motivo) {
        case MotivoFalloRegistro.servicioInactivo:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.servicioInactivoAviso)),
          );
        case MotivoFalloRegistro.fechaFutura:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.fechaFuturaError)),
          );
        case MotivoFalloRegistro.valorInvalido:
          break;
        case MotivoFalloRegistro.errorGuardado:
          messenger.showSnackBar(SnackBar(content: Text(l10n.errorCarga)));
      }
  }
}
