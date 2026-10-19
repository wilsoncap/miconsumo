import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/ui/theme/app_theme.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

/// Monta un widget suelto con el tema y los textos reales de la aplicación.
///
/// Los componentes de presentación reciben sus datos por parámetro, así que se
/// pueden probar sin proveedores ni base de datos.
Future<void> montarComponente(
  WidgetTester tester,
  Widget componente, {
  ThemeData? tema,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: tema ?? AppTheme.claro(),
      locale: const Locale('es', 'CO'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: componente),
    ),
  );
  await tester.pumpAndSettle();
}
