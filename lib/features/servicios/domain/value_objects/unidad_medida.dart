/// Unidad en la que se mide el consumo de un servicio.
///
/// Catálogo cerrado (FR-005). El dominio solo conoce el valor: el símbolo
/// visible se resuelve en la capa de presentación, y el código con el que se
/// guarda en la base de datos se resuelve en la capa de datos.
enum UnidadMedida {
  /// Electricidad.
  kwh,

  /// Agua y gas natural.
  m3,

  /// Gas licuado en pipeta, que en Colombia se vende por kilogramo.
  kg,
}
