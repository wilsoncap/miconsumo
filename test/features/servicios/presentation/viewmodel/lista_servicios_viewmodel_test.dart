import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/state/lista_servicios_estado.dart';
import 'package:miconsumo/features/servicios/presentation/viewmodel/lista_servicios_viewmodel.dart';

import '../../../../helpers/repositorio_de_servicios_falso.dart';

void main() {
  late RepositorioDeServiciosFalso repositorio;
  late ProviderContainer contenedor;

  setUp(() {
    repositorio = RepositorioDeServiciosFalso();
    contenedor = ProviderContainer(
      overrides: [servicioRepositoryProvider.overrideWithValue(repositorio)],
    );
    addTearDown(contenedor.dispose);
  });

  ListaServiciosEstado estadoActual() =>
      contenedor.read(listaServiciosViewModelProvider);

  /// Se suscribe al listado y lo mantiene vivo.
  ///
  /// El provider es auto-dispose: sin un oyente se destruye enseguida y cada
  /// lectura volvería a empezar en Cargando. La pantalla hace lo mismo.
  void suscribirse() {
    contenedor.listen(
      listaServiciosViewModelProvider,
      (ListaServiciosEstado? anterior, ListaServiciosEstado siguiente) {},
    );
  }

  /// Espera a que llegue la primera emisión del flujo.
  Future<void> esperarEmision() async {
    for (int i = 0; i < 50 && estadoActual() is ListaCargando; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('empieza en Cargando', () {
    suscribirse();

    expect(estadoActual(), isA<ListaCargando>());
  });

  test('emite Vacio cuando no hay ningún servicio', () async {
    suscribirse();
    await esperarEmision();

    expect(estadoActual(), isA<ListaVacia>());
  });

  test('emite ConDatos con los servicios existentes', () async {
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
    await repositorio.crearServicio(nombre: 'Agua', unidad: UnidadMedida.m3);

    suscribirse();
    await esperarEmision();

    final ListaServiciosEstado estado = estadoActual();
    expect(estado, isA<ListaConDatos>());
    final ListaConDatos conDatos = estado as ListaConDatos;
    expect(conDatos.servicios, hasLength(2));
    expect(conDatos.errorParcial, isNull);
  });

  test('ConDatos expone solo lo que la fila necesita', () async {
    await repositorio.crearServicio(
      nombre: 'Gas',
      unidad: UnidadMedida.kg,
      etiquetaContrato: '12345',
    );

    suscribirse();
    await esperarEmision();

    final ListaConDatos conDatos = estadoActual() as ListaConDatos;
    expect(conDatos.servicios.single.nombre, 'Gas');
    expect(conDatos.servicios.single.simboloUnidad, 'kg');
    expect(conDatos.servicios.single.activo, isTrue);
    expect(conDatos.servicios.single.tieneEtiquetaContrato, isTrue);
  });

  test('se actualiza solo cuando alguien crea un servicio por fuera', () async {
    suscribirse();
    await esperarEmision();
    expect(estadoActual(), isA<ListaVacia>());

    // Nadie pide recargar: el ViewModel está suscrito al flujo de datos.
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
    for (int i = 0; i < 50 && estadoActual() is! ListaConDatos; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final ListaServiciosEstado estado = estadoActual();
    expect(
      estado,
      isA<ListaConDatos>(),
      reason: 'el listado debe reaccionar sin recargar a mano',
    );
    expect((estado as ListaConDatos).servicios.single.nombre, 'Luz');
  });

  test('se actualiza solo cuando un servicio cambia de estado', () async {
    final int id = (await repositorio.crearServicio(
      nombre: 'Luz',
      unidad: UnidadMedida.kwh,
    )).valorOpcional!.id!;

    suscribirse();
    await esperarEmision();
    expect((estadoActual() as ListaConDatos).servicios.single.activo, isTrue);

    await repositorio.desactivarServicio(id);
    for (int i = 0; i < 50; i++) {
      final ListaServiciosEstado estado = estadoActual();
      if (estado is ListaConDatos && !estado.servicios.single.activo) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    expect(
      (estadoActual() as ListaConDatos).servicios.single.activo,
      isFalse,
      reason: 'desactivar debe reflejarse sin recargar a mano',
    );
  });

  test('emite ConError cuando el repositorio falla', () async {
    final RepositorioDeServiciosFalso queFalla = RepositorioDeServiciosFalso(
      motivoDeFallo: MotivoDeFallo.almacenamiento,
    );
    final ProviderContainer otro = ProviderContainer(
      overrides: [servicioRepositoryProvider.overrideWithValue(queFalla)],
    );
    addTearDown(otro.dispose);
    otro.listen(
      listaServiciosViewModelProvider,
      (ListaServiciosEstado? anterior, ListaServiciosEstado siguiente) {},
    );

    for (
      int i = 0;
      i < 50 && otro.read(listaServiciosViewModelProvider) is ListaCargando;
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final ListaServiciosEstado estado = otro.read(
      listaServiciosViewModelProvider,
    );
    expect(estado, isA<ListaConError>());
    expect((estado as ListaConError).motivo, MotivoDeFallo.almacenamiento);
  });

  test('reintentar vuelve a suscribirse al flujo', () async {
    final RepositorioDeServiciosFalso queFalla = RepositorioDeServiciosFalso(
      motivoDeFallo: MotivoDeFallo.almacenamiento,
    );
    final ProviderContainer otro = ProviderContainer(
      overrides: [servicioRepositoryProvider.overrideWithValue(queFalla)],
    );
    addTearDown(otro.dispose);
    otro.listen(
      listaServiciosViewModelProvider,
      (ListaServiciosEstado? anterior, ListaServiciosEstado siguiente) {},
    );

    for (
      int i = 0;
      i < 50 && otro.read(listaServiciosViewModelProvider) is ListaCargando;
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(otro.read(listaServiciosViewModelProvider), isA<ListaConError>());

    otro.read(listaServiciosViewModelProvider.notifier).reintentar();

    for (
      int i = 0;
      i < 50 && otro.read(listaServiciosViewModelProvider) is ListaCargando;
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(otro.read(listaServiciosViewModelProvider), isA<ListaConError>());
  });
}
