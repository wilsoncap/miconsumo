import 'servicio.dart';
import 'unidad.dart';

abstract interface class ServicioRepository {
  Stream<List<Servicio>> observarServicios();

  Stream<Servicio?> observarServicio(int id);

  Future<Servicio?> obtenerServicio(int id);

  Future<int> crearServicio({
    required String nombre,
    required Unidad unidad,
    String? etiquetaContrato,
  });

  Future<void> actualizarServicio({
    required int id,
    required String nombre,
    required Unidad unidad,
    String? etiquetaContrato,
  });

  Future<void> cambiarActivo(int id, {required bool activo});

  Future<bool> existeNombre(String nombre, {int? excluirId});
}
