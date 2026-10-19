import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/core/error/resultado.dart';
import 'package:miconsumo/features/servicios/data/local/app_database.dart';
import 'package:miconsumo/features/servicios/data/repositories/servicio_repository_impl.dart';
import 'package:miconsumo/features/servicios/domain/entities/tipo_de_servicio.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/unidad_medida.dart';

void main() {
  late AppDatabase base;
  late ServicioRepositoryImpl repositorio;

  final DateTime ahora = DateTime(2026, 10, 18, 12);

  setUp(() {
    base = AppDatabase(NativeDatabase.memory());
    repositorio = ServicioRepositoryImpl(base.serviciosDao, reloj: () => ahora);
  });

  tearDown(() async {
    await base.close();
  });

  group('crearServicio', () {
    test('crea un servicio y devuelve la entidad con identificador', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);

      expect(resultado.esExito, isTrue);
      final TipoDeServicio servicio = resultado.valorOpcional!;
      expect(servicio.id, isNotNull);
      expect(servicio.nombre.valor, 'Luz');
      expect(servicio.nombre.normalizado, 'luz');
      expect(servicio.unidad, UnidadMedida.kwh);
      expect(servicio.activo, isTrue);
      expect(servicio.etiquetaContrato, isNull);
      expect(servicio.creadoEn, ahora);
      expect(servicio.actualizadoEn, ahora);
    });

    test('rechaza un nombre vacío', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(nombre: '   ', unidad: UnidadMedida.m3);

      expect(resultado.motivoOpcional, MotivoDeFallo.nombreVacio);
    });

    test('rechaza un nombre demasiado largo', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(nombre: 'a' * 200, unidad: UnidadMedida.m3);

      expect(resultado.motivoOpcional, MotivoDeFallo.nombreDemasiadoLargo);
    });

    test('rechaza un duplicado sin distinguir mayúsculas ni acentos', () async {
      await repositorio.crearServicio(nombre: 'Agua', unidad: UnidadMedida.m3);

      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(nombre: 'agua', unidad: UnidadMedida.m3);

      expect(resultado.motivoOpcional, MotivoDeFallo.nombreDuplicado);
    });

    test('permite el mismo nombre en servicios distintos', () async {
      await repositorio.crearServicio(nombre: 'Agua', unidad: UnidadMedida.m3);

      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);

      expect(resultado.esExito, isTrue);
    });

    test('guarda la etiqueta de contrato cuando se indica', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(
            nombre: 'Gas',
            unidad: UnidadMedida.kg,
            etiquetaContrato: '12345-2026',
          );

      expect(resultado.valorOpcional!.etiquetaContrato, '12345-2026');
    });

    test('guarda la etiqueta vacía como ausente', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(
            nombre: 'Gas',
            unidad: UnidadMedida.kg,
            etiquetaContrato: '   ',
          );

      expect(resultado.valorOpcional!.etiquetaContrato, isNull);
    });

    test('recorta la etiqueta de contrato', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .crearServicio(
            nombre: 'Gas',
            unidad: UnidadMedida.kg,
            etiquetaContrato: '  12345  ',
          );

      expect(resultado.valorOpcional!.etiquetaContrato, '12345');
    });
  });

  group('observarServicios', () {
    test('emite una lista vacía cuando no hay servicios', () async {
      final Resultado<List<TipoDeServicio>> resultado = await repositorio
          .observarServicios()
          .first;

      expect(resultado.esExito, isTrue);
      expect(resultado.valorOpcional, isEmpty);
    });

    test('emite los servicios en orden estable por nombre', () async {
      await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
      await repositorio.crearServicio(nombre: 'agua', unidad: UnidadMedida.m3);
      await repositorio.crearServicio(nombre: 'Gas', unidad: UnidadMedida.kg);

      final List<TipoDeServicio> primera =
          (await repositorio.observarServicios().first).valorOpcional!;
      final List<TipoDeServicio> segunda =
          (await repositorio.observarServicios().first).valorOpcional!;

      expect(
        primera.map((TipoDeServicio s) => s.nombre.normalizado).toList(),
        <String>['agua', 'gas', 'luz'],
      );
      expect(
        primera.map((TipoDeServicio s) => s.id).toList(),
        segunda.map((TipoDeServicio s) => s.id).toList(),
        reason: 'el orden debe ser estable entre emisiones',
      );
    });

    test('vuelve a emitir cuando los datos cambian', () async {
      final List<Resultado<List<TipoDeServicio>>> emisiones =
          <Resultado<List<TipoDeServicio>>>[];

      // La suscripción NO se cancela a propósito: cancelar un flujo de Drift se
      // queda colgado en este entorno de pruebas. La base se cierra en tearDown,
      // y en la aplicación la cancelación se hace sin esperarla.
      repositorio.observarServicios().listen(emisiones.add);

      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(
        emisiones,
        hasLength(1),
        reason: 'el flujo debe emitir el estado actual al suscribirse',
      );
      expect(emisiones.single.valorOpcional, isEmpty);

      await repositorio.crearServicio(nombre: 'Luz', unidad: UnidadMedida.kwh);
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(
        emisiones,
        hasLength(2),
        reason: 'crear un servicio debe volver a emitir el listado',
      );
      expect(emisiones.last.valorOpcional, hasLength(1));
    });
  });

  group('obtenerServicio', () {
    test('devuelve el servicio por su identificador', () async {
      final TipoDeServicio creado = (await repositorio.crearServicio(
        nombre: 'Luz',
        unidad: UnidadMedida.kwh,
      )).valorOpcional!;

      final Resultado<TipoDeServicio> resultado = await repositorio
          .obtenerServicio(creado.id!);

      expect(resultado.valorOpcional!.nombre.valor, 'Luz');
    });

    test('falla cuando el identificador no existe', () async {
      final Resultado<TipoDeServicio> resultado = await repositorio
          .obtenerServicio(999);

      expect(resultado.motivoOpcional, MotivoDeFallo.servicioNoEncontrado);
    });
  });

  group('actualizarServicio', () {
    test('cambia el nombre y la etiqueta sin tocar la unidad', () async {
      final TipoDeServicio creado = (await repositorio.crearServicio(
        nombre: 'Luz',
        unidad: UnidadMedida.kwh,
      )).valorOpcional!;

      final Resultado<TipoDeServicio> resultado = await repositorio
          .actualizarServicio(
            id: creado.id!,
            nombre: 'Luz principal',
            etiquetaContrato: '999',
          );

      final TipoDeServicio actualizado = resultado.valorOpcional!;
      expect(actualizado.nombre.valor, 'Luz principal');
      expect(actualizado.etiquetaContrato, '999');
      expect(actualizado.unidad, UnidadMedida.kwh);
    });

    test('permite conservar el mismo nombre del propio servicio', () async {
      final TipoDeServicio creado = (await repositorio.crearServicio(
        nombre: 'Luz',
        unidad: UnidadMedida.kwh,
      )).valorOpcional!;

      final Resultado<TipoDeServicio> resultado = await repositorio
          .actualizarServicio(id: creado.id!, nombre: 'Luz');

      expect(resultado.esExito, isTrue);
    });

    test('rechaza el nombre de otro servicio', () async {
      await repositorio.crearServicio(nombre: 'Agua', unidad: UnidadMedida.m3);
      final TipoDeServicio luz = (await repositorio.crearServicio(
        nombre: 'Luz',
        unidad: UnidadMedida.kwh,
      )).valorOpcional!;

      final Resultado<TipoDeServicio> resultado = await repositorio
          .actualizarServicio(id: luz.id!, nombre: 'agua');

      expect(resultado.motivoOpcional, MotivoDeFallo.nombreDuplicado);
    });
  });

  group('cambiarUnidad', () {
    test('cambia la unidad cuando no hay mediciones', () async {
      final TipoDeServicio creado = (await repositorio.crearServicio(
        nombre: 'Gas',
        unidad: UnidadMedida.m3,
      )).valorOpcional!;

      final Resultado<TipoDeServicio> resultado = await repositorio
          .cambiarUnidad(id: creado.id!, unidad: UnidadMedida.kg);

      expect(resultado.valorOpcional!.unidad, UnidadMedida.kg);
    });
  });
}
