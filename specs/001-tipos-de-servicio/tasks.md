# Tasks: Tipos de Servicio

**Input**: Design documents from `/specs/001-tipos-de-servicio/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: **Incluidos, y no son opcionales.** Aunque la plantilla los marca como opcionales, el
Principio V de la constitución los exige: pruebas unitarias para toda regla de dominio y todo
ViewModel con lógica, pruebas de widget para las pantallas y los componentes, y goldens para el sistema
de diseño y los componentes. Por eso cada historia empieza por sus pruebas.

**Organization**: Tareas agrupadas por historia de usuario para que cada una sea implementable y
verificable por separado.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Puede ejecutarse en paralelo (archivos distintos, sin dependencias pendientes)
- **[Story]**: Historia de usuario a la que pertenece (US1, US2)
- Las rutas de archivo son exactas y relativas a la raíz del repositorio

## Path Conventions

Proyecto Flutter único. El código vive en `lib/` y las pruebas en `test/`, **replicando exactamente la
misma forma**. Ver la sección *Project Structure* de `plan.md`.

Recordatorio de la regla de composición (Estándares de UI, constitución v2.3.0): **las pantallas solo
componen**. Cada parte visual es un componente en `view/widgets/` que recibe sus datos y sus acciones
**por parámetro**, y **solo la pantalla de nivel superior lee proveedores**.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicialización del proyecto y de la infraestructura compartida

- [ ] T001 Crear la estructura de carpetas del plan: `lib/app/{router,di}`, `lib/core/{error,ui/theme,ui/widgets,utils}`, `lib/features/servicios/{domain/{entities,value_objects,repositories,usecases},data/{local,mappers,repositories},presentation/{view/widgets,viewmodel,state}}` y su reflejo exacto en `test/`
- [ ] T002 Añadir a `pubspec.yaml` las dependencias de `plan.md`: `flutter_riverpod`, `riverpod_annotation`, `drift`, `go_router`, `freezed_annotation`, `intl`, `flutter_localizations`, `path_provider`, `path`; y en `dev_dependencies`: `build_runner`, `riverpod_generator`, `drift_dev`, `freezed`, `riverpod_lint`. **NO añadir `sqlite3_flutter_libs`** (obsoleto desde `sqlite3` 3.x, que empaqueta SQLite por sí mismo) **ni `custom_lint`** (ya no lo usa `riverpod_lint`, y provoca un conflicto de versiones con `analyzer_plugin`). Ejecutar `flutter pub get` (requiere red: `freezed` y `riverpod_lint` no están en la caché local)
- [ ] T003 [P] Endurecer `analysis_options.yaml` con las reglas de R9: `require_trailing_commas`, `prefer_single_quotes`, `unawaited_futures`, `always_declare_return_types`, `avoid_dynamic_calls`, más reglas de estilo. Declarar el plugin `riverpod_lint` bajo la clave `plugins:` (NO con `custom_lint`), que es como se instala desde la versión 3.x
- [ ] T004 [P] Configurar la localización: crear `l10n.yaml` con `es_CO` como locale base, crear `lib/l10n/app_es_CO.arb` y activar `generate: true` en la sección `flutter` de `pubspec.yaml`
- [ ] T005 [P] Definir los tokens de diseño en `lib/core/ui/theme/app_tokens.dart` como `ThemeExtension` (espaciados, radios, duraciones, tipografía) y el tema en `lib/core/ui/theme/app_theme.dart` con `ColorScheme.fromSeed` para claro y oscuro
- [ ] T006 Ejecutar `dart run build_runner build --delete-conflicting-outputs` y verificar que el proyecto compila con `dart analyze` sin incidencias. La primera compilación descarga los binarios de SQLite desde las *releases* del paquete, así que requiere red; la aplicación en ejecución sigue funcionando sin conexión

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Infraestructura base que DEBE estar lista antes de cualquier historia de usuario

**⚠️ CRITICAL**: Ninguna historia de usuario puede empezar hasta completar esta fase

- [ ] T007 Crear el enum `UnidadMedida` con los valores `kWh`, `m3` y `kg` en `lib/features/servicios/domain/value_objects/unidad_medida.dart`. Dominio en Dart puro
- [ ] T008 [P] Crear el objeto de valor `NombreDeServicio` en `lib/features/servicios/domain/value_objects/nombre_de_servicio.dart` con las reglas de `data-model.md`: recorte de espacios, no vacío, normalización sin acentos y en minúsculas, y longitud máxima
- [ ] T009 [P] Crear el tipo `Resultado<T>` con las variantes `Exito` y `Fallo`, y el catálogo de fallos de `contracts/repositorio-servicios.md` (`NombreVacio`, `NombreDuplicado`, `UnidadRequerida`, `UnidadInmutable`, `ServicioNoEncontrado`, `Almacenamiento`) en `lib/core/error/`
- [ ] T010 [P] Crear la entidad `TipoDeServicio` con `freezed` en `lib/features/servicios/domain/entities/tipo_de_servicio.dart`, con los campos exactos de `data-model.md`: `id`, `nombre`, `nombreNormalizado`, `unidad`, `etiquetaContrato` (opcional), `activo`, `creadoEn`, `actualizadoEn`
- [ ] T011 [P] Crear la función pura `puedeCambiarUnidad(servicio, tieneMediciones)` en `lib/features/servicios/domain/usecases/puede_cambiar_unidad.dart`. Recibe el dato de mediciones como parámetro, nunca lo consulta (FR-006)
- [ ] T012 Crear el contrato `ServicioRepository` en `lib/features/servicios/domain/repositories/servicio_repository.dart` con las siete operaciones de `contracts/repositorio-servicios.md`. Sin operación de borrado (FR-015)
- [ ] T013 Definir la base de datos Drift en `lib/features/servicios/data/local/app_database.dart`: tabla `Servicios` con `schemaVersion = 1`, índice único sobre `nombreNormalizado` y `MigrationStrategy` con `onCreate`, `onUpgrade` y `beforeOpen`
- [ ] T014 Crear el DAO de servicios en `lib/features/servicios/data/local/servicios_dao.dart` con orden estable por nombre y sin operación de borrado
- [ ] T015 [P] Crear el mapper fila ↔ entidad en `lib/features/servicios/data/mappers/servicio_mapper.dart`
- [ ] T016 Implementar `ServicioRepositoryImpl` en `lib/features/servicios/data/repositories/servicio_repository_impl.dart`, traduciendo cada validación fallida al `Fallo` correspondiente
- [ ] T017 Exponer el provider de la base de datos en `lib/app/di/database_provider.dart`, resolviendo la ruta con `path_provider` y sustituible por una base en memoria en las pruebas
- [ ] T018 Configurar `go_router` en `lib/app/router/app_router.dart` con las rutas del listado y del detalle, declaradas de forma centralizada
- [ ] T019 Montar `MaterialApp.router` en `lib/app/app.dart` con el tema, los delegados de localización para `es_CO` y el router; montar `ProviderScope` en `lib/main.dart`; y **eliminar `test/widget_test.dart`**, que prueba el contador de la plantilla, importa `MyApp` y dejaría de compilar, rompiendo la puerta de calidad del Principio V
- [ ] T020 [P] Crear la prueba de arquitectura en `test/architecture/domain_purity_test.dart` que falle si algún archivo bajo `lib/features/*/domain/` importa `package:flutter`, `package:drift` o `package:go_router` (Principio de Arquitectura)

**Checkpoint**: la base está lista y las historias de usuario pueden empezar

---

## Phase 3: User Story 1 - Registrar un tipo de servicio con su unidad (Priority: P1) 🎯 MVP

**Goal**: el usuario puede crear servicios con nombre, unidad y etiqueta de contrato opcional, y
verlos listados con su unidad

**Independent Test**: crear un servicio y comprobar que aparece en la lista con su unidad, sin
necesidad de abrir el detalle (SC-006)

### Tests for User Story 1 ⚠️

> Escribir primero y verificar que fallan antes de implementar

- [ ] T021 [P] [US1] Pruebas de dominio en `test/features/servicios/domain/nombre_de_servicio_test.dart`: recorte de espacios, texto vacío, solo espacios, acentos y mayúsculas, longitud excesiva
- [ ] T022 [P] [US1] Pruebas de repositorio en `test/features/servicios/data/servicio_repository_impl_test.dart` contra `NativeDatabase.memory()`: alta correcta, orden estable del listado, rechazo de duplicados por nombre normalizado, y persistencia de la etiqueta de contrato vacía
- [ ] T023 [P] [US1] Pruebas de ViewModel en `test/features/servicios/presentation/viewmodel/detalle_servicio_viewmodel_test.dart`: transiciones `Nuevo` → `Guardado`, validación del nombre, `NombreDuplicado` y `UnidadRequerida` como valores dentro del estado
- [ ] T024 [P] [US1] Pruebas de ViewModel en `test/features/servicios/presentation/viewmodel/lista_servicios_viewmodel_test.dart`: `Cargando` → `Vacio` cuando no hay servicios, y `Cargando` → `ConDatos` cuando los hay
- [ ] T025 [P] [US1] Pruebas de widget de los componentes en `test/features/servicios/presentation/view/widgets/fila_de_servicio_test.dart` y `test/features/servicios/presentation/view/widgets/estado_vacio_test.dart`, alimentándolos **con datos fijos por parámetro** (sin proveedores)
- [ ] T026 [P] [US1] Pruebas de widget de las pantallas en `test/features/servicios/presentation/view/lista_servicios_page_test.dart` y `test/features/servicios/presentation/view/detalle_servicio_page_test.dart`: render del estado `Vacio` con su acción, de una fila con nombre y unidad, del formulario de creación y de los mensajes de error

### Implementation for User Story 1

- [ ] T027 [P] [US1] Crear el estado `sealed` de la lista en `lib/features/servicios/presentation/state/lista_servicios_estado.dart` con `Cargando`, `Vacio`, `ConDatos` y `Error`, según `contracts/viewmodels.md`
- [ ] T028 [P] [US1] Crear el estado `sealed` del detalle en `lib/features/servicios/presentation/state/detalle_servicio_estado.dart` con `Cargando`, `Nuevo`, `Existente`, `Guardado` y `Error`, incluido el formulario con sus errores por campo
- [ ] T029 [P] [US1] Crear el modelo de presentación `ServicioEnLista` en `lib/features/servicios/presentation/state/servicio_en_lista.dart` con nombre, símbolo de unidad, estado y si tiene etiqueta; y su mapper desde la entidad de dominio
- [ ] T030 [US1] Implementar `ListaServiciosViewModel` en `lib/features/servicios/presentation/viewmodel/lista_servicios_viewmodel.dart` con la intención `cargar()`. Sin importar Flutter
- [ ] T031 [US1] Implementar `DetalleServicioViewModel` en `lib/features/servicios/presentation/viewmodel/detalle_servicio_viewmodel.dart` con `iniciarNuevo()`, `cambiarNombre()`, `cambiarUnidad()`, `cambiarEtiquetaContrato()` y `guardar()`. Sin importar Flutter

### Componentes de User Story 1

> Cada componente es `StatelessWidget`, recibe **todos** sus datos y sus acciones por parámetro, y
> **nunca** lee proveedores. Deben caber en una responsabilidad: pintar una cosa.

- [ ] T032 [P] [US1] Crear `FilaDeServicio` en `lib/features/servicios/presentation/view/widgets/fila_de_servicio.dart`. Recibe el `ServicioEnLista` y las acciones de pulsar; pinta nombre, símbolo de unidad, indicación de estado y si tiene etiqueta de contrato
- [ ] T033 [P] [US1] Crear `EstadoVacio` en `lib/features/servicios/presentation/view/widgets/estado_vacio.dart`. Recibe el texto explicativo, el texto del botón y la acción; es reutilizable por cualquier pantalla que pueda quedar vacía
- [ ] T034 [P] [US1] Crear `SelectorDeUnidad` en `lib/features/servicios/presentation/view/widgets/selector_de_unidad.dart`. Recibe el valor seleccionado, la lista de unidades disponibles, si está habilitado y el motivo del bloqueo, y la acción de cambio
- [ ] T035 [P] [US1] Crear `CampoDeEtiqueta` en `lib/features/servicios/presentation/view/widgets/campo_de_etiqueta.dart`. Recibe el valor, el error de validación y la acción de cambio
- [ ] T036 [US1] Añadir los textos de la historia 1 al recurso ARB `lib/l10n/app_es_CO.arb`. Ninguna cadena literal en los widgets

### Pantallas de User Story 1

> Las pantallas **solo componen**. Si una pantalla empieza a tener lógica o a construir partes
> visuales por su cuenta, algo se está haciendo mal.

- [ ] T037 [US1] Crear la pantalla de listado en `lib/features/servicios/presentation/view/lista_servicios_page.dart` como `ConsumerWidget`: lee el estado del ViewModel y lo traduce a `EstadoVacio` o a una colección de `FilaDeServicio`, y conecta la navegación al detalle. Sin construir partes visuales propias
- [ ] T038 [US1] Crear la pantalla de detalle y creación en `lib/features/servicios/presentation/view/detalle_servicio_page.dart` como `ConsumerWidget`: lee el formulario del ViewModel y lo compone con `SelectorDeUnidad` y `CampoDeEtiqueta`, más el campo de nombre. Sin construir partes visuales propias
- [ ] T039 [US1] Verificar que las pruebas de `test/features/servicios/domain/nombre_de_servicio_test.dart`, `test/features/servicios/data/servicio_repository_impl_test.dart`, `test/features/servicios/presentation/viewmodel/detalle_servicio_viewmodel_test.dart` y `test/features/servicios/presentation/viewmodel/lista_servicios_viewmodel_test.dart` pasan
- [ ] T040 [US1] Verificar que las pruebas de widget de `test/features/servicios/presentation/view/` y de `test/features/servicios/presentation/view/widgets/` pasan, y que `dart analyze` sigue sin incidencias

**Checkpoint**: la historia 1 funciona por sí sola y es el MVP

---

## Phase 4: User Story 2 - Desactivar un servicio sin perder historial (Priority: P2)

**Goal**: el usuario puede desactivar un servicio que ya no recibe y reactivarlo después, sin perder
nada

**Independent Test**: desactivar un servicio, comprobar que deja de ofrecerse para operaciones nuevas,
y reactivarlo

### Tests for User Story 2 ⚠️

- [ ] T041 [P] [US2] Pruebas de repositorio en `test/features/servicios/data/servicio_repository_impl_test.dart`: `desactivarServicio`, `reactivarServicio` y conservación del orden estable tras el cambio de estado
- [ ] T042 [P] [US2] Pruebas de ViewModel en `test/features/servicios/presentation/viewmodel/lista_servicios_viewmodel_test.dart`: `desactivar()` y `reactivar()`, y el caso en que la acción falla y debe reflejarse en `errorParcial` sin perder los datos cargados
- [ ] T043 [P] [US2] Pruebas de widget en `test/features/servicios/presentation/view/widgets/fila_de_servicio_test.dart`: la fila inactiva se distingue visualmente, expone su estado a accesibilidad y ofrece la acción de reactivar

### Implementation for User Story 2

- [ ] T044 [US2] Implementar `desactivarServicio` y `reactivarServicio` en `lib/features/servicios/data/repositories/servicio_repository_impl.dart`
- [ ] T045 [US2] Añadir las intenciones `desactivar(id)` y `reactivar(id)` a `lib/features/servicios/presentation/viewmodel/lista_servicios_viewmodel.dart`
- [ ] T046 [US2] Ampliar `FilaDeServicio` en `lib/features/servicios/presentation/view/widgets/fila_de_servicio.dart` para mostrar el estado inactivo y ofrecer la acción de reactivar. Sigue recibiendo todo por parámetro
- [ ] T047 [US2] Conectar las acciones de desactivar y reactivar en `lib/features/servicios/presentation/view/lista_servicios_page.dart`, sin ofrecer ninguna opción de borrado
- [ ] T048 [US2] Añadir los textos de la historia 2 al recurso ARB `lib/l10n/app_es_CO.arb`
- [ ] T049 [US2] Verificar que las pruebas de `test/features/servicios/data/servicio_repository_impl_test.dart`, `test/features/servicios/presentation/viewmodel/lista_servicios_viewmodel_test.dart` y `test/features/servicios/presentation/view/widgets/fila_de_servicio_test.dart` pasan

**Checkpoint**: ambas historias funcionan de forma independiente

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Mejoras que afectan a todas las historias y cierre de las puertas de calidad

- [ ] T050 [P] Pruebas golden de los tokens de diseño en tema claro y oscuro en `test/core/ui/theme/app_tokens_golden_test.dart`
- [ ] T051 [P] Prueba golden de `FilaDeServicio` en tema claro y oscuro, con datos fijos, en `test/features/servicios/presentation/view/widgets/fila_de_servicio_golden_test.dart`
- [ ] T052 [P] Prueba de la función `puedeCambiarUnidad` en `test/features/servicios/domain/puede_cambiar_unidad_test.dart`, cubriendo ambos resultados (FR-006)
- [ ] T053 [P] Prueba de migración en `test/features/servicios/data/migracion_test.dart`: abrir una base con el esquema anterior y verificar que los datos sobreviven
- [ ] T054 Revisar accesibilidad en las dos pantallas y en los componentes: etiquetas `Semantics`, áreas táctiles de al menos 48 dp, soporte del escalado de texto y contraste AA
- [ ] T055 Ejecutar `dart format`, `dart analyze` y `flutter test`, y corregir todo lo que aparezca hasta que las tres pasen sin incidencias
- [ ] T056 Recorrer los escenarios E1–E8 de `specs/001-tipos-de-servicio/quickstart.md` en un dispositivo y registrar el resultado de cada uno
- [ ] T057 [P] Actualizar `README.md` con la estructura del proyecto, cómo ejecutar las pruebas y las decisiones de arquitectura relevantes

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: sin dependencias, puede empezar de inmediato
- **Foundational (Phase 2)**: depende de Setup. **Bloquea todas las historias de usuario**
- **User Story 1 (Phase 3)**: depende de Foundational
- **User Story 2 (Phase 4)**: depende de Foundational. No depende de la historia 1, pero toca los
  mismos archivos de listado, así que en la práctica conviene hacerla después
- **Polish (Phase 5)**: depende de las historias que se quieran cerrar

### User Story Dependencies

- **US1 (P1)**: independiente. Es el MVP
- **US2 (P2)**: independiente en cuanto a lógica, pero comparte `fila_de_servicio.dart`,
  `lista_servicios_page.dart` y `lista_servicios_viewmodel.dart` con US1, así que se ejecuta después
  para evitar conflictos de archivo

### Within Each User Story

- Las pruebas se escriben primero y DEBEN fallar antes de implementar
- Estados antes que ViewModels
- **Componentes antes que pantallas**: una pantalla no puede componer algo que no existe
- ViewModels antes que pantallas
- Los textos ARB al final, cuando ya se conocen los mensajes

### Parallel Opportunities

- Setup: T003, T004 y T005 en paralelo
- Foundational: T008, T009, T010, T011 y T015 en paralelo; T020 en paralelo con todo
- US1: T021–T026 (pruebas) en paralelo; T027, T028 y T029 (estados y modelo) en paralelo; **T032, T033,
  T034 y T035 (los cuatro componentes) en paralelo**, porque son archivos independientes entre sí
- US2: T041, T042 y T043 (pruebas) en paralelo
- Polish: T050, T051, T052, T053 y T057 en paralelo

---

## Parallel Example: User Story 1

```bash
# Escribir primero todas las pruebas de la historia 1, en paralelo:
Task: "Pruebas de dominio de NombreDeServicio en test/features/servicios/domain/nombre_de_servicio_test.dart"
Task: "Pruebas de repositorio en test/features/servicios/data/servicio_repository_impl_test.dart"
Task: "Pruebas de ViewModel del detalle en test/features/servicios/presentation/viewmodel/detalle_servicio_viewmodel_test.dart"
Task: "Pruebas de ViewModel de la lista en test/features/servicios/presentation/viewmodel/lista_servicios_viewmodel_test.dart"

# Después, los estados y el modelo de presentación, en paralelo:
Task: "Estado sealed de la lista en lib/features/servicios/presentation/state/lista_servicios_estado.dart"
Task: "Estado sealed del detalle en lib/features/servicios/presentation/state/detalle_servicio_estado.dart"
Task: "Modelo de presentación ServicioEnLista en lib/features/servicios/presentation/state/servicio_en_lista.dart"

# Y los cuatro componentes a la vez, porque no dependen entre sí:
Task: "FilaDeServicio en lib/features/servicios/presentation/view/widgets/fila_de_servicio.dart"
Task: "EstadoVacio en lib/features/servicios/presentation/view/widgets/estado_vacio.dart"
Task: "SelectorDeUnidad en lib/features/servicios/presentation/view/widgets/selector_de_unidad.dart"
Task: "CampoDeEtiqueta en lib/features/servicios/presentation/view/widgets/campo_de_etiqueta.dart"
```

---

## Implementation Strategy

### MVP First (solo la historia 1)

1. Completar Phase 1: Setup
2. Completar Phase 2: Foundational — es la más pesada, porque esta funcionalidad estrena el proyecto
3. Completar Phase 3: User Story 1
4. **PARAR y VALIDAR**: recorrer E1–E4 de `quickstart.md`
5. Ese es el MVP: ya se pueden registrar servicios y verlos con su unidad

### Incremental Delivery

1. Setup + Foundational → base lista
2. Historia 1 → validar E1–E4 → ya aporta valor
3. Historia 2 → validar E5 → cierra el ciclo de vida del servicio
4. Polish → validar E6–E8 y cerrar las puertas de calidad

### Parallel Team Strategy

Con una sola persona, el orden secuencial por prioridad es el correcto. Si hubiera más de una, a partir
del final de Foundational las historias pueden repartirse, con la salvedad de que US1 y US2 comparten
los archivos del listado. Los cuatro componentes de US1 son el mejor punto para repartir trabajo, porque
son archivos independientes.

---

## Notes

- `[P]` indica archivos distintos y sin dependencias pendientes
- `[US1]` y `[US2]` permiten trazar cada tarea hasta su historia de usuario
- Las pruebas no son opcionales aquí: el Principio V de la constitución las exige
- **Las pantallas solo componen.** Toda parte visual vive en `view/widgets/` y recibe sus datos y
  acciones por parámetro. Solo la pantalla de nivel superior lee proveedores
- Ninguna tarea crea un commit. El usuario commitea cuando lo decide
- No hay ninguna tarea de borrado de servicios: es deliberado (FR-015)
- No añadir `sqlite3_flutter_libs`: está obsoleto desde `sqlite3` 3.x, que empaqueta SQLite por sí mismo
- T019 incluye eliminar `test/widget_test.dart`, que prueba la app de plantilla y rompería `flutter test`
- Evitar: tareas vagas, dos tareas sobre el mismo archivo en paralelo, dependencias entre historias que
  rompan su independencia
