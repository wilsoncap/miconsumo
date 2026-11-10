enum Unidad {
  kwh('kWh'),
  m3('m³'),
  kg('kg');

  const Unidad(this.simbolo);

  final String simbolo;

  static Unidad desdeDb(String valor) {
    return Unidad.values.firstWhere(
      (unidad) => unidad.name == valor,
      orElse: () => throw ArgumentError('Unidad desconocida: $valor'),
    );
  }
}
