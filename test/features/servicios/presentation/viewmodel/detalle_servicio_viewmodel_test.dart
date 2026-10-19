import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_provider.dart';
import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';
import 'package:miconsumo/features/servicios/presentation/state/detalle_servicio_estado.dart';
import 'package:miconsumo/features/servicios/presentation/viewmodel/detalle_servicio_viewmodel.dart';

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

  DetalleServicioViewModel viewModel() =>
      contenedor.read(detalleServicioViewModelProvider.notifier);

  DetalleServicioEstado estado() =>
      contenedor.read(detalleServicioViewModelProvider);

  test('empieza en Cargando', () {
    expect(estado(), isA<DetalleCargando>());
  });

  test('iniciarNuevo prepara un formulario vacío', () {
    viewModel().iniciarNuevo();

    final DetalleServicioEstado actual = estado();
    expect(actual, isA<DetalleNuevo>());
    final DetalleNuevo nuevo = actual as DetalleNuevo;
    expect(nuevo.formulario.nombre, '');
    expect(nuevo.formulario.unidad, isNull);
    expect(nuevo.guardando, isFalse);
  });

  test('guardar sin nombre marca el error junto al campo', () async {
    viewModel().iniciarNuevo();
    viewModel().cambiarUnidad(UnidadMedida.kwh);

    await viewModel().guardar();

    expect(
      (estado() as DetalleNuevo).formulario.errorNombre,
      MotivoDeFallo.nombreVacio,
    );
  });

  test('guardar sin unidad marca el error junto al campo', () async {
    viewModel().iniciarNuevo();
    viewModel().cambiarNombre('Luz');

    await viewModel().guardar();

    expect(
      (estado() as DetalleNuevo).formulario.errorUnidad,
      MotivoDeFallo.unidadRequerida,
    );
  });

  test('guardar con datos válidos emite Guardado', () async {
    viewModel().iniciarNuevo();
    viewModel().cambiarNombre('Luz');
    viewModel().cambiarUnidad(UnidadMedida.kwh);

    await viewModel().guardar();

    expect(estado(), isA<DetalleGuardado>());
    expect(repositorio.servicios, hasLength(1));
    expect(repositorio.servicios.single.nombre.valor, 'Luz');
  });

  test('guardar un nombre duplicado lo marca junto al campo', () async {
    await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
    viewModel().iniciarNuevo();
    viewModel().cambiarNombre('luz');
    viewModel().cambiarUnidad(UnidadMedida.kwh);

    await viewModel().guardar();

    expect(
      (estado() as DetalleNuevo).formulario.errorNombre,
      MotivoDeFallo.nombreDuplicado,
    );
  });

  test('cambiarNombre limpia el error anterior', () async {
    viewModel().iniciarNuevo();
    await viewModel().guardar();
    expect(
      (estado() as DetalleNuevo).formulario.errorNombre,
      MotivoDeFallo.nombreVacio,
    );

    viewModel().cambiarNombre('L');

    expect((estado() as DetalleNuevo).formulario.errorNombre, isNull);
  });

  test('cargar vuelca el servicio en el formulario', () async {
    final TipoDeServicio creado = (await repositorio.crearServicio(
      nombre: 'Agua',
      unidad: UnidadMedida.m3,
      etiquetaContrato: '12345',
    )).valorOpcional!;

    await viewModel().cargar(creado.id!);

    final DetalleServicioEstado actual = estado();
    expect(actual, isA<DetalleExistente>());
    final DetalleExistente existente = actual as DetalleExistente;
    expect(existente.id, creado.id);
    expect(existente.formulario.nombre, 'Agua');
    expect(existente.formulario.unidad, UnidadMedida.m3);
    expect(existente.formulario.etiquetaContrato, '12345');
    expect(existente.unidadBloqueada, isFalse);
  });

  test('cargar un identificador inexistente emite error', () async {
    await viewModel().cargar(999);

    expect(estado(), isA<DetalleConError>());
    expect(
      (estado() as DetalleConError).motivo,
      MotivoDeFallo.servicioNoEncontrado,
    );
  });

  test('editar actualiza el servicio en lugar de crear otro', () async {
    final TipoDeServicio creado = (await repositorio.crearServicio(
      nombre: 'Agua',
      unidad: UnidadMedida.m3,
    )).valorOpcional!;
    await viewModel().cargar(creado.id!);

    viewModel().cambiarNombre('Agua potable');
    await viewModel().guardar();

    expect(estado(), isA<DetalleGuardado>());
    expect(repositorio.servicios, hasLength(1));
    expect(repositorio.servicios.single.nombre.valor, 'Agua potable');
    expect(repositorio.servicios.single.unidad, UnidadMedida.m3);
  });

  test('emite error general cuando el repositorio falla al guardar', () async {
    final RepositorioDeServiciosFalso queFalla = RepositorioDeServiciosFalso(
      motivoDeFallo: MotivoDeFallo.almacenamiento,
    );
    final ProviderContainer otro = ProviderContainer(
      overrides: [servicioRepositoryProvider.overrideWithValue(queFalla)],
    );
    addTearDown(otro.dispose);

    final DetalleServicioViewModel viewModelDeOtro = otro.read(
      detalleServicioViewModelProvider.notifier,
    );
    viewModelDeOtro.iniciarNuevo();
    viewModelDeOtro.cambiarNombre('Luz');
    viewModelDeOtro.cambiarUnidad(UnidadMedida.kwh);

    await viewModelDeOtro.guardar();

    expect(otro.read(detalleServicioViewModelProvider), isA<DetalleConError>());
  });
}
