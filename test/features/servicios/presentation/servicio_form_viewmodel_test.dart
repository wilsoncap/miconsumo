import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/app/di/providers.dart';
import 'package:miconsumo/features/mediciones/domain/lectura.dart';
import 'package:miconsumo/features/servicios/presentation/state/servicio_form_data.dart';
import 'package:miconsumo/features/servicios/presentation/viewmodel/servicio_form_viewmodel.dart';
import 'package:miconsumo/features/servicios/domain/unidad.dart';

import '../../../support/envoltorio.dart';
import '../../../support/fakes.dart';

void main() {
  inicializarFechasEspanol();

  ProviderContainer crearContenedor({
    required FakeServicioRepository servicios,
    List<Lectura>? lecturas,
  }) {
    final contenedor = ProviderContainer(
      overrides: [
        servicioRepositoryProvider.overrideWithValue(servicios),
        lecturaRepositoryProvider.overrideWithValue(
          FakeLecturaRepository(lecturas),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    return contenedor;
  }

  Future<ServicioFormViewModel> abrir(
    ProviderContainer contenedor,
    int servicioId,
  ) async {
    final provider = servicioFormViewModelProvider(servicioId);
    final sub = contenedor.listen(provider, (anterior, siguiente) {});
    addTearDown(sub.close);
    await contenedor.read(provider.future);
    return contenedor.read(provider.notifier);
  }

  group('ServicioFormViewModel', () {
    test('valida el nombre vacío', () async {
      final servicios = FakeServicioRepository(servicioDePrueba());
      final contenedor = crearContenedor(servicios: servicios);
      final vm = await abrir(contenedor, 0);

      vm.actualizarNombre('   ');
      final guardado = await vm.guardar();

      expect(guardado, isFalse);
      expect(
        contenedor.read(servicioFormViewModelProvider(0)).value?.errorNombre,
        ErrorNombreServicio.vacio,
      );
    });

    test('detecta nombres duplicados sin importar mayúsculas', () async {
      final servicios = FakeServicioRepository(servicioDePrueba(nombre: 'Luz'));
      final contenedor = crearContenedor(servicios: servicios);
      final vm = await abrir(contenedor, 0);

      vm.actualizarNombre('LÚZ');
      final guardado = await vm.guardar();

      expect(guardado, isFalse);
      expect(
        contenedor.read(servicioFormViewModelProvider(0)).value?.errorNombre,
        ErrorNombreServicio.duplicado,
      );
    });

    test('crea un servicio nuevo', () async {
      final servicios = FakeServicioRepository(servicioDePrueba(nombre: 'Luz'));
      final contenedor = crearContenedor(servicios: servicios);
      final vm = await abrir(contenedor, 0);

      vm
        ..actualizarNombre('Agua')
        ..actualizarUnidad(Unidad.m3)
        ..actualizarContrato('88421');
      final guardado = await vm.guardar();

      expect(guardado, isTrue);
      expect(servicios.ultimoCreado, 'Agua');
    });

    test('bloquea la unidad cuando hay lecturas', () async {
      final servicio = servicioDePrueba(nombre: 'Luz');
      final servicios = FakeServicioRepository(servicio);
      final lecturas = [
        lecturaDePrueba(id: 1, fecha: DateTime(2026, 11, 1), valor: '100'),
      ];
      final contenedor = crearContenedor(
        servicios: servicios,
        lecturas: lecturas,
      );
      final vm = await abrir(contenedor, servicio.id);

      final data = contenedor
          .read(servicioFormViewModelProvider(servicio.id))
          .value!;
      expect(data.unidadBloqueada, isTrue);

      vm.actualizarUnidad(Unidad.m3);
      expect(
        contenedor
            .read(servicioFormViewModelProvider(servicio.id))
            .value
            ?.unidad,
        Unidad.kwh,
      );
    });
  });
}
