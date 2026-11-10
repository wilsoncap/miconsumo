import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Consumo'**
  String get appTitle;

  /// No description provided for @misServicios.
  ///
  /// In es, this message translates to:
  /// **'Mis servicios'**
  String get misServicios;

  /// No description provided for @nuevoServicio.
  ///
  /// In es, this message translates to:
  /// **'Nuevo servicio'**
  String get nuevoServicio;

  /// No description provided for @editarServicio.
  ///
  /// In es, this message translates to:
  /// **'Editar servicio'**
  String get editarServicio;

  /// No description provided for @mediciones.
  ///
  /// In es, this message translates to:
  /// **'Mediciones'**
  String get mediciones;

  /// No description provided for @registrarLectura.
  ///
  /// In es, this message translates to:
  /// **'Registrar lectura'**
  String get registrarLectura;

  /// No description provided for @consumo.
  ///
  /// In es, this message translates to:
  /// **'Consumo'**
  String get consumo;

  /// No description provided for @fotoDelMedidor.
  ///
  /// In es, this message translates to:
  /// **'Foto del medidor'**
  String get fotoDelMedidor;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @registrar.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get registrar;

  /// No description provided for @reintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentar;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @cerrar.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get cerrar;

  /// No description provided for @agregarServicio.
  ///
  /// In es, this message translates to:
  /// **'Agregar servicio'**
  String get agregarServicio;

  /// No description provided for @registrarElPrimero.
  ///
  /// In es, this message translates to:
  /// **'Registrar el primero'**
  String get registrarElPrimero;

  /// No description provided for @registrarLaPrimera.
  ///
  /// In es, this message translates to:
  /// **'Registrar la primera'**
  String get registrarLaPrimera;

  /// No description provided for @registrarOtra.
  ///
  /// In es, this message translates to:
  /// **'Registrar otra'**
  String get registrarOtra;

  /// No description provided for @verMediciones.
  ///
  /// In es, this message translates to:
  /// **'Ver mediciones'**
  String get verMediciones;

  /// No description provided for @verFoto.
  ///
  /// In es, this message translates to:
  /// **'Ver foto'**
  String get verFoto;

  /// No description provided for @tomarFoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get tomarFoto;

  /// No description provided for @elegirGaleria.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get elegirGaleria;

  /// No description provided for @quitarFoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar la foto'**
  String get quitarFoto;

  /// No description provided for @fotoLista.
  ///
  /// In es, this message translates to:
  /// **'Foto lista para guardar'**
  String get fotoLista;

  /// No description provided for @guardarIgual.
  ///
  /// In es, this message translates to:
  /// **'Guardar igual'**
  String get guardarIgual;

  /// No description provided for @inactivo.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get inactivo;

  /// No description provided for @desactivar.
  ///
  /// In es, this message translates to:
  /// **'Desactivar'**
  String get desactivar;

  /// No description provided for @reactivar.
  ///
  /// In es, this message translates to:
  /// **'Reactivar'**
  String get reactivar;

  /// No description provided for @conContrato.
  ///
  /// In es, this message translates to:
  /// **'Con número de contrato'**
  String get conContrato;

  /// No description provided for @conFoto.
  ///
  /// In es, this message translates to:
  /// **'Con foto del medidor'**
  String get conFoto;

  /// No description provided for @sinConsumoAun.
  ///
  /// In es, this message translates to:
  /// **'Sin consumo aún'**
  String get sinConsumoAun;

  /// No description provided for @reemplazada.
  ///
  /// In es, this message translates to:
  /// **'Reemplazada'**
  String get reemplazada;

  /// No description provided for @cargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get cargando;

  /// No description provided for @errorCarga.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la información. Intenta de nuevo.'**
  String get errorCarga;

  /// No description provided for @serviciosVacioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes servicios'**
  String get serviciosVacioTitulo;

  /// No description provided for @serviciosVacioMensaje.
  ///
  /// In es, this message translates to:
  /// **'Registra la luz, el agua o el gas para empezar a medir su consumo.'**
  String get serviciosVacioMensaje;

  /// No description provided for @nombreServicio.
  ///
  /// In es, this message translates to:
  /// **'Nombre del servicio'**
  String get nombreServicio;

  /// No description provided for @nombreAyuda.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: Luz, Agua, Gas'**
  String get nombreAyuda;

  /// No description provided for @nombreVacioError.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para el servicio.'**
  String get nombreVacioError;

  /// No description provided for @nombreDuplicadoError.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes un servicio con ese nombre.'**
  String get nombreDuplicadoError;

  /// No description provided for @unidadMedida.
  ///
  /// In es, this message translates to:
  /// **'Unidad de medida'**
  String get unidadMedida;

  /// No description provided for @unidadBloqueada.
  ///
  /// In es, this message translates to:
  /// **'No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.'**
  String get unidadBloqueada;

  /// No description provided for @contratoOpcional.
  ///
  /// In es, this message translates to:
  /// **'Número de contrato (opcional)'**
  String get contratoOpcional;

  /// No description provided for @contratoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Aparece en tu factura. Se queda en este teléfono.'**
  String get contratoAyuda;

  /// No description provided for @servicioInactivoAviso.
  ///
  /// In es, this message translates to:
  /// **'Ese servicio está desactivado, así que no admite lecturas.'**
  String get servicioInactivoAviso;

  /// No description provided for @lecturasVacioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay lecturas'**
  String get lecturasVacioTitulo;

  /// No description provided for @lecturasVacioMensaje.
  ///
  /// In es, this message translates to:
  /// **'Anota el número que muestra tu medidor para empezar a ver tu consumo.'**
  String get lecturasVacioMensaje;

  /// No description provided for @fechaLectura.
  ///
  /// In es, this message translates to:
  /// **'Fecha de la lectura: {fecha}'**
  String fechaLectura(String fecha);

  /// No description provided for @lecturaMedidor.
  ///
  /// In es, this message translates to:
  /// **'Lectura del medidor'**
  String get lecturaMedidor;

  /// No description provided for @lecturaAyuda.
  ///
  /// In es, this message translates to:
  /// **'El número que muestra el contador'**
  String get lecturaAyuda;

  /// No description provided for @fotoOpcionalTitulo.
  ///
  /// In es, this message translates to:
  /// **'Foto del medidor (opcional)'**
  String get fotoOpcionalTitulo;

  /// No description provided for @fotoRefuerza.
  ///
  /// In es, this message translates to:
  /// **'Una foto refuerza tu evidencia.'**
  String get fotoRefuerza;

  /// No description provided for @lecturaMenorTitulo.
  ///
  /// In es, this message translates to:
  /// **'La lectura es menor que la anterior'**
  String get lecturaMenorTitulo;

  /// No description provided for @lecturaMenorMensaje.
  ///
  /// In es, this message translates to:
  /// **'Anotaste {valor} {unidad} y la lectura anterior fue {anterior} {unidad}. Puede pasar si cambiaron el medidor. ¿La guardamos igual?'**
  String lecturaMenorMensaje(String valor, String anterior, String unidad);

  /// No description provided for @fechaFuturaError.
  ///
  /// In es, this message translates to:
  /// **'No puedes registrar una lectura con una fecha futura.'**
  String get fechaFuturaError;

  /// No description provided for @valorInvalidoError.
  ///
  /// In es, this message translates to:
  /// **'Escribe un número válido para la lectura.'**
  String get valorInvalidoError;

  /// No description provided for @correccionAviso.
  ///
  /// In es, this message translates to:
  /// **'Ya hay una lectura para ese día. Al registrar, la anterior quedará como Reemplazada.'**
  String get correccionAviso;

  /// No description provided for @esteMes.
  ///
  /// In es, this message translates to:
  /// **'Este mes'**
  String get esteMes;

  /// No description provided for @mesAnterior.
  ///
  /// In es, this message translates to:
  /// **'Mes anterior'**
  String get mesAnterior;

  /// No description provided for @mesSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Mes siguiente'**
  String get mesSiguiente;

  /// No description provided for @variacion.
  ///
  /// In es, this message translates to:
  /// **'Variación'**
  String get variacion;

  /// No description provided for @promedioDiario.
  ///
  /// In es, this message translates to:
  /// **'Promedio diario'**
  String get promedioDiario;

  /// No description provided for @diaMayorConsumo.
  ///
  /// In es, this message translates to:
  /// **'Día de mayor consumo'**
  String get diaMayorConsumo;

  /// No description provided for @sinComparacion.
  ///
  /// In es, this message translates to:
  /// **'Sin comparación'**
  String get sinComparacion;

  /// No description provided for @consumoNegativoAviso.
  ///
  /// In es, this message translates to:
  /// **'Hay un consumo negativo. Revisa si el medidor se reinició o si corregiste una lectura.'**
  String get consumoNegativoAviso;

  /// No description provided for @consumoSinLecturasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Sin lecturas todavía'**
  String get consumoSinLecturasTitulo;

  /// No description provided for @consumoSinLecturasMensaje.
  ///
  /// In es, this message translates to:
  /// **'Registra la lectura de tu medidor para empezar a ver tu consumo.'**
  String get consumoSinLecturasMensaje;

  /// No description provided for @consumoUnaLecturaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Hace falta una segunda lectura'**
  String get consumoUnaLecturaTitulo;

  /// No description provided for @consumoUnaLecturaMensaje.
  ///
  /// In es, this message translates to:
  /// **'Con una sola lectura no hay consumo que calcular. Registra otra y verás aquí tu consumo en {unidad}.'**
  String consumoUnaLecturaMensaje(String unidad);

  /// No description provided for @consumoMesSinLecturasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Este mes no tiene lecturas'**
  String get consumoMesSinLecturasTitulo;

  /// No description provided for @consumoMesSinLecturasMensaje.
  ///
  /// In es, this message translates to:
  /// **'Registra una lectura para este período o cambia de mes para ver otro consumo.'**
  String get consumoMesSinLecturasMensaje;

  /// No description provided for @consumoMesSinConsumoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay consumo este mes'**
  String get consumoMesSinConsumoTitulo;

  /// No description provided for @consumoMesSinConsumoMensaje.
  ///
  /// In es, this message translates to:
  /// **'La primera lectura del mes no produce consumo. Registra otra lectura para verlo aquí.'**
  String get consumoMesSinConsumoMensaje;

  /// No description provided for @fotoNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'La foto ya no está disponible.'**
  String get fotoNoDisponible;

  /// No description provided for @consumoUnDia.
  ///
  /// In es, this message translates to:
  /// **'{valor} {unidad}'**
  String consumoUnDia(String valor, String unidad);

  /// No description provided for @consumoVariosDias.
  ///
  /// In es, this message translates to:
  /// **'{dias} días · {valor} {unidad}'**
  String consumoVariosDias(int dias, String valor, String unidad);

  /// No description provided for @chartTooltip.
  ///
  /// In es, this message translates to:
  /// **'{fecha}: {valor} {unidad}'**
  String chartTooltip(String fecha, String valor, String unidad);

  /// No description provided for @consumoEtiqueta.
  ///
  /// In es, this message translates to:
  /// **'Consumo de {fecha}: {valor} {unidad}'**
  String consumoEtiqueta(Object fecha, Object unidad, Object valor);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
