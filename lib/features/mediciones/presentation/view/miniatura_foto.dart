import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../l10n/app_localizations.dart';

final fotoArchivoProvider = FutureProvider.family<File?, String>(
  (ref, rutaRelativa) => ref.watch(photoStorageProvider).resolver(rutaRelativa),
);

class MiniaturaFoto extends ConsumerWidget {
  const MiniaturaFoto({
    super.key,
    required this.rutaRelativa,
    required this.onTap,
    this.size = 48,
  });

  final String rutaRelativa;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final archivo = ref.watch(fotoArchivoProvider(rutaRelativa));
    return Semantics(
      button: true,
      label: l10n.verFoto,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: archivo.when(
            loading: () => SizedBox(
              width: size,
              height: size,
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => _NoDisponible(size: size),
            data: (file) => file == null
                ? _NoDisponible(size: size)
                : Image.file(
                    file,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}

class _NoDisponible extends StatelessWidget {
  const _NoDisponible({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      color: colores.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        size: size * 0.5,
        color: colores.onSurfaceVariant,
      ),
    );
  }
}
