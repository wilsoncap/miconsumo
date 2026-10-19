import 'package:flutter_test/flutter_test.dart';
import 'package:miconsumo/features/servicios/domain/value_objects/nombre_de_servicio.dart';

void main() {
  group('NombreDeServicio', () {
    test('recorta los espacios de los extremos', () {
      final NombreDeServicio nombre = NombreDeServicio('  Agua  ');

      expect(nombre.valor, 'Agua');
      expect(nombre.normalizado, 'agua');
    });

    test('rechaza un texto vacío', () {
      expect(() => NombreDeServicio(''), throwsArgumentError);
    });

    test('rechaza un texto con solo espacios', () {
      expect(() => NombreDeServicio('     '), throwsArgumentError);
    });

    test('rechaza un nombre que supera la longitud máxima', () {
      final String largo = 'a' * (NombreDeServicio.longitudMaxima + 1);

      expect(() => NombreDeServicio(largo), throwsArgumentError);
    });

    test('acepta un nombre exactamente en el límite', () {
      final String limite = 'a' * NombreDeServicio.longitudMaxima;

      expect(NombreDeServicio(limite).valor, limite);
    });

    test('normaliza mayúsculas y acentos', () {
      expect(NombreDeServicio('Electricidád').normalizado, 'electricidad');
      expect(NombreDeServicio('AGUA').normalizado, 'agua');
      expect(NombreDeServicio('Gas Natural').normalizado, 'gas natural');
    });

    test('no confunde la eñe con la ene', () {
      expect(NombreDeServicio('Año').normalizado, 'año');
      expect(
        NombreDeServicio('Año') == NombreDeServicio('Ano'),
        isFalse,
        reason: 'la eñe es una letra distinta en español',
      );
    });

    test('colapsa los espacios internos', () {
      expect(NombreDeServicio('Agua    potable').normalizado, 'agua potable');
    });

    test('no deja espacios al final tras colapsar', () {
      expect(NombreDeServicio('Agua   ').normalizado, 'agua');
    });

    test('dos nombres son iguales si su forma normalizada coincide', () {
      expect(NombreDeServicio('  AGUA  ') == NombreDeServicio('agua'), isTrue);
      expect(
        NombreDeServicio('agua').hashCode,
        NombreDeServicio('AGUA').hashCode,
      );
    });

    test('dos nombres distintos no son iguales', () {
      expect(NombreDeServicio('agua') == NombreDeServicio('luz'), isFalse);
    });

    test('la normalización es una función pura y reutilizable', () {
      expect(NombreDeServicio.normalizar('  Óptimo  '), 'optimo');
      expect(NombreDeServicio.normalizar(''), '');
    });
  });
}
