import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class ContenidoPage extends StatelessWidget {
  const ContenidoPage({super.key, required this.child, this.maxWidth = 720});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class EstadoCargando extends StatelessWidget {
  const EstadoCargando({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Semantics(
        label: l10n.cargando,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class EstadoError extends StatelessWidget {
  const EstadoError({super.key, required this.onReintentar});

  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colores = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colores.error,
              semanticLabel: l10n.errorCarga,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorCarga,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: onReintentar,
              child: Text(l10n.reintentar),
            ),
          ],
        ),
      ),
    );
  }
}

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
    this.accionTexto,
    this.onAccion,
  });

  final IconData icono;
  final String titulo;
  final String mensaje;
  final String? accionTexto;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: colores.primary),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colores.onSurfaceVariant),
            ),
            if (accionTexto != null && onAccion != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onAccion, child: Text(accionTexto!)),
            ],
          ],
        ),
      ),
    );
  }
}

class AvisoAdvertencia extends StatelessWidget {
  const AvisoAdvertencia({super.key, required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colores.advertenciaContenedor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: colores.advertencia),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colores.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class TarjetaDato extends StatelessWidget {
  const TarjetaDato({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.detalle,
    this.colorValor,
  });

  final String etiqueta;
  final String valor;
  final String? detalle;
  final Color? colorValor;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiqueta,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: colores.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: context.estiloNumeroPequeno?.copyWith(
                color: colorValor ?? colores.onSurface,
              ),
            ),
            if (detalle != null) ...[
              const SizedBox(height: 4),
              Text(
                detalle!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colores.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
