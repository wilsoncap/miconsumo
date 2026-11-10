import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:miconsumo/core/ui/theme/app_theme.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

void inicializarFechasEspanol() {
  setUpAll(() async {
    await initializeDateFormatting('es_CO');
  });
}

Widget envolverWidget(Widget child, {ThemeMode themeMode = ThemeMode.light}) {
  return MaterialApp(
    locale: const Locale('es', 'CO'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: AppTheme.claro(),
    darkTheme: AppTheme.oscuro(),
    themeMode: themeMode,
    home: child,
  );
}
