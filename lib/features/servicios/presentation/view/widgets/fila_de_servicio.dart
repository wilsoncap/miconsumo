import 'package:flutter/material.dart';
import 'package:miconsumo/core/ui/theme/app_tokens.dart';
import 'package:miconsumo/features/servicios/presentation/state/servicio_en_lista.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

/// Fila del listado de servicios.
///
/// Componente de presentación: recibe TODO por parámetro y NO lee proveedores
/// (Estándares de UI, constitución v2.3.1). Por eso se puede probar y
/// previsualizar con datos fijos.
class FilaDeServicio extends StatelessWidget {
  /// Construye la fila.
  const FilaDeServicio({
    required this.servicio,
    required this.alPulsar,
    super.key,
  });

  /// Datos que se pintan.
  final ServicioEnLista servicio;

  /// Acción al pulsar la fila.
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final AppTokens tokens = context.tokens;
    final AppLocalizations textos = AppLocalizations.of(context);

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: _etiquetaAccesible(textos),
      child: ListTile(
        onTap: alPulsar,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.espacioLg,
          vertical: tokens.espacioSm,
        ),
        title: Text(servicio.nombre),
        subtitle: Text(servicio.simboloUnidad),
        trailing: servicio.activo
            ? null
            : Text(
                textos.servicioInactivo,
                style: Theme.of(context).textTheme.labelMedium,
              ),
      ),
    );
  }

  /// Texto que anuncia el lector de pantalla.
  String _etiquetaAccesible(AppLocalizations textos) {
    final List<String> partes = <String>[
      servicio.nombre,
      servicio.simboloUnidad,
      if (!servicio.activo) textos.servicioInactivo,
      if (servicio.tieneEtiquetaContrato) textos.servicioConContrato,
    ];
    return partes.join(', ');
  }
}
