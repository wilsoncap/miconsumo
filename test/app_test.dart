import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/app/app.dart';
import 'package:miconsumo/features/servicios/presentation/providers.dart';

import 'support/envoltorio.dart';

void main() {
  inicializarFechasEspanol();

  testWidgets('la app abre en Mis servicios con el estado vacío', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          serviciosProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const MiConsumoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis servicios'), findsOneWidget);
    expect(find.text('Todavía no tienes servicios'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
  });
}
