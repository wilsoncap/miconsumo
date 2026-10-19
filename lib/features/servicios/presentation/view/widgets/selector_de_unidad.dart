import 'package:flutter/material.dart';
import 'package:miconsumo/core/ui/theme/app_tokens.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/unidad_visible.dart';

/// Selector de la unidad de medida de un servicio.
///
/// Componente de presentación: recibe el valor, las opciones, si está habilitado
/// y la acción por parámetro. No lee proveedores.
class SelectorDeUnidad extends StatelessWidget {
  /// Construye el selector.
  const SelectorDeUnidad({
    required this.etiqueta,
    required this.valor,
    required this.alCambiar,
    this.habilitado = true,
    this.motivoBloqueo,
    this.error,
    super.key,
  });

  /// Etiqueta del campo.
  final String etiqueta;

  /// Unidad seleccionada, o nula si aún no se ha elegido.
  final UnidadMedida? valor;

  /// Acción al elegir una unidad.
  final ValueChanged<UnidadMedida> alCambiar;

  /// Falso cuando la unidad no puede cambiarse (FR-006).
  final bool habilitado;

  /// Explicación de por qué está bloqueado.
  final String? motivoBloqueo;

  /// Texto de error, si lo hay.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final AppTokens tokens = context.tokens;
    final ThemeData tema = Theme.of(context);
    final String? errorActual = error;
    final String? motivoActual = motivoBloqueo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(etiqueta, style: tema.textTheme.titleSmall),
        SizedBox(height: tokens.espacioSm),
        Wrap(
          spacing: tokens.espacioSm,
          runSpacing: tokens.espacioSm,
          children: UnidadMedida.values
              .map(
                (UnidadMedida unidad) => ChoiceChip(
                  label: Text(simboloDeUnidad(unidad)),
                  selected: unidad == valor,
                  onSelected: habilitado ? (bool _) => alCambiar(unidad) : null,
                ),
              )
              .toList(growable: false),
        ),
        if (errorActual != null) ...<Widget>[
          SizedBox(height: tokens.espacioSm),
          Text(
            errorActual,
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.error,
            ),
          ),
        ],
        if (!habilitado && motivoActual != null) ...<Widget>[
          SizedBox(height: tokens.espacioSm),
          Text(motivoActual, style: tema.textTheme.bodySmall),
        ],
      ],
    );
  }
}
