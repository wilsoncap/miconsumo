import 'package:flutter/material.dart';
import 'package:miconsumo/core/ui/theme/app_tokens.dart';

/// Estado de error reutilizable, con acción para reintentar.
///
/// Vive en `core` porque lo van a usar todas las funcionalidades, no solo la de
/// servicios.
class EstadoDeError extends StatelessWidget {
  /// Construye el estado de error.
  const EstadoDeError({
    required this.mensaje,
    required this.textoAccion,
    required this.alReintentar,
    super.key,
  });

  /// Qué salió mal, en lenguaje para el usuario.
  final String mensaje;

  /// Texto del botón.
  final String textoAccion;

  /// Acción para volver a intentarlo.
  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    final AppTokens tokens = context.tokens;
    final ThemeData tema = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.espacioXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: tokens.espacioXxl * 2,
              color: tema.colorScheme.error,
            ),
            SizedBox(height: tokens.espacioLg),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyMedium,
            ),
            SizedBox(height: tokens.espacioXl),
            OutlinedButton(onPressed: alReintentar, child: Text(textoAccion)),
          ],
        ),
      ),
    );
  }
}
