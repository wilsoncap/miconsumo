import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miconsumo/app/router/app_router.dart';
import 'package:miconsumo/core/ui/theme/app_theme.dart';
import 'package:miconsumo/l10n/app_localizations.dart';

/// Raíz de la aplicación.
///
/// Monta el router, el tema claro y oscuro y la localización en español de
/// Colombia.
class App extends ConsumerWidget {
  /// Construye la aplicación.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      theme: AppTheme.claro(),
      darkTheme: AppTheme.oscuro(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
