/// Indica si se puede cambiar la unidad de medida de un servicio.
///
/// Regla de FR-006: si el servicio ya tiene mediciones registradas, la unidad
/// queda bloqueada, porque cambiarla invalidaría el historial.
///
/// Recibe el dato "¿tiene mediciones?" como parámetro en lugar de consultarlo,
/// para seguir siendo una función pura y poder probarse sin base de datos.
bool puedeCambiarUnidad({required bool tieneMediciones}) => !tieneMediciones;
