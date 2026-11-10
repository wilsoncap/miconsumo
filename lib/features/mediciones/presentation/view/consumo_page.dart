import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/theme/app_theme.dart';
import '../../../../core/ui/widgets/comunes.dart';
import '../../../../core/utils/fechas.dart';
import '../../../../core/utils/numeros.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../servicios/presentation/providers.dart';
import '../../domain/calculo_consumo.dart';
import '../providers.dart';
import '../state/consumo_state.dart';
import '../viewmodel/consumo_viewmodel.dart';

class ConsumoPage extends ConsumerWidget {
  const ConsumoPage({super.key, required this.servicioId});

  final int servicioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final estado = ref.watch(consumoViewModelProvider(servicioId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.consumo)),
      body: switch (estado) {
        ConsumoCargando() => const EstadoCargando(),
        ConsumoError() => EstadoError(
          onReintentar: () {
            ref.invalidate(servicioProvider(servicioId));
            ref.invalidate(lecturasProvider(servicioId));
            ref.invalidate(consumoViewModelProvider(servicioId));
          },
        ),
        ConsumoSinLecturas(:final mes, :final puedeAvanzar) => _EstadoConMes(
          servicioId: servicioId,
          mes: mes,
          puedeAvanzar: puedeAvanzar,
          estado: EstadoVacio(
            icono: Icons.bar_chart,
            titulo: l10n.consumoSinLecturasTitulo,
            mensaje: l10n.consumoSinLecturasMensaje,
            accionTexto: l10n.registrarLaPrimera,
            onAccion: () =>
                context.push('/servicios/$servicioId/mediciones/nueva'),
          ),
        ),
        ConsumoUnaLectura(:final mes, :final unidad, :final puedeAvanzar) =>
          _EstadoConMes(
            servicioId: servicioId,
            mes: mes,
            puedeAvanzar: puedeAvanzar,
            estado: EstadoVacio(
              icono: Icons.bar_chart,
              titulo: l10n.consumoUnaLecturaTitulo,
              mensaje: l10n.consumoUnaLecturaMensaje(unidad.simbolo),
              accionTexto: l10n.registrarOtra,
              onAccion: () =>
                  context.push('/servicios/$servicioId/mediciones/nueva'),
            ),
          ),
        ConsumoMesSinLecturas(:final mes, :final puedeAvanzar) => _EstadoConMes(
          servicioId: servicioId,
          mes: mes,
          puedeAvanzar: puedeAvanzar,
          estado: EstadoVacio(
            icono: Icons.event_busy_outlined,
            titulo: l10n.consumoMesSinLecturasTitulo,
            mensaje: l10n.consumoMesSinLecturasMensaje,
          ),
        ),
        ConsumoMesSinConsumo(:final mes, :final puedeAvanzar) => _EstadoConMes(
          servicioId: servicioId,
          mes: mes,
          puedeAvanzar: puedeAvanzar,
          estado: EstadoVacio(
            icono: Icons.show_chart,
            titulo: l10n.consumoMesSinConsumoTitulo,
            mensaje: l10n.consumoMesSinConsumoMensaje,
            accionTexto: l10n.registrarOtra,
            onAccion: () =>
                context.push('/servicios/$servicioId/mediciones/nueva'),
          ),
        ),
        ConsumoDatos(:final resumen, :final puedeAvanzar) => _DatosConsumo(
          servicioId: servicioId,
          resumen: resumen,
          puedeAvanzar: puedeAvanzar,
        ),
      },
    );
  }
}

class _EstadoConMes extends ConsumerWidget {
  const _EstadoConMes({
    required this.servicioId,
    required this.mes,
    required this.puedeAvanzar,
    required this.estado,
  });

  final int servicioId;
  final DateTime mes;
  final bool puedeAvanzar;
  final Widget estado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContenidoPage(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: SelectorMes(
              mes: mes,
              puedeAvanzar: puedeAvanzar,
              onAnterior: () => ref
                  .read(consumoViewModelProvider(servicioId).notifier)
                  .irMesAnterior(),
              onSiguiente: () => ref
                  .read(consumoViewModelProvider(servicioId).notifier)
                  .irMesSiguiente(),
            ),
          ),
          Expanded(child: estado),
        ],
      ),
    );
  }
}

class _DatosConsumo extends ConsumerWidget {
  const _DatosConsumo({
    required this.servicioId,
    required this.resumen,
    required this.puedeAvanzar,
  });

  final int servicioId;
  final ResumenConsumo resumen;
  final bool puedeAvanzar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colores = Theme.of(context).colorScheme;
    final unidad = resumen.unidad.simbolo;

