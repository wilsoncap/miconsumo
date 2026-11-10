/// Errores de dominio que la capa de presentación traduce a mensajes.
class NombreDuplicadoException implements Exception {
  const NombreDuplicadoException();
}

class UnidadBloqueadaException implements Exception {
  const UnidadBloqueadaException();
}

class ServicioNoEncontradoException implements Exception {
  const ServicioNoEncontradoException();
}
