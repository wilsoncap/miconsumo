import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import 'miniatura_foto.dart';

class FotoViewerPage extends ConsumerWidget {
  const FotoViewerPage({super.key, required this.rutaRelativa});

  final String? rutaRelativa;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final archivo = rutaRelativa == null
        ? const AsyncValue<File?>.data(null)
        : ref.watch(fotoArchivoProvider(rutaRelativa!));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.fotoDelMedidor),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(l10n.cerrar),
          ),
        ],
      ),
      body: Center(
        child: archivo.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) =>
              _FotoNoDisponible(mensaje: l10n.fotoNoDisponible),
          data: (file) => file == null
              ? _FotoNoDisponible(mensaje: l10n.fotoNoDisponible)
              : InteractiveViewer(
                  maxScale: 4,
                  child: Image.file(file, fit: BoxFit.contain),
                ),
        ),
      ),
    );
  }
}

class _FotoNoDisponible extends StatelessWidget {
  const _FotoNoDisponible({required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.broken_image_outlined,
            size: 56,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
