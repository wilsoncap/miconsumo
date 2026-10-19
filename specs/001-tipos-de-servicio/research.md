# Phase 0 — Research: Tipos de Servicio

**Feature**: `001-tipos-de-servicio` | **Date**: 2026-10-18

El contexto técnico no dejó ningún `NEEDS CLARIFICATION`. Esta fase documenta las decisiones de
tecnología y las prácticas asociadas, con la alternativa que se descartó y el motivo.

## R1. Gestión de estado e inyección de dependencias

- **Decision**: Riverpod 3 (`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`),
  usando `Notifier`/`AsyncNotifier` generados como ViewModel y `ProviderScope` como contenedor de
  inyección.
- **Rationale**: es la elección que fija la constitución y ya está declarada en `pubspec.yaml`. Los
  `Notifier` viven en `package:riverpod`, no en `flutter_riverpod`, lo que permite que el ViewModel no
  importe Flutter y sea testeable sin `WidgetTester` (regla del Principio de Arquitectura).
- **Alternatives considered**: `provider` (sin generación de código ni estados asíncronos tipados);
  `bloc` (más ceremonioso para el tamaño de esta app y añade un paradigma distinto al ya fijado);
  `setState` (prohibido por la constitución para lógica de negocio).

## R2. Persistencia local

- **Decision**: Drift sobre SQLite, con `path_provider` + `path` para resolver la ubicación del
  archivo. NO se usa `sqlite3_flutter_libs`: está obsoleto.
- **Rationale**: Drift 2.35.2 depende de `sqlite3: ^3.4.0`, y a partir de la versión 3.x ese paquete
  empaqueta SQLite por sí mismo mediante los *build hooks* de Dart, de modo que el paquete auxiliar ya
  no hace nada. Las notas oficiales de migración lo dicen de forma explícita: *"If you depend on
  `sqlite3_flutter_libs`, stop doing that."* Drift aporta además consultas tipadas, migraciones
  versionadas y `NativeDatabase.memory()` para pruebas rápidas sin tocar disco.
- **Consecuencia en la compilación**: los binarios de SQLite se descargan desde las *releases* del
  paquete durante la compilación, así que **la primera compilación necesita red**. El funcionamiento en
  tiempo de ejecución sigue siendo por completo sin conexión, de modo que el Principio I no se ve
  afectado.
- **Alternatives considered**: `sqflite` (SQL en cadenas, sin tipado ni migraciones verificables);
  `isar`/`objectbox` (excelentes en rendimiento pero atan a su propio modelo y complican mantener el
  dominio puro); `shared_preferences` (no sirve para datos relacionales con historial).

## R3. Representación de las unidades de medida

- **Decision**: enum `UnidadMedida` en la capa de dominio, con los valores `kWh`, `m3` y `kg`. El
  texto visible y el símbolo se resuelven con `intl` en la capa de presentación.
- **Rationale**: el catálogo es cerrado (decisión registrada en las Assumptions de la spec). Un enum
  da seguridad de tipos, imposibilita valores inválidos y mantiene el dominio sin dependencias.
  `kg` se incluye porque en Colombia el gas licuado en pipeta se vende por kilogramo, no por m³.
- **Alternatives considered**: tabla en la base de datos (permitiría ampliar el catálogo sin
  recompilar, pero añade una consulta y una entidad para un conjunto que hoy es fijo); texto libre
  (permitiría errores de escritura que romperían la comparación de consumo).

## R4. Modelos inmutables y estados de UI

- **Decision**: `freezed` + `freezed_annotation` para entidades, objetos de valor y estados de UI.
- **Rationale**: genera igualdad por valor, `copyWith` y uniones `sealed` con mucho menos código a
  mano; encaja con la regla de estados `sealed` de los Estándares de UI. La constitución ya contempla
  `*.freezed.dart` como archivo generado.
- **Alternatives considered**: clases `final` con `copyWith` manual (mucho código repetitivo y
  propenso a olvidos en la igualdad); `equatable` (resuelve la igualdad pero no las uniones ni el
  `copyWith`).

## R5. Normalización y unicidad del nombre

- **Decision**: la comparación de nombres se hace sobre una forma normalizada —sin distinguir
  mayúsculas ni acentos— calculada en el dominio, y se refuerza con un índice único sobre esa forma
  normalizada en la base de datos.
- **Rationale**: FR-003 exige rechazar duplicados ignorando mayúsculas y acentos. Validar solo en el
  dominio dejaría la puerta abierta a duplicados introducidos por otra vía; validar solo en la base de
  datos daría un error incomprensible al usuario. Se hace en ambos sitios con la misma función.
- **Alternatives considered**: comparación exacta (permitiría "Agua" y "agua" como servicios
  distintos, que es justo lo que el usuario no quiere); unicidad solo en la base de datos (mensaje de
  error opaco).

## R6. Navegación

- **Decision**: `go_router` con las rutas declaradas en un único archivo bajo `lib/app/router/`. Para
  esta funcionalidad: listado de servicios y detalle de servicio.
