import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/theme/app_theme.dart';
import '../../../../core/ui/widgets/comunes.dart';
import '../../../../core/utils/fechas.dart';
import '../../../../core/utils/numeros.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../servicios/domain/servicio.dart';
import '../../../servicios/presentation/providers.dart';
import '../../domain/calculo_consumo.dart';
import '../../domain/lectura.dart';
import '../providers.dart';
import 'miniatura_foto.dart';

class MedicionesPage extends ConsumerWidget {
  const MedicionesPage({super.key, required this.servicioId});

  final int servicioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final servicioAsync = ref.watch(servicioProvider(servicioId));
    final lecturasAsync = ref.watch(lecturasProvider(servicioId));

    final cargando = servicioAsync.isLoading || lecturasAsync.isLoading;
    final error = servicioAsync.hasError || lecturasAsync.hasError;
    final servicio = servicioAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mediciones),
        actions: [
          IconButton(
            tooltip: l10n.consumo,
            onPressed: () => context.push('/servicios/$servicioId/consumo'),
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: cargando
          ? const EstadoCargando()
          : error || servicio == null
          ? EstadoError(
              onReintentar: () {
                ref.invalidate(servicioProvider(servicioId));
                ref.invalidate(lecturasProvider(servicioId));
              },
            )
          : _Contenido(
              servicio: servicio,
              lecturas: lecturasAsync.value ?? const [],
            ),
      floatingActionButton: servicio != null && servicio.activo
          ? FloatingActionButton.extended(
              onPressed: () =>
                  context.push('/servicios/$servicioId/mediciones/nueva'),
              icon: const Icon(Icons.add),
              label: Text(l10n.registrarLectura),
            )
          : null,
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.servicio, required this.lecturas});

  final Servicio servicio;
  final List<Lectura> lecturas;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (lecturas.isEmpty) {
      return ContenidoPage(
        child: Column(
          children: [
            if (!servicio.activo)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AvisoAdvertencia(mensaje: l10n.servicioInactivoAviso),
              ),
            Expanded(
              child: EstadoVacio(
                icono: Icons.speed,
                titulo: l10n.lecturasVacioTitulo,
                mensaje: l10n.lecturasVacioMensaje,
                accionTexto: servicio.activo ? l10n.registrarLaPrimera : null,
                onAccion: servicio.activo
                    ? () => context.push(
                        '/servicios/${servicio.id}/mediciones/nueva',
                      )
                    : null,
              ),
            ),
          ],
        ),
      );
    }

    final tramos = CalculadoraConsumo.tramosPorLectura(lecturas);
    final vigentes = CalculadoraConsumo.vigentesOrdenadas(lecturas);
    final primeraVigenteId = vigentes.isEmpty ? null : vigentes.first.id;

    return ContenidoPage(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          if (!servicio.activo) ...[
            AvisoAdvertencia(mensaje: l10n.servicioInactivoAviso),
            const SizedBox(height: 16),
          ],
          for (var i = 0; i < lecturas.length; i++) ...[
            _FilaLectura(
              lectura: lecturas[i],
              servicio: servicio,
              tramo: tramos[lecturas[i].id],
              esPrimeraVigente: lecturas[i].id == primeraVigenteId,
            ),
            if (i < lecturas.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _FilaLectura extends StatelessWidget {
  const _FilaLectura({
    required this.lectura,
    required this.servicio,
    required this.tramo,
    required this.esPrimeraVigente,
  });

  final Lectura lectura;
  final Servicio servicio;
  final TramoConsumo? tramo;
  final bool esPrimeraVigente;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colores = Theme.of(context).colorScheme;
    final reemplazada = !lectura.esVigente;
    final colorPrincipal = reemplazada
        ? colores.onSurfaceVariant
        : colores.onSurface;
    final unidad = servicio.unidad.simbolo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Text(
                formatearFechaCorta(lectura.fecha),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colores.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${formatearDecimal(lectura.valor)} $unidad',
                    style: context.estiloNumeroPequeno?.copyWith(
                      color: colorPrincipal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (reemplazada)
                    Text(
                      l10n.reemplazada,
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: colores.onSurfaceVariant),
                    )
                  else
                    Text(
                      _detalleConsumo(l10n, unidad),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colores.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            if (lectura.tieneFoto) ...[
              const SizedBox(width: 12),
              MiniaturaFoto(
                rutaRelativa: lectura.rutaFoto!,
                onTap: () => context.push(
                  '/foto?ruta=${Uri.encodeQueryComponent(lectura.rutaFoto!)}',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _detalleConsumo(AppLocalizations l10n, String unidad) {
    if (esPrimeraVigente) return l10n.sinConsumoAun;
    final actual = tramo;
    if (actual == null) return l10n.sinConsumoAun;
    final valor = formatearDecimal(actual.consumo);
    if (actual.dias <= 1) {
      return l10n.consumoUnDia(valor, unidad);
    }
    return l10n.consumoVariosDias(actual.dias, valor, unidad);
  }
}
