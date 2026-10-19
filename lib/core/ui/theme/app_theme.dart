import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// Tema de la aplicación.
///
/// Material 3 con un esquema derivado de una semilla de color, en variante clara
/// y oscura, más los tokens de diseño del proyecto (Estándares de UI,
/// constitución v2.3.0).
abstract final class AppTheme {
  /// Semilla del esquema de color.
  static const Color semilla = Color(0xFF00695C);

  /// Tema claro.
  static ThemeData claro() => _construir(Brightness.light);

  /// Tema oscuro.
  static ThemeData oscuro() => _construir(Brightness.dark);

  static ThemeData _construir(Brightness brillo) {
    final ColorScheme esquema = ColorScheme.fromSeed(
      seedColor: semilla,
      brightness: brillo,
    );

    return ThemeData(
      colorScheme: esquema,
      extensions: const <ThemeExtension<dynamic>>[AppTokens()],
    );
  }
}
