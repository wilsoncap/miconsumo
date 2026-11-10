import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/ui/widgets/comunes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/servicio.dart';
import '../providers.dart';
import 'icono_servicio.dart';

class MisServiciosPage extends ConsumerWidget {
  const MisServiciosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final serviciosAsync = ref.watch(serviciosProvider);
    final servicios = serviciosAsync.value;
    final hayDatos = servicios != null && servicios.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.misServicios)),
      body: serviciosAsync.when(
        loading: () => const EstadoCargando(),
        error: (error, stackTrace) =>
            EstadoError(onReintentar: () => ref.invalidate(serviciosProvider)),
        data: (lista) {
          if (lista.isEmpty) {
            return EstadoVacio(
              icono: Icons.home_outlined,
              titulo: l10n.serviciosVacioTitulo,
              mensaje: l10n.serviciosVacioMensaje,
              accionTexto: l10n.registrarElPrimero,
              onAccion: () => context.push('/servicios/nuevo'),
            );
          }
          return ContenidoPage(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: lista.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _FilaServicio(servicio: lista[index]),
            ),
          );
        },
      ),
      floatingActionButton: hayDatos
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/servicios/nuevo'),
              icon: const Icon(Icons.add),
              label: Text(l10n.agregarServicio),
            )
          : null,
    );
  }
}

class _FilaServicio extends ConsumerWidget {
  const _FilaServicio({required this.servicio});

  final Servicio servicio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colores = Theme.of(context).colorScheme;
    final inactivo = !servicio.activo;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/servicios/${servicio.id}/editar'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colores.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconoServicio(servicio),
                  color: inactivo ? colores.onSurfaceVariant : colores.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      servicio.nombre,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: inactivo
                            ? colores.onSurfaceVariant
                            : colores.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          servicio.unidad.simbolo,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colores.onSurfaceVariant),
                        ),
                        if (servicio.tieneContrato) ...[
                          const SizedBox(width: 8),
                          Semantics(
                            label: l10n.conContrato,
                            child: Icon(
                              Icons.badge_outlined,
                              size: 18,
                              color: colores.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (inactivo) ...[
                          const SizedBox(width: 12),
                          Text(
                            l10n.inactivo,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: colores.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: servicio.activo ? l10n.desactivar : l10n.reactivar,
                child: IconButton(
                  tooltip: servicio.activo ? l10n.desactivar : l10n.reactivar,
                  onPressed: () => _cambiarEstado(context, ref),
                  icon: Icon(
                    servicio.activo ? Icons.toggle_on : Icons.toggle_off,
                    size: 36,
                    color: servicio.activo
                        ? colores.primary
                        : colores.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cambiarEstado(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(servicioRepositoryProvider)
          .cambiarActivo(servicio.id, activo: !servicio.activo);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorCarga)));
    }
  }
}
