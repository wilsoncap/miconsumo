import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/app/di/providers.dart';
import 'package:miconsumo/features/mediciones/domain/lectura.dart';
import 'package:miconsumo/features/mediciones/presentation/state/registrar_lectura_state.dart';
import 'package:miconsumo/features/mediciones/presentation/viewmodel/registrar_lectura_viewmodel.dart';
import 'package:miconsumo/features/servicios/domain/servicio.dart';

import '../../../support/fakes.dart';
import '../../../support/envoltorio.dart';

void main() {
  inicializarFechasEspanol();

  ProviderContainer crearContenedor({
    Servicio? servicio,
    List<Lectura>? lecturas,
    FakePhotoStorage? fotos,
  }) {
    final contenedor = ProviderContainer(
      overrides: [
        servicioRepositoryProvider.overrideWithValue(
          FakeServicioRepository(servicio ?? servicioDePrueba()),
        ),
        lecturaRepositoryProvider.overrideWithValue(
          FakeLecturaRepository(lecturas),
        ),
        photoStorageProvider.overrideWithValue(fotos ?? FakePhotoStorage()),
      ],
    );
    addTearDown(contenedor.dispose);
    return contenedor;
  }

  RegistrarLecturaViewModel escuchar(
    ProviderContainer contenedor, {
    int servicioId = 1,
  }) {
    final sub = contenedor.listen(
      registrarLecturaViewModelProvider(servicioId),
      (anterior, siguiente) {},
    );
    addTearDown(sub.close);
    return contenedor.read(
      registrarLecturaViewModelProvider(servicioId).notifier,
    );
  }

  group('RegistrarLecturaViewModel', () {
    test('rechaza un valor inválido', () async {
      final contenedor = crearContenedor();
      final vm = escuchar(contenedor);
      vm.actualizarValor('abc');

      final resultado = await vm.registrar();

      expect(resultado, isA<RegistroFallido>());
      expect(
        (resultado as RegistroFallido).motivo,
        MotivoFalloRegistro.valorInvalido,
      );
      expect(
        contenedor.read(registrarLecturaViewModelProvider(1)).valorInvalido,
        isTrue,
      );
    });

    test('rechaza fechas futuras', () async {
      final contenedor = crearContenedor();
      final vm = escuchar(contenedor);
      vm
        ..actualizarValor('10')
        ..actualizarFecha(DateTime.now().add(const Duration(days: 1)));

      final resultado = await vm.registrar();

      expect(resultado, isA<RegistroFallido>());
      expect(
        (resultado as RegistroFallido).motivo,
        MotivoFalloRegistro.fechaFutura,
      );
    });

    test('rechaza lecturas de un servicio inactivo', () async {
      final contenedor = crearContenedor(
        servicio: servicioDePrueba(activo: false),
      );
      final vm = escuchar(contenedor);
      vm.actualizarValor('10');

      final resultado = await vm.registrar();

      expect(resultado, isA<RegistroFallido>());
      expect(
        (resultado as RegistroFallido).motivo,
        MotivoFalloRegistro.servicioInactivo,
      );
    });

    test('pide confirmación si la lectura es menor que la anterior', () async {
      final anteriores = [
        lecturaDePrueba(
          id: 1,
          fecha: DateTime.now().subtract(const Duration(days: 5)),
          valor: '100',
        ),
      ];
      final contenedor = crearContenedor(lecturas: anteriores);
      final vm = escuchar(contenedor);
      vm.actualizarValor('50');

      final resultado = await vm.registrar();

      expect(resultado, isA<RegistroRequiereConfirmacion>());
      final confirmacion = resultado as RegistroRequiereConfirmacion;
      expect(confirmacion.valor, Decimal.parse('50'));
      expect(confirmacion.lecturaAnterior, Decimal.parse('100'));

      final segundo = await vm.registrar(confirmarMenor: true);
      expect(segundo, isA<RegistroGuardado>());
    });

    test('guarda la lectura y su foto', () async {
      final fotos = FakePhotoStorage();
      final contenedor = crearContenedor(fotos: fotos);
      final vm = escuchar(contenedor);
      vm
        ..actualizarValor('45,151')
        ..seleccionarFoto('/tmp/foto.jpg');

      final resultado = await vm.registrar();

      expect(resultado, isA<RegistroGuardado>());
      expect(fotos.guardadas, hasLength(1));
      final lecturas = contenedor.read(lecturaRepositoryProvider);
      final guardadas = await lecturas.obtenerLecturas(1);
      expect(guardadas, hasLength(1));
      expect(guardadas.single.valor, Decimal.parse('45.151'));
      expect(guardadas.single.rutaFoto, fotos.guardadas.single);
    });
  });
}
