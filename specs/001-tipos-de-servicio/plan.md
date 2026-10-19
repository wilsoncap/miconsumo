# Implementation Plan: Tipos de Servicio

**Branch**: `001-tipos-de-servicio` | **Date**: 2026-10-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-tipos-de-servicio/spec.md`

## Summary

Catálogo local de tipos de servicio (luz, agua, gas) con su unidad de medida y una etiqueta de
contrato opcional. Como es la primera funcionalidad del proyecto, además establece la arquitectura
base: MVVM con capa de dominio aislada, sistema de diseño con tokens y persistencia local con Drift.
No se añade ningún permiso de red ni SDK de terceros.

## Technical Context

**Language/Version**: Dart (SDK `^3.13.2`) sobre Flutter 3.47.2 stable

**Primary Dependencies**: `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator` (estado e
inyección de dependencias), `drift` + `drift_dev` (persistencia),
`go_router` (navegación), `intl` + `flutter_localizations` (textos y formato), `freezed` +
`freezed_annotation` (modelos inmutables), `path_provider` + `path` (ubicación de la base de datos),
`build_runner` (generación de código)

**Storage**: SQLite local mediante Drift, en el directorio privado de la aplicación. Esta
funcionalidad no almacena archivos: las fotografías de mediciones llegarán en una funcionalidad
posterior y usarán el mismo directorio.

**Testing**: `flutter_test`. Pruebas unitarias de dominio (funciones puras) y de ViewModel (sin
`WidgetTester`), pruebas de widget de las pantallas y de cada componente de presentación, pruebas
golden del sistema de diseño y de los componentes, y pruebas de repositorio contra una base de datos
Drift en memoria (`NativeDatabase.memory()`).

**Target Platform**: Android. iOS queda fuera de alcance hasta que exista un entorno de compilación
macOS (constitución, sección Stack).

**Project Type**: mobile-app — proyecto Flutter único.

**Performance Goals**: la lista de servicios DEBE construirse en un solo frame para hasta 50
servicios; arranque en frío por debajo de 2 segundos; ninguna operación de escritura DEBE bloquear el
hilo de interfaz.

**Constraints**: funcionamiento 100% sin conexión; sin permiso `INTERNET`; sin SDKs de terceros con
acceso a red; ningún dato del hogar sale del dispositivo; locale `es_CO`; contraste AA y área táctil
mínima de 48 dp.

**Scale/Scope**: un hogar por instalación; del orden de 3 a 10 servicios; el historial de mediciones y
los conceptos de facturación pertenecen a funcionalidades posteriores.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Gates derivados de la constitución v2.3.0:

| Principio | Gate | Estado |
|---|---|---|
| I — Offline-First | La funcionalidad opera sin red y no introduce permisos de red | PASS |
| II — Integridad de la Evidencia | El sistema NUNCA ofrece eliminar un servicio; solo desactivar y reactivar (FR-015) | PASS |
| III — Precisión Numérica | Esta funcionalidad no maneja montos ni consumos; solo nombres, unidades y una etiqueta. Se aplicará al introducir conceptos de facturación | N/A |
| IV — Dominio Puro | La normalización y unicidad del nombre, y la regla de unidad inmutable, son funciones puras en `domain/` | PASS |
| V — Puertas de Calidad | Plan de pruebas cubre dominio, ViewModel, vistas y goldens; `dart format`, `flutter analyze`, `flutter test` | PASS |
| VI — Sin Publicidad ni Rastreo | No se añade ningún SDK de terceros con red | PASS |
| VII — Vigencia Temporal | Esta funcionalidad no introduce valores con vigencia temporal. Se aplicará a los conceptos de facturación | N/A |
| Arquitectura — MVVM | `presentation/{view,view/widgets,viewmodel,state}`; `domain/` en Dart puro; DI con Riverpod | PASS |
| Arquitectura — Dominio aislado | `domain/` no importa Flutter, Drift ni go_router; se verifica con una prueba | PASS |
| Estándares de UI | Material 3, tokens vía `ThemeExtension`, estados `sealed`, ARB con locale `es_CO`, accesibilidad AA, y pantallas que solo componen componentes | PASS |
| Privacidad y Cumplimiento | La etiqueta de contrato es opcional y local; no se transmite (FR-014) | PASS |

**Resultado**: sin violaciones. Dos compuertas son `N/A` por quedar fuera del alcance de esta
funcionalidad; no se requiere la sección de seguimiento de complejidad.

**Post-design re-check**: se repite tras la fase 1; ver el cierre de este documento.

## Project Structure

### Documentation (this feature)

```text
specs/001-tipos-de-servicio/
├── plan.md              # Este archivo
├── research.md          # Salida de la fase 0
├── data-model.md        # Salida de la fase 1
├── quickstart.md        # Salida de la fase 1
├── contracts/           # Salida de la fase 1
├── checklists/
│   └── requirements.md
└── tasks.md             # Salida de /speckit.tasks (no lo crea /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── main.dart                     # Arranque: ProviderScope + App
├── app/
│   ├── app.dart                  # MaterialApp.router, tema y localización
│   ├── router/                   # Configuración centralizada de go_router
│   └── di/                       # Providers globales (base de datos)
├── core/
│   ├── error/                    # Tipos de fallo y resultado
│   ├── ui/
│   │   ├── theme/                # ColorScheme, tokens vía ThemeExtension
│   │   └── widgets/              # Componentes reutilizables
│   └── utils/                    # Normalización de texto, validadores
└── features/
    └── servicios/
        ├── domain/               # Dart puro
        │   ├── entities/         # TipoDeServicio
        │   ├── value_objects/    # UnidadMedida, NombreDeServicio
        │   ├── repositories/     # Contratos abstractos
        │   └── usecases/         # Normalización y validaciones
        ├── data/
        │   ├── local/            # Tablas y DAOs de Drift
        │   ├── mappers/          # Fila de Drift ↔ entidad de dominio
        │   └── repositories/     # Implementación de los contratos
        └── presentation/
            ├── view/             # Pantallas: solo componen y leen el proveedor
            │   └── widgets/      # Componentes de la funcionalidad (reciben datos por parámetro)
            ├── viewmodel/        # Notifiers de Riverpod (ViewModel)
            └── state/            # Estados de UI (sealed)

