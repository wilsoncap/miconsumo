import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

/// Texto visible de un motivo de fallo.
///
/// El ViewModel guarda el motivo y no el texto, porque no puede traducir nada:
/// no importa Flutter (regla del ViewModel en la constitución). La traducción
/// ocurre aquí, en la presentación.
///
/// Recibe los textos por parámetro en lugar de un `BuildContext`, para que sea
/// una función pura y se pueda probar sin montar un widget.
String mensajeDeFallo(AppLocalizations textos, MotivoDeFallo motivo) =>
    switch (motivo) {
      MotivoDeFallo.nombreVacio => textos.falloNombreVacio,
      MotivoDeFallo.nombreDemasiadoLargo => textos.falloNombreDemasiadoLargo,
      MotivoDeFallo.nombreDuplicado => textos.falloNombreDuplicado,
      MotivoDeFallo.unidadRequerida => textos.falloUnidadRequerida,
      MotivoDeFallo.unidadInmutable => textos.falloUnidadInmutable,
      MotivoDeFallo.servicioNoEncontrado => textos.falloServicioNoEncontrado,
      MotivoDeFallo.almacenamiento => textos.falloAlmacenamiento,
    };
