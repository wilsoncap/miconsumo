import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../domain/lectura.dart';

final lecturasProvider = StreamProvider.family<List<Lectura>, int>(
  (ref, servicioId) =>
      ref.watch(lecturaRepositoryProvider).observarLecturas(servicioId),
);
