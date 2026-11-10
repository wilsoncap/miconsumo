import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app.dart';
import 'app/data/app_database.dart';
import 'app/di/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'es_CO';
  await initializeDateFormatting('es_CO');

  final baseDeDatos = await abrirBaseDeDatos();
  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(baseDeDatos)],
      child: const MiConsumoApp(),
    ),
  );
}
