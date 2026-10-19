import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';

/// Símbolo visible de una unidad de medida.
///
/// Vive en la presentación y no en el dominio: el dominio solo conoce el valor
/// (ver `data-model.md`). El símbolo no se traduce, es el mismo en cualquier
/// idioma.
String simboloDeUnidad(UnidadMedida unidad) => switch (unidad) {
  UnidadMedida.kwh => 'kWh',
  UnidadMedida.m3 => 'm³',
  UnidadMedida.kg => 'kg',
};