- **Rationale**: fija la constitución. Centralizar las rutas evita que una pantalla conozca la ruta de
  otra y facilita añadir más adelante la navegación profunda desde el reporte compartido.
- **Alternatives considered**: `Navigator` 1.0 con rutas nombradas (sin tipado ni validación de
  rutas); navegación imperativa dispersa (imposible de auditar).

## R7. Localización y formato

- **Decision**: `flutter_localizations` + `intl` con archivos ARB, locale base `es_CO` (español de
  Colombia).
- **Rationale**: lo exige la sección de Estándares de UI. Verificado en el entorno: `es_CO` existe en
  `flutter_localizations` (`MaterialLocalizationEsCo`), pero **no** en los datos numéricos de `intl`
  0.20.3 (CLDR 48), que solo ofrece `es`, `es_ES`, `es_MX` y `es_US`. `es_CO` recurre a `es`, cuyos
  separadores —coma decimal y punto de miles— son los correctos para Colombia.
- **Consecuencia registrada en la constitución**: la moneda y el símbolo DEBEN pasarse siempre de
  forma explícita a `NumberFormat`, porque al no existir datos propios para `es_CO` el valor por
  defecto podría no ser el esperado.
- **Alternatives considered**: usar `es` como locale (funcionaría para los números, pero perdería los
  matices regionales de fechas y formatos que `es_CO` sí aporta); cadenas literales en los widgets
  (prohibido por la constitución).

## R8. Sistema de diseño y tokens

- **Decision**: `ThemeExtension` para espaciados, radios, duraciones y tipografía, además de
  `ColorScheme.fromSeed` con variantes clara y oscura.
- **Rationale**: lo exige la sección de Estándares de UI y evita números mágicos repartidos por los
  widgets. Permite además pruebas golden estables, porque los valores viven en un único sitio.
- **Alternatives considered**: constantes estáticas en una clase de utilidades (no participan del
  tema, así que no responden a modo claro/oscuro ni a futuros cambios de marca).

## R9. Reglas de calidad y linting

- **Decision**: `flutter_lints` como base, ampliado con `require_trailing_commas`,
  `prefer_single_quotes`, `unawaited_futures`, `always_declare_return_types` y `avoid_dynamic_calls`.
  Se añade `custom_lint` + `riverpod_lint` para las reglas específicas de Riverpod.
- **Rationale**: las puertas del Principio V solo son fiables si el analizador detecta antes lo que un
  test no cubre. `riverpod_lint` señala usos incorrectos de `ref` que de otro modo aparecen en
  ejecución.
- **Alternatives considered**: `flutter_lints` por defecto (demasiado permisivo);
  `very_good_analysis` (excelente, pero impone documentación pública obligatoria que no aporta en una
  app de un solo desarrollador).

## R10. Migraciones y pruebas de la base de datos

- **Decision**: `schemaVersion` explícito con `MigrationStrategy` que declare `onCreate`, `onUpgrade` y
  `beforeOpen`. Toda migración se acompaña de una prueba que abra una base con el esquema anterior y
  verifique que los datos sobreviven.
- **Rationale**: el Principio de persistencia exige migración y plan de reversión para todo cambio de
  esquema. Probar la migración es la única forma de saber que el plan de reversión es real.
- **Alternatives considered**: recrear la base en cada cambio de esquema (destruiría la evidencia del
  usuario, prohibido por el Principio II).

## R11. Estrategia de pruebas

- **Decision**: cuatro niveles.
  1. **Dominio**: funciones puras, sin mocks, con los casos límite de la spec.
  2. **ViewModel**: `ProviderContainer` con dependencias sustituidas; sin `WidgetTester`.
  3. **Vistas**: pruebas de widget sobre los estados `sealed`, comprobando carga, vacío, datos y error.
  4. **Golden**: del sistema de diseño, no de pantallas completas.
- **Rationale**: cada nivel prueba lo que el anterior no puede. Los goldens de pantallas completas se
  rompen por cambios irrelevantes y generan ruido; los del sistema de diseño protegen los tokens.
- **Alternatives considered**: solo pruebas de widget (lentas y no cubren las reglas de dominio);
  solo pruebas unitarias (dejarían la interfaz sin red de seguridad).

## Decisiones diferidas a funcionalidades posteriores

No pertenecen a esta funcionalidad, pero conviene no perderlas de vista:

- **Aritmética decimal** (paquete `decimal`): se decide al introducir los conceptos de facturación,
  que son los primeros en manejar montos y consumos. Lo exige el Principio III.
- **Valores con vigencia temporal**: eventos append-only para precios, cargos y porcentajes. Lo exige
  el Principio VII. Corresponde a los conceptos de facturación.
- **Congelamiento de períodos**: corresponde al cálculo de la factura, no a los conceptos.
- **Calendario de festivos colombianos**: tabla propia embebida, nunca una API, porque el Principio I
  prohíbe depender de la red. Corresponde a las fechas de corte.
- **Fotografías de evidencia**: `image_picker` y almacenamiento privado. Corresponde a las mediciones
  diarias.
