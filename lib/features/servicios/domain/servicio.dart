import 'unidad.dart';

class Servicio {
  const Servicio({
    required this.id,
    required this.nombre,
    required this.nombreNormalizado,
    required this.unidad,
    required this.activo,
    required this.creadoEn,
    required this.actualizadoEn,
    this.etiquetaContrato,
  });

  final int id;
  final String nombre;
  final String nombreNormalizado;
  final Unidad unidad;
  final String? etiquetaContrato;
  final bool activo;
  final DateTime creadoEn;
  final DateTime actualizadoEn;

  bool get tieneContrato =>
      etiquetaContrato != null && etiquetaContrato!.trim().isNotEmpty;
}
