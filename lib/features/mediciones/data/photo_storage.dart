import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract interface class PhotoStorage {
  /// Copia la foto a almacenamiento privado y devuelve su ruta relativa.
  Future<String> guardarDesde(String rutaOrigen);

  Future<File?> resolver(String rutaRelativa);

  Future<bool> existe(String rutaRelativa);
}

class AlmacenamientoFotosLocal implements PhotoStorage {
  AlmacenamientoFotosLocal({Future<Directory> Function()? directorioBase})
    : _directorioBase = directorioBase ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directorioBase;

  static const String carpeta = 'fotos_medidor';

  Future<Directory> _asegurarCarpeta() async {
    final base = await _directorioBase();
    final carpetaFotos = Directory(p.join(base.path, carpeta));
    if (!await carpetaFotos.exists()) {
      await carpetaFotos.create(recursive: true);
    }
    return carpetaFotos;
  }

  @override
  Future<String> guardarDesde(String rutaOrigen) async {
    final origen = File(rutaOrigen);
    if (!await origen.exists()) {
      throw FileSystemException('La foto de origen no existe', rutaOrigen);
    }

    final carpetaFotos = await _asegurarCarpeta();
    final extension = p.extension(rutaOrigen).toLowerCase();
    final sello = DateTime.now().microsecondsSinceEpoch;
    var nombre = 'medidor_$sello$extension';
    var destino = File(p.join(carpetaFotos.path, nombre));
    var intento = 1;
    while (await destino.exists()) {
      nombre = 'medidor_${sello}_$intento$extension';
      destino = File(p.join(carpetaFotos.path, nombre));
      intento++;
    }

    await origen.copy(destino.path);
    return p.join(carpeta, nombre);
  }

  @override
  Future<File?> resolver(String rutaRelativa) async {
    final base = await _directorioBase();
    final archivo = File(p.join(base.path, rutaRelativa));
    return await archivo.exists() ? archivo : null;
  }

  @override
  Future<bool> existe(String rutaRelativa) async {
    return (await resolver(rutaRelativa)) != null;
  }
}
