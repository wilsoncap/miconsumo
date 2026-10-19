// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_servicios_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel del listado de servicios.
///
/// Se SUSCRIBE al flujo de datos del repositorio en lugar de pedir una foto una
/// sola vez. Así el listado se actualiza solo cuando algo cambia, sin importar
/// quién lo haya cambiado ni desde qué pantalla.
///
/// NO importa Flutter: usa `package:riverpod_annotation` y `package:riverpod`,
/// nunca `flutter_riverpod`. Por eso se puede probar sin `WidgetTester`.

@ProviderFor(ListaServiciosViewModel)
final listaServiciosViewModelProvider = ListaServiciosViewModelProvider._();

/// ViewModel del listado de servicios.
///
/// Se SUSCRIBE al flujo de datos del repositorio en lugar de pedir una foto una
/// sola vez. Así el listado se actualiza solo cuando algo cambia, sin importar
/// quién lo haya cambiado ni desde qué pantalla.
///
/// NO importa Flutter: usa `package:riverpod_annotation` y `package:riverpod`,
/// nunca `flutter_riverpod`. Por eso se puede probar sin `WidgetTester`.
final class ListaServiciosViewModelProvider
    extends $NotifierProvider<ListaServiciosViewModel, ListaServiciosEstado> {
  /// ViewModel del listado de servicios.
  ///
  /// Se SUSCRIBE al flujo de datos del repositorio en lugar de pedir una foto una
  /// sola vez. Así el listado se actualiza solo cuando algo cambia, sin importar
  /// quién lo haya cambiado ni desde qué pantalla.
  ///
  /// NO importa Flutter: usa `package:riverpod_annotation` y `package:riverpod`,
  /// nunca `flutter_riverpod`. Por eso se puede probar sin `WidgetTester`.
  ListaServiciosViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listaServiciosViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listaServiciosViewModelHash();

  @$internal
  @override
  ListaServiciosViewModel create() => ListaServiciosViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListaServiciosEstado value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListaServiciosEstado>(value),
    );
  }
}

String _$listaServiciosViewModelHash() =>
    r'4a2c9af670b8a65b666ad278523db132c0dbcd45';

/// ViewModel del listado de servicios.
///
/// Se SUSCRIBE al flujo de datos del repositorio en lugar de pedir una foto una
/// sola vez. Así el listado se actualiza solo cuando algo cambia, sin importar
/// quién lo haya cambiado ni desde qué pantalla.
///
/// NO importa Flutter: usa `package:riverpod_annotation` y `package:riverpod`,
/// nunca `flutter_riverpod`. Por eso se puede probar sin `WidgetTester`.

abstract class _$ListaServiciosViewModel
    extends $Notifier<ListaServiciosEstado> {
  ListaServiciosEstado build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ListaServiciosEstado, ListaServiciosEstado>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ListaServiciosEstado, ListaServiciosEstado>,
              ListaServiciosEstado,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
