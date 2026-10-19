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
  String get listaServiciosTitulo => 'Mis servicios';

  @override
  String get listaServiciosVaciaTitulo => 'Todavía no tienes servicios';

  @override
  String get listaServiciosVaciaMensaje =>
      'Registra la luz, el agua o el gas para empezar a medir su consumo.';

  @override
  String get listaServiciosVaciaAccion => 'Registrar el primero';

  @override
  String get listaServiciosAgregar => 'Agregar servicio';

  @override
  String get servicioInactivo => 'Inactivo';

  @override
  String get servicioConContrato => 'Con número de contrato';

  @override
  String get detalleServicioTituloNuevo => 'Nuevo servicio';

  @override
  String get detalleServicioTituloEditar => 'Editar servicio';

  @override
  String get campoNombreEtiqueta => 'Nombre del servicio';

  @override
  String get campoNombreAyuda => 'Por ejemplo: Luz, Agua, Gas';

  @override
  String get campoUnidadEtiqueta => 'Unidad de medida';

  @override
  String get campoUnidadBloqueada =>
      'No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.';

  @override
  String get campoEtiquetaContratoEtiqueta => 'Número de contrato (opcional)';

  @override
  String get campoEtiquetaContratoAyuda =>
      'Aparece en tu factura. Se queda en este teléfono.';

  @override
  String get falloNombreVacio => 'Escribe un nombre para el servicio.';

  @override
  String get falloNombreDemasiadoLargo =>
      'El nombre no puede superar los 60 caracteres.';

  @override
  String get falloNombreDuplicado => 'Ya tienes un servicio con ese nombre.';

  @override
  String get falloUnidadRequerida =>
      'Elige la unidad en la que se mide el consumo.';

  @override
  String get falloUnidadInmutable =>
      'No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.';

  @override
  String get falloServicioNoEncontrado => 'No encontramos ese servicio.';

  @override
  String get falloAlmacenamiento =>
      'No pudimos guardar los cambios. Inténtalo de nuevo.';
}

/// The translations for Spanish Castilian, as used in Colombia (`es_CO`).
class AppLocalizationsEsCo extends AppLocalizationsEs {
  AppLocalizationsEsCo() : super('es_CO');
}
