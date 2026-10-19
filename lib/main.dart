import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miconsumo/app/app.dart';
import 'package:miconsumo/app/di/database_provider.dart';
import 'package:miconsumo/features/servicios/data/local/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Arranque de la aplicación.
///
/// La base de datos se crea aquí, en el directorio privado de la app, y se
/// inyecta por sobrescritura del provider para que las pruebas puedan
/// sustituirla por una base en memoria.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory directorio = await getApplicationDocumentsDirectory();
  final AppDatabase baseDeDatos = AppDatabase(
    NativeDatabase(File(p.join(directorio.path, 'miconsumo.sqlite'))),
  );

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(baseDeDatos)],
      child: const App(),
    ),
  );
}
