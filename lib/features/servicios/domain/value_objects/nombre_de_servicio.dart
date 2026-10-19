/// Nombre de un tipo de servicio, junto con su forma normalizada.
///
/// Existe para que la regla de unicidad (FR-003) no pueda aplicarse de dos
/// maneras distintas: el dominio y la base de datos usan exactamente la misma
/// normalización, calculada en un único lugar.
///
/// Objeto de valor: dos nombres son iguales si su forma normalizada coincide,
/// aunque el texto escrito sea distinto ("Agua" y "agua" son el mismo nombre).
class NombreDeServicio {
  /// Construye un nombre válido a partir del texto que escribió el usuario.
  ///
  /// Lanza [ArgumentError] si el texto queda vacío tras recortar espacios
  /// (FR-002) o si supera [longitudMaxima]. NO comprueba duplicados: eso
  /// requiere conocer los demás servicios y corresponde al repositorio.
  factory NombreDeServicio(String entrada) {
    final String recortado = entrada.trim();
    if (recortado.isEmpty) {
      throw ArgumentError.value(
        entrada,
        'entrada',
        'El nombre del servicio no puede estar vacío',
      );
    }
    if (recortado.length > longitudMaxima) {
      throw ArgumentError.value(
        entrada,
        'entrada',
        'El nombre del servicio no puede superar $longitudMaxima caracteres',
      );
    }
    return NombreDeServicio._(recortado, normalizar(recortado));
  }

  const NombreDeServicio._(this.valor, this.normalizado);

  /// Longitud máxima admitida para un nombre.
  static const int longitudMaxima = 60;

  /// Texto tal como lo escribió el usuario, ya recortado.
  final String valor;

  /// Forma normalizada: sin acentos, en minúsculas y con los espacios internos
  /// colapsados. Es la que se compara y la que se guarda como índice único.
  final String normalizado;

  /// Equivalencias de acentos. La eñe no se normaliza: en español es una letra
  /// distinta, y confundir "año" con "ano" sería un error.
  static const Map<String, String> _equivalentes = <String, String>{
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ç': 'c',
  };

  /// Normaliza un texto para comparar nombres: recorta, pasa a minúsculas,
  /// quita los acentos y colapsa los espacios internos.
  static String normalizar(String texto) {
    final StringBuffer salida = StringBuffer();
    bool espacioPendiente = false;

    for (final int unidad in texto.trim().toLowerCase().runes) {
      final String caracter = String.fromCharCode(unidad);

      if (caracter.trim().isEmpty) {
        // Espacio en blanco: se recuerda y se escribe solo si viene otro
        // carácter después, para no dejar espacios al final.
        espacioPendiente = salida.isNotEmpty;
        continue;
      }

      if (espacioPendiente) {
        salida.write(' ');
        espacioPendiente = false;
      }

      salida.write(_equivalentes[caracter] ?? caracter);
    }

    return salida.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NombreDeServicio && other.normalizado == normalizado;

  @override
  int get hashCode => normalizado.hashCode;

  @override
  String toString() => 'NombreDeServicio($valor)';
}
