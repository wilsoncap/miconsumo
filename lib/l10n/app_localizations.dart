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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('es', 'CO'),
  ];

  /// Nombre de la aplicación, mostrado en la barra superior.
  ///
  /// In es, this message translates to:
  /// **'Mi Consumo'**
  String get appTitle;

  /// Acción para volver a intentar una operación que falló.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get accionReintentar;

  /// Acción para guardar un formulario.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get accionGuardar;

  /// Acción para abandonar un formulario sin guardar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get accionCancelar;

  /// Mensaje genérico cuando falla una operación.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado. Inténtalo de nuevo.'**
  String get errorInesperado;

  /// Título de la pantalla que lista los servicios del hogar.
  ///
  /// In es, this message translates to:
  /// **'Mis servicios'**
  String get listaServiciosTitulo;

  /// Título del estado vacío cuando no hay ningún servicio registrado.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes servicios'**
  String get listaServiciosVaciaTitulo;

  /// Explicación del estado vacío del listado.
  ///
  /// In es, this message translates to:
  /// **'Registra la luz, el agua o el gas para empezar a medir su consumo.'**
  String get listaServiciosVaciaMensaje;

  /// Acción del estado vacío para crear el primer servicio.
  ///
  /// In es, this message translates to:
  /// **'Registrar el primero'**
  String get listaServiciosVaciaAccion;

  /// Acción para crear un servicio nuevo desde el listado.
  ///
  /// In es, this message translates to:
  /// **'Agregar servicio'**
  String get listaServiciosAgregar;

  /// Etiqueta que marca un servicio desactivado.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get servicioInactivo;

  /// Indicación de que el servicio tiene etiqueta de contrato, para accesibilidad.
  ///
  /// In es, this message translates to:
  /// **'Con número de contrato'**
  String get servicioConContrato;

  /// Título de la pantalla cuando se crea un servicio.
  ///
  /// In es, this message translates to:
  /// **'Nuevo servicio'**
  String get detalleServicioTituloNuevo;

  /// Título de la pantalla cuando se edita un servicio existente.
  ///
  /// In es, this message translates to:
  /// **'Editar servicio'**
  String get detalleServicioTituloEditar;

  /// Etiqueta del campo de nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre del servicio'**
  String get campoNombreEtiqueta;

  /// Texto de ayuda del campo de nombre.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: Luz, Agua, Gas'**
  String get campoNombreAyuda;

  /// Etiqueta del selector de unidad.
  ///
  /// In es, this message translates to:
  /// **'Unidad de medida'**
  String get campoUnidadEtiqueta;

  /// Explicación de por qué el selector de unidad está deshabilitado (FR-006).
  ///
  /// In es, this message translates to:
  /// **'No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.'**
  String get campoUnidadBloqueada;

  /// Etiqueta del campo opcional de número de contrato.
  ///
  /// In es, this message translates to:
  /// **'Número de contrato (opcional)'**
  String get campoEtiquetaContratoEtiqueta;

  /// Aclaración de que la etiqueta de contrato es local y opcional (FR-013, FR-014).
  ///
  /// In es, this message translates to:
  /// **'Aparece en tu factura. Se queda en este teléfono.'**
  String get campoEtiquetaContratoAyuda;

  /// Mensaje cuando el nombre está vacío.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para el servicio.'**
  String get falloNombreVacio;

  /// Mensaje cuando el nombre es demasiado largo.
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede superar los 60 caracteres.'**
  String get falloNombreDemasiadoLargo;

  /// Mensaje cuando el nombre ya existe (sin distinguir mayúsculas ni acentos).
  ///
  /// In es, this message translates to:
  /// **'Ya tienes un servicio con ese nombre.'**
  String get falloNombreDuplicado;

  /// Mensaje cuando no se seleccionó unidad.
  ///
  /// In es, this message translates to:
  /// **'Elige la unidad en la que se mide el consumo.'**
  String get falloUnidadRequerida;

  /// Mensaje cuando se intenta cambiar la unidad con historial (FR-006).
  ///
  /// In es, this message translates to:
  /// **'No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.'**
  String get falloUnidadInmutable;

  /// Mensaje cuando el servicio ya no existe.
  ///
  /// In es, this message translates to:
  /// **'No encontramos ese servicio.'**
  String get falloServicioNoEncontrado;

  /// Mensaje cuando falla la base de datos.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar los cambios. Inténtalo de nuevo.'**
  String get falloAlmacenamiento;
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
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case 'CO':
            return AppLocalizationsEsCo();
        }
        break;
      }
  }

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
