// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servicio_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repositorio de tipos de servicio.
///
/// Es el punto por el que los ViewModel acceden a los datos: no conocen Drift ni
/// la forma de la base de datos (contrato de MVVM de la constitución).

@ProviderFor(servicioRepository)
final servicioRepositoryProvider = ServicioRepositoryProvider._();

/// Repositorio de tipos de servicio.
///
/// Es el punto por el que los ViewModel acceden a los datos: no conocen Drift ni
/// la forma de la base de datos (contrato de MVVM de la constitución).

final class ServicioRepositoryProvider
    extends
        $FunctionalProvider<
          ServicioRepository,
          ServicioRepository,
          ServicioRepository
        >
    with $Provider<ServicioRepository> {
  /// Repositorio de tipos de servicio.
  ///
  /// Es el punto por el que los ViewModel acceden a los datos: no conocen Drift ni
  /// la forma de la base de datos (contrato de MVVM de la constitución).
  ServicioRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicioRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicioRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServicioRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServicioRepository create(Ref ref) {
    return servicioRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServicioRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServicioRepository>(value),
    );
  }
}

String _$servicioRepositoryHash() =>
    r'b47ca5fcf28b3060beffe6e062d534827144d5be';
