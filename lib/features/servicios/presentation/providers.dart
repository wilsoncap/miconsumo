import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../domain/servicio.dart';

final serviciosProvider = StreamProvider<List<Servicio>>(
  (ref) => ref.watch(servicioRepositoryProvider).observarServicios(),
);

final servicioProvider = StreamProvider.family<Servicio?, int>(
  (ref, id) => ref.watch(servicioRepositoryProvider).observarServicio(id),
);