    return ContenidoPage(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SelectorMes(
            mes: resumen.mes,
            puedeAvanzar: puedeAvanzar,
            onAnterior: () => ref
                .read(consumoViewModelProvider(servicioId).notifier)
                .irMesAnterior(),
            onSiguiente: () => ref
                .read(consumoViewModelProvider(servicioId).notifier)
                .irMesSiguiente(),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.consumo} (${resumen.unidad.simbolo})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _GraficaConsumo(resumen: resumen, l10n: l10n),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++) ...[
                Container(width: 5, height: 2, color: colores.onSurfaceVariant),
                if (i < 2) const SizedBox(width: 2),
              ],
              const SizedBox(width: 8),
              Text(
                '${l10n.promedioDiario}: '
                '${resumen.promedioDiario == null ? '—' : '${formatearDecimal(resumen.promedioDiario!, maxDecimales: 2)} $unidad'}',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colores.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (resumen.hayConsumoNegativo) ...[
            AvisoAdvertencia(mensaje: l10n.consumoNegativoAviso),
            const SizedBox(height: 16),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final dosColumnas = constraints.maxWidth >= 560;
              final ancho = dosColumnas
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: ancho,
                    child: TarjetaDato(
                      etiqueta: l10n.esteMes,
                      valor: '${formatearDecimal(resumen.total)} $unidad',
                    ),
                  ),
                  SizedBox(
                    width: ancho,
                    child: TarjetaDato(
                      etiqueta: l10n.mesAnterior,
                      valor: resumen.totalAnterior == null
                          ? '—'
                          : '${formatearDecimal(resumen.totalAnterior!)} $unidad',
                    ),
                  ),
                  SizedBox(
                    width: ancho,
                    child: TarjetaDato(
                      etiqueta: l10n.variacion,
                      valor: resumen.variacionPorcentaje == null
                          ? l10n.sinComparacion
                          : formatearPorcentaje(resumen.variacionPorcentaje!),
                      colorValor:
                          resumen.variacionPorcentaje != null &&
                              resumen.variacionPorcentaje! < Decimal.zero
                          ? colores.mejora
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: ancho,
                    child: TarjetaDato(
                      etiqueta: l10n.promedioDiario,
                      valor: resumen.promedioDiario == null
                          ? '—'
                          : '${formatearDecimal(resumen.promedioDiario!, maxDecimales: 2)} $unidad',
                    ),
                  ),
                  SizedBox(
                    width: ancho,
                    child: TarjetaDato(
                      etiqueta: l10n.diaMayorConsumo,
                      valor: resumen.diaMayor == null
                          ? '—'
                          : '${formatearDecimal(resumen.diaMayor!.consumo)} $unidad',
                      detalle: resumen.diaMayor == null
                          ? null
                          : formatearFechaCorta(resumen.diaMayor!.fecha),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class SelectorMes extends StatelessWidget {
  const SelectorMes({
    super.key,
    required this.mes,
    required this.puedeAvanzar,
    required this.onAnterior,
    required this.onSiguiente,
  });

  final DateTime mes;
  final bool puedeAvanzar;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Semantics(
          button: true,
          label: l10n.mesAnterior,
          child: IconButton(
            tooltip: l10n.mesAnterior,
            onPressed: onAnterior,
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        Expanded(
          child: Text(
            formatearMes(mes),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Semantics(
          button: true,
          enabled: puedeAvanzar,
          label: l10n.mesSiguiente,
          child: IconButton(
            tooltip: l10n.mesSiguiente,
            onPressed: puedeAvanzar ? onSiguiente : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}

class _GraficaConsumo extends StatelessWidget {
  const _GraficaConsumo({required this.resumen, required this.l10n});

  final ResumenConsumo resumen;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final unidad = resumen.unidad.simbolo;
    final tramos = resumen.tramos;
    if (tramos.isEmpty) return const SizedBox.shrink();

    final valores = tramos.map((tramo) => tramo.consumo.toDouble()).toList();
    final mayor = valores.reduce(math.max);
    final menor = valores.reduce(math.min);
    final promedio = resumen.promedioDiario?.toDouble() ?? 0;
    final maxY = math.max(math.max(mayor, promedio) * 1.25, 1.0);
    final minY = math.min(menor * 1.25, 0.0);
    final intervalo = ((maxY - minY) / 4).abs() < 0.5 ? 1.0 : (maxY - minY) / 4;

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          minY: minY,
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            for (var i = 0; i < tramos.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: tramos[i].consumo.toDouble(),
                    width: 14,
                    color: tramos[i].consumo < Decimal.zero
                        ? colores.error
                        : colores.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
          ],
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: intervalo,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colores.outlineVariant.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                unidad,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              axisNameSize: 16,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: intervalo,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    formatearDecimal(
                      Decimal.parse(value.toStringAsFixed(1)),
                      maxDecimales: 1,
                    ),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final indice = value.toInt();
                  if (indice < 0 || indice >= tramos.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      '${tramos[indice].fecha.day}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              if (resumen.promedioDiario != null)
                HorizontalLine(
                  y: promedio,
                  color: colores.onSurfaceVariant,
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                ),
            ],
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => colores.inverseSurface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final tramo = tramos[groupIndex];
                return BarTooltipItem(
                  l10n.chartTooltip(
                    formatearFechaCorta(tramo.fecha),
                    formatearDecimal(tramo.consumo),
                    unidad,
                  ),
                  TextStyle(
                    color: colores.onInverseSurface,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
        ),
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 300),
      ),
    );
  }
}
