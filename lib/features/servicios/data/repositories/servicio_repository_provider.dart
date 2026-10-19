import 'package:miconsumo/app/di/database_provider.dart';
import 'package:miconsumo/features/servicios/domain/repositories/servicio_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'servicio_repository_impl.dart';

part 'servicio_repository_provider.g.dart';

/// Repositorio de tipos de servicio.
///
/// Es el punto por el que los ViewModel acceden a los datos: no conocen Drift ni
/// la forma de la base de datos (contrato de MVVM de la constitución).
@riverpod
ServicioRepository servicioRepository(Ref ref) =>
    ServicioRepositoryImpl(ref.watch(appDatabaseProvider).serviciosDao);
