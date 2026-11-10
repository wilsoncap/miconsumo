import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color semilla = Color(0xFF00695C);
  static const Color superficieClara = Color(0xFFF7F9F8);
  static const Color superficieOscura = Color(0xFF101413);

  static ThemeData claro() {
    final esquema =
        ColorScheme.fromSeed(
          seedColor: semilla,
          brightness: Brightness.light,
        ).copyWith(
          surface: superficieClara,
          error: const Color(0xFFB3261E),
          tertiary: const Color(0xFFB26A00),
        );
    return _construir(esquema, superficieClara);
  }

  static ThemeData oscuro() {
    final esquema =
        ColorScheme.fromSeed(
          seedColor: semilla,
          brightness: Brightness.dark,
        ).copyWith(
          surface: superficieOscura,
          error: const Color(0xFFFFB4AB),
          tertiary: const Color(0xFFFFB74D),
        );
    return _construir(esquema, superficieOscura);
  }

  static ThemeData _construir(ColorScheme esquema, Color fondo) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: fondo,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: esquema.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: esquema.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: esquema.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: esquema.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: esquema.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: esquema.outlineVariant),
        showCheckmark: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: esquema.outlineVariant,
      ),
    );
  }
}

extension ColoresSemaforo on ColorScheme {
  Color get advertencia => brightness == Brightness.light
      ? const Color(0xFFB26A00)
      : const Color(0xFFFFB74D);

  Color get advertenciaContenedor => brightness == Brightness.light
      ? const Color(0xFFFFF1DB)
      : const Color(0xFF3E2C00);

  Color get mejora => brightness == Brightness.light
      ? const Color(0xFF00695C)
      : const Color(0xFF4DB6AC);
}

extension EstiloNumero on BuildContext {
  TextStyle? get estiloNumero => Theme.of(this).textTheme.headlineSmall
      ?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w600,
      );

  TextStyle? get estiloNumeroPequeno => Theme.of(this).textTheme.titleMedium
      ?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w600,
      );
}
