import 'package:flutter/material.dart';
import 'package:miconsumo/core/ui/theme/app_tokens.dart';

/// Estado vacío reutilizable.
///
/// Sirve para cualquier pantalla que pueda quedarse sin contenido. Recibe sus
/// textos y su acción por parámetro, así que no sabe de qué pantalla se trata.
class EstadoVacio extends StatelessWidget {
  /// Construye el estado vacío.
  const EstadoVacio({
    required this.titulo,
    required this.mensaje,
    required this.textoAccion,
    required this.alPulsar,
    super.key,
  });

  /// Título, en tono de titular.
  final String titulo;

  /// Explicación de para qué sirve la pantalla.
  final String mensaje;

  /// Texto del botón de acción.
  final String textoAccion;

  /// Acción del botón.
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final AppTokens tokens = context.tokens;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.espacioXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: tokens.espacioSm),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: tokens.espacioXl),
            FilledButton(onPressed: alPulsar, child: Text(textoAccion)),
          ],
        ),
      ),
    );
  }
}
