// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Consumo';

  @override
  String get accionReintentar => 'Reintentar';

  @override
  String get accionGuardar => 'Guardar';

  @override
  String get accionCancelar => 'Cancelar';

  @override
  String get errorInesperado =>
      'Ocurrió un error inesperado. Inténtalo de nuevo.';

  @override
  String get pantallaTemporalMensaje =>
      'Tema, base de datos y navegación en marcha.';
}

/// The translations for Spanish Castilian, as used in Colombia (`es_CO`).
class AppLocalizationsEsCo extends AppLocalizationsEs {
  AppLocalizationsEsCo() : super('es_CO');
}
