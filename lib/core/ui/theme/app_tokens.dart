import 'package:flutter/material.dart';

/// Tokens de diseño del proyecto.
///
/// Se exponen como [ThemeExtension] para que los widgets no contengan números
/// mágicos de estilo y para que respondan al tema claro y oscuro
/// (Estándares de UI, constitución v2.3.0).
///
/// La tipografía no se duplica aquí: vive en el [TextTheme] del tema, que ya es
/// un contenedor de tokens tipográficos por sí mismo.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    this.espacioXs = 4,
    this.espacioSm = 8,
    this.espacioMd = 12,
    this.espacioLg = 16,
    this.espacioXl = 24,
    this.espacioXxl = 32,
    this.radioSm = 8,
    this.radioMd = 12,
    this.radioLg = 16,
    this.grosorBorde = 1,
    this.duracionCorta = const Duration(milliseconds: 150),
    this.duracionMedia = const Duration(milliseconds: 300),
    this.areaTactilMinima = 48,
  });

  /// Separaciones, de la más pequeña a la más grande.
  final double espacioXs;
  final double espacioSm;
  final double espacioMd;
  final double espacioLg;
  final double espacioXl;
  final double espacioXxl;

  /// Radios de esquina.
  final double radioSm;
  final double radioMd;
  final double radioLg;

  /// Grosor de los bordes.
  final double grosorBorde;

  /// Duraciones de animación.
  final Duration duracionCorta;
  final Duration duracionMedia;

  /// Área táctil mínima exigida por accesibilidad (Estándares de UI).
  final double areaTactilMinima;

  /// Atajo de lectura: `contexto.tokens.espacioLg`.
  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>() ?? const AppTokens();

  @override
  AppTokens copyWith({
    double? espacioXs,
    double? espacioSm,
    double? espacioMd,
    double? espacioLg,
    double? espacioXl,
    double? espacioXxl,
    double? radioSm,
    double? radioMd,
    double? radioLg,
    double? grosorBorde,
    Duration? duracionCorta,
    Duration? duracionMedia,
    double? areaTactilMinima,
  }) {
    return AppTokens(
      espacioXs: espacioXs ?? this.espacioXs,
      espacioSm: espacioSm ?? this.espacioSm,
      espacioMd: espacioMd ?? this.espacioMd,
      espacioLg: espacioLg ?? this.espacioLg,
      espacioXl: espacioXl ?? this.espacioXl,
      espacioXxl: espacioXxl ?? this.espacioXxl,
      radioSm: radioSm ?? this.radioSm,
      radioMd: radioMd ?? this.radioMd,
      radioLg: radioLg ?? this.radioLg,
      grosorBorde: grosorBorde ?? this.grosorBorde,
      duracionCorta: duracionCorta ?? this.duracionCorta,
      duracionMedia: duracionMedia ?? this.duracionMedia,
      areaTactilMinima: areaTactilMinima ?? this.areaTactilMinima,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? otro, double t) {
    if (otro is! AppTokens) {
      return this;
    }
    return AppTokens(
      espacioXs: lerpDouble(espacioXs, otro.espacioXs, t),
      espacioSm: lerpDouble(espacioSm, otro.espacioSm, t),
      espacioMd: lerpDouble(espacioMd, otro.espacioMd, t),
      espacioLg: lerpDouble(espacioLg, otro.espacioLg, t),
      espacioXl: lerpDouble(espacioXl, otro.espacioXl, t),
      espacioXxl: lerpDouble(espacioXxl, otro.espacioXxl, t),
      radioSm: lerpDouble(radioSm, otro.radioSm, t),
      radioMd: lerpDouble(radioMd, otro.radioMd, t),
      radioLg: lerpDouble(radioLg, otro.radioLg, t),
      grosorBorde: lerpDouble(grosorBorde, otro.grosorBorde, t),
      duracionCorta: lerpDuration(duracionCorta, otro.duracionCorta, t),
      duracionMedia: lerpDuration(duracionMedia, otro.duracionMedia, t),
      areaTactilMinima: lerpDouble(areaTactilMinima, otro.areaTactilMinima, t),
    );
  }

  /// Interpola dos valores, devolviendo el primero si alguno es nulo.
  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  /// Interpola dos duraciones.
  static Duration lerpDuration(Duration a, Duration b, double t) {
    final int microsegundos =
        (a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t).round();
    return Duration(microseconds: microsegundos);
  }
}

/// Extensión de comodidad para leer los tokens desde cualquier widget.
extension AppTokensContext on BuildContext {
  /// Tokens de diseño vigentes en el tema actual.
  AppTokens get tokens => AppTokens.of(this);
}
