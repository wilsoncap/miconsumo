import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/mediciones/data/lectura_repository_drift.dart';
import '../../features/mediciones/data/photo_storage.dart';
import '../../features/mediciones/domain/lectura_repository.dart';
import '../../features/servicios/data/servicio_repository_drift.dart';
import '../../features/servicios/domain/servicio_repository.dart';
import '../data/app_database.dart';

/// Se sobreescribe en `main` con la base ya abierta.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('La base de datos no fue inicializada.'),
);

final servicioRepositoryProvider = Provider<ServicioRepository>(
  (ref) => ServicioRepositoryDrift(ref.watch(appDatabaseProvider)),
);

final lecturaRepositoryProvider = Provider<LecturaRepository>(
  (ref) => LecturaRepositoryDrift(ref.watch(appDatabaseProvider)),
);

final photoStorageProvider = Provider<PhotoStorage>(
  (ref) => AlmacenamientoFotosLocal(),
);
