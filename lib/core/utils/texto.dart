const Map<String, String> _equivalentes = {
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
  'ñ': 'n',
  'ç': 'c',
};

/// Normaliza un nombre para comparar servicios ignorando mayúsculas y acentos.
String normalizarNombre(String valor) {
  final minusculas = valor.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final rune in minusculas.runes) {
    final caracter = String.fromCharCode(rune);
    buffer.write(_equivalentes[caracter] ?? caracter);
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
}