test/
├── core/
│   └── ui/theme/                 # Pruebas golden del sistema de diseño
└── features/servicios/
    ├── domain/                   # Funciones puras y objetos de valor
    ├── data/                     # Repositorios contra Drift en memoria
    └── presentation/
        ├── view/                 # Pruebas de widget de las pantallas
        │   └── widgets/          # Pruebas y goldens de cada componente
        └── viewmodel/            # Pruebas de ViewModel
```

**Structure Decision**: se adopta la estructura por funcionalidad con capa de dominio propia que fija
la constitución (v2.3.0). El código compartido vive en `lib/core/`, el arranque en `lib/app/` y la
funcionalidad en `lib/features/servicios/`, dividida en `domain/`, `data/` y
`presentation/{view,viewmodel,state}`. Dentro de `view/`, las pantallas **solo componen**: cada parte
visual vive en `view/widgets/` como componente que recibe sus datos y acciones por parámetro, según los
Estándares de UI. Se descarta la organización por capas a nivel de proyecto
(`lib/models`, `lib/services`, `lib/widgets`) porque dificulta mantener aislado el dominio y hace que
las funcionalidades se acoplen entre sí. La carpeta de pruebas refleja la misma forma, de modo que la
ubicación de cada prueba sea predecible.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No hay violaciones. Esta sección no aplica.

## Post-Design Constitution Re-Check

*Re-evaluación obligatoria tras la fase 1, con el modelo de datos y los contratos ya definidos.*

| Principio | Verificación contra el diseño | Estado |
|---|---|---|
| I — Offline-First | El modelo de datos es enteramente local; no aparece ningún cliente de red ni permiso `INTERNET` | PASS |
| II — Integridad de la Evidencia | El contrato del repositorio no expone ninguna operación de borrado; solo activar y desactivar | PASS |
| III — Precisión Numérica | El modelo no contiene ningún campo monetario ni de consumo. Se aplicará en la funcionalidad de conceptos de facturación | N/A |
| IV — Dominio Puro | La normalización de nombres y la regla de unidad inmutable quedan como funciones puras con sus casos límite en `data-model.md` | PASS |
| V — Puertas de Calidad | `quickstart.md` enumera los niveles de prueba exigidos, incluida la prueba de arquitectura del dominio aislado | PASS |
| VI — Sin Publicidad ni Rastreo | El diseño no incorpora ningún SDK de terceros | PASS |
| VII — Vigencia Temporal | El modelo no contiene valores con vigencia temporal | N/A |
| Arquitectura — MVVM | Los contratos de ViewModel fijan estados `sealed` e intenciones, sin que la View acceda al dominio ni el ViewModel a `go_router` | PASS |
| Arquitectura — Dominio aislado | Los contratos del repositorio viven en `domain/repositories/` y no mencionan Drift | PASS |
| Estándares de UI | El contrato de estado distingue `Vacio` de `ConDatos` con lista vacía, y expone modelos de presentación en lugar de entidades. Los componentes reciben datos y acciones por parámetro, y solo la pantalla lee proveedores | PASS |
| Privacidad y Cumplimiento | `etiquetaContrato` queda explícitamente fuera de cualquier salida del dispositivo | PASS |

**Resultado**: sin violaciones tras el diseño. El plan queda aprobado para `/speckit.tasks`.
