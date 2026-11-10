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
  String get misServicios => 'Mis servicios';

  @override
  String get nuevoServicio => 'Nuevo servicio';

  @override
  String get editarServicio => 'Editar servicio';

  @override
  String get mediciones => 'Mediciones';

  @override
  String get registrarLectura => 'Registrar lectura';

  @override
  String get consumo => 'Consumo';

  @override
  String get fotoDelMedidor => 'Foto del medidor';

  @override
  String get guardar => 'Guardar';

  @override
  String get registrar => 'Registrar';

  @override
  String get reintentar => 'Reintentar';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get cerrar => 'Cerrar';

  @override
  String get agregarServicio => 'Agregar servicio';

  @override
  String get registrarElPrimero => 'Registrar el primero';

  @override
  String get registrarLaPrimera => 'Registrar la primera';

  @override
  String get registrarOtra => 'Registrar otra';

  @override
  String get verMediciones => 'Ver mediciones';

  @override
  String get verFoto => 'Ver foto';

  @override
  String get tomarFoto => 'Tomar foto';

  @override
  String get elegirGaleria => 'Elegir de la galería';

  @override
  String get quitarFoto => 'Quitar la foto';

  @override
  String get fotoLista => 'Foto lista para guardar';

  @override
  String get guardarIgual => 'Guardar igual';

  @override
  String get inactivo => 'Inactivo';

  @override
  String get desactivar => 'Desactivar';

  @override
  String get reactivar => 'Reactivar';

  @override
  String get conContrato => 'Con número de contrato';

  @override
  String get conFoto => 'Con foto del medidor';

  @override
  String get sinConsumoAun => 'Sin consumo aún';

  @override
  String get reemplazada => 'Reemplazada';

  @override
  String get cargando => 'Cargando…';

  @override
  String get errorCarga =>
      'No pudimos cargar la información. Intenta de nuevo.';

  @override
  String get serviciosVacioTitulo => 'Todavía no tienes servicios';

  @override
  String get serviciosVacioMensaje =>
      'Registra la luz, el agua o el gas para empezar a medir su consumo.';

  @override
  String get nombreServicio => 'Nombre del servicio';

  @override
  String get nombreAyuda => 'Por ejemplo: Luz, Agua, Gas';

  @override
  String get nombreVacioError => 'Escribe un nombre para el servicio.';

  @override
  String get nombreDuplicadoError => 'Ya tienes un servicio con ese nombre.';

  @override
  String get unidadMedida => 'Unidad de medida';

  @override
  String get unidadBloqueada =>
      'No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.';

  @override
  String get contratoOpcional => 'Número de contrato (opcional)';

  @override
  String get contratoAyuda =>
      'Aparece en tu factura. Se queda en este teléfono.';

  @override
  String get servicioInactivoAviso =>
      'Ese servicio está desactivado, así que no admite lecturas.';

  @override
  String get lecturasVacioTitulo => 'Todavía no hay lecturas';

  @override
  String get lecturasVacioMensaje =>
      'Anota el número que muestra tu medidor para empezar a ver tu consumo.';

  @override
  String fechaLectura(String fecha) {
    return 'Fecha de la lectura: $fecha';
  }

  @override
  String get lecturaMedidor => 'Lectura del medidor';

  @override
  String get lecturaAyuda => 'El número que muestra el contador';

  @override
  String get fotoOpcionalTitulo => 'Foto del medidor (opcional)';

  @override
  String get fotoRefuerza => 'Una foto refuerza tu evidencia.';

  @override
  String get lecturaMenorTitulo => 'La lectura es menor que la anterior';

  @override
  String lecturaMenorMensaje(String valor, String anterior, String unidad) {
    return 'Anotaste $valor $unidad y la lectura anterior fue $anterior $unidad. Puede pasar si cambiaron el medidor. ¿La guardamos igual?';
  }

  @override
  String get fechaFuturaError =>
      'No puedes registrar una lectura con una fecha futura.';

  @override
  String get valorInvalidoError => 'Escribe un número válido para la lectura.';

  @override
  String get correccionAviso =>
      'Ya hay una lectura para ese día. Al registrar, la anterior quedará como Reemplazada.';

  @override
  String get esteMes => 'Este mes';

  @override
  String get mesAnterior => 'Mes anterior';

  @override
  String get mesSiguiente => 'Mes siguiente';

  @override
  String get variacion => 'Variación';

  @override
  String get promedioDiario => 'Promedio diario';

  @override
  String get diaMayorConsumo => 'Día de mayor consumo';

  @override
  String get sinComparacion => 'Sin comparación';

  @override
  String get consumoNegativoAviso =>
      'Hay un consumo negativo. Revisa si el medidor se reinició o si corregiste una lectura.';

  @override
  String get consumoSinLecturasTitulo => 'Sin lecturas todavía';

  @override
  String get consumoSinLecturasMensaje =>
      'Registra la lectura de tu medidor para empezar a ver tu consumo.';

  @override
  String get consumoUnaLecturaTitulo => 'Hace falta una segunda lectura';

  @override
  String consumoUnaLecturaMensaje(String unidad) {
    return 'Con una sola lectura no hay consumo que calcular. Registra otra y verás aquí tu consumo en $unidad.';
  }

  @override
  String get consumoMesSinLecturasTitulo => 'Este mes no tiene lecturas';

  @override
  String get consumoMesSinLecturasMensaje =>
      'Registra una lectura para este período o cambia de mes para ver otro consumo.';

  @override
  String get consumoMesSinConsumoTitulo => 'Todavía no hay consumo este mes';

  @override
  String get consumoMesSinConsumoMensaje =>
      'La primera lectura del mes no produce consumo. Registra otra lectura para verlo aquí.';

  @override
  String get fotoNoDisponible => 'La foto ya no está disponible.';

  @override
  String consumoUnDia(String valor, String unidad) {
    return '$valor $unidad';
  }

  @override
  String consumoVariosDias(int dias, String valor, String unidad) {
    return '$dias días · $valor $unidad';
  }

  @override
  String chartTooltip(String fecha, String valor, String unidad) {
    return '$fecha: $valor $unidad';
  }

  @override
  String consumoEtiqueta(Object fecha, Object unidad, Object valor) {
    return 'Consumo de $fecha: $valor $unidad';
  }
}
