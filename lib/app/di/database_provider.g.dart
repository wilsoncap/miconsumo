// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Base de datos local de la aplicación.
///
/// Se sobrescribe en `main.dart` con la base real —que necesita resolver la ruta
/// del archivo de forma asíncrona— y en las pruebas con una base en memoria.
/// Si nadie la sobrescribe, falla de forma explícita en lugar de crear una base
/// en un sitio inesperado.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Base de datos local de la aplicación.
///
/// Se sobrescribe en `main.dart` con la base real —que necesita resolver la ruta
/// del archivo de forma asíncrona— y en las pruebas con una base en memoria.
/// Si nadie la sobrescribe, falla de forma explícita en lugar de crear una base
/// en un sitio inesperado.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Base de datos local de la aplicación.
  ///
  /// Se sobrescribe en `main.dart` con la base real —que necesita resolver la ruta
  /// del archivo de forma asíncrona— y en las pruebas con una base en memoria.
  /// Si nadie la sobrescribe, falla de forma explícita en lugar de crear una base
  /// en un sitio inesperado.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'bdcf1f7c8f4ef47c9dbd8914b92fc94e9eba7624';
