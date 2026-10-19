// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalle_servicio_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel de la pantalla de detalle y creación de un servicio.
///
/// NO importa Flutter y NO navega: cuando el guardado sale bien emite
/// [DetalleGuardado] y es la View quien decide a dónde ir.

@ProviderFor(DetalleServicioViewModel)
final detalleServicioViewModelProvider = DetalleServicioViewModelProvider._();

/// ViewModel de la pantalla de detalle y creación de un servicio.
///
/// NO importa Flutter y NO navega: cuando el guardado sale bien emite
/// [DetalleGuardado] y es la View quien decide a dónde ir.
final class DetalleServicioViewModelProvider
    extends $NotifierProvider<DetalleServicioViewModel, DetalleServicioEstado> {
  /// ViewModel de la pantalla de detalle y creación de un servicio.
  ///
  /// NO importa Flutter y NO navega: cuando el guardado sale bien emite
  /// [DetalleGuardado] y es la View quien decide a dónde ir.
  DetalleServicioViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detalleServicioViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$detalleServicioViewModelHash();

  @$internal
  @override
  DetalleServicioViewModel create() => DetalleServicioViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DetalleServicioEstado value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DetalleServicioEstado>(value),
    );
  }
}

String _$detalleServicioViewModelHash() =>
    r'696e27e60adb1f60609114d8d080dfd0c8869f41';

/// ViewModel de la pantalla de detalle y creación de un servicio.
///
/// NO importa Flutter y NO navega: cuando el guardado sale bien emite
/// [DetalleGuardado] y es la View quien decide a dónde ir.

abstract class _$DetalleServicioViewModel
    extends $Notifier<DetalleServicioEstado> {
  DetalleServicioEstado build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DetalleServicioEstado, DetalleServicioEstado>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DetalleServicioEstado, DetalleServicioEstado>,
              DetalleServicioEstado,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
