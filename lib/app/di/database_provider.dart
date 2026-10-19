import 'package:miconsumo/features/servicios/data/local/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Base de datos local de la aplicación.
///
/// Se sobrescribe en `main.dart` con la base real —que necesita resolver la ruta
/// del archivo de forma asíncrona— y en las pruebas con una base en memoria.
/// Si nadie la sobrescribe, falla de forma explícita en lugar de crear una base
/// en un sitio inesperado.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => throw UnimplementedError(
  'appDatabaseProvider debe sobrescribirse en el arranque o en las pruebas',
);
