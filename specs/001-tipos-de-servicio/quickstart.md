# Quickstart — Validación de Tipos de Servicio

**Feature**: `001-tipos-de-servicio` | **Date**: 2026-10-18

Guía para comprobar que la funcionalidad funciona de extremo a extremo. No contiene código de
implementación: los detalles pertenecen a `tasks.md` y a la fase de implementación.

## Prerrequisitos

- Flutter 3.47.2 stable con Dart `^3.13.2` (los fijados en `pubspec.yaml`).
- Un emulador o dispositivo Android, o un dispositivo físico conectado por USB.
- No se requiere conexión a red en ningún momento. Si algo de esta guía necesita red, es un error de
  implementación.

## Preparación

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Comprobaciones automáticas

```bash
dart format --set-exit-if-changed .
dart analyze
flutter test
```

Las tres DEBEN terminar sin errores ni advertencias (Principio V). `dart analyze` debe reportar cero
incidencias. Se usa `dart analyze` y no `flutter analyze` porque solo el primero ejecuta el plugin
`riverpod_lint`.

## Escenarios de validación manual

### E1 — Primer arranque sin servicios (historia P1)

1. Instalar la aplicación en un dispositivo sin datos previos.
2. Abrirla.

**Esperado**: se muestra un estado vacío que explica para qué sirve la pantalla y ofrece crear el
primer servicio. No aparece una lista en blanco ni un error.

### E2 — Crear un servicio con su unidad (historia P1)

1. Crear un servicio llamado "Luz" con unidad kWh.
2. Volver al listado.
3. Repetir con "Agua" en m³ y con "Gas en pipeta" en kg.

**Esperado**: cada fila muestra su nombre y su unidad de forma legible, sin necesidad de abrir el
detalle (SC-006). El cronómetro razonable para completar un alta es inferior a 30 segundos (SC-001).

### E3 — Nombre duplicado (historia P1)

1. Intentar crear un servicio llamado "luz" en minúsculas.
2. Intentar crear un servicio llamado "agua" cuando ya existe "Agua".

**Esperado**: se rechaza en ambos casos con un mensaje claro de que el nombre ya está en uso (SC-003).
La comparación no distingue mayúsculas ni acentos.

### E4 — Etiqueta de contrato opcional (historia P1)

1. Crear un servicio sin etiqueta de contrato.
2. Abrir su detalle y añadir la etiqueta "12345-2026".
3. Eliminar la etiqueta.

**Esperado**: el servicio se guarda correctamente en los tres casos, sin errores y sin perder ningún
otro dato.

### E5 — Desactivar y reactivar un servicio (historia P2)

1. Desactivar un servicio.
2. Comprobar el listado.
3. Reactivarlo.

**Esperado**: se muestra como inactivo y deja de ofrecerse para operaciones nuevas (FR-009). No existe
ninguna opción de eliminarlo definitivamente (FR-015). Al reactivarlo vuelve a estar disponible.

### E6 — Unidad bloqueada con historial (FR-006)

1. Con un servicio que ya tiene mediciones registradas, abrir su detalle.

**Esperado**: el selector de unidad aparece deshabilitado y la pantalla explica que no puede cambiarse
porque existe historial. Si aún no hay mediciones, el cambio sí se permite.

> Nota: este escenario depende de las mediciones, que llegan en una funcionalidad posterior. Se valida
> aquí a nivel de contrato y prueba automatizada; la comprobación manual se completa cuando existan
> mediciones.

### E7 — Sin conexión (Principio I)

1. Activar el modo avión.
2. Recorrer E2, E4 y E5.

**Esperado**: todo funciona igual. La aplicación no solicita permisos de red en ningún momento.

### E8 — Formato y accesibilidad (Estándares de UI)

1. Crear un servicio y observar el formato de los textos.
2. Con el escalado de texto del sistema al máximo, recorrer el listado y el detalle.
3. Activar el modo oscuro.
4. Activar TalkBack y recorrer la pantalla de creación.

**Esperado**: los textos aparecen en español de Colombia; ningún texto se corta ni se solapa; el
contraste es suficiente en ambos temas; los elementos interactivos anuncian su propósito.

## Pruebas automatizadas mínimas esperadas

| Nivel | Qué debe cubrir |
|---|---|
| Dominio | `normalizarNombre` con acentos y mayúsculas; `validarNombre` con texto vacío, solo espacios y longitud excesiva; `puedeCambiarUnidad` en ambos casos |
| Repositorio | Alta, listado en orden estable, rechazo de duplicados por nombre normalizado, desactivación y reactivación contra una base Drift en memoria; migración desde el esquema anterior |
| ViewModel | Cada transición de estado de ambas pantallas, incluidos los caminos de error y el estado vacío |
| Vista | Render de los cuatro estados (`Cargando`, `Vacio`, `ConDatos`, `Error`) y bloqueo del selector de unidad |
| Golden | Tokens del sistema de diseño en tema claro y oscuro |
| Arquitectura | Que `domain/` no importe `package:flutter`, `package:drift` ni `package:go_router` |

## Criterio de aceptación

La funcionalidad se considera validada cuando los ocho escenarios manuales se comportan como se
describe, las comprobaciones automáticas pasan sin errores y todas las filas de la tabla anterior
tienen pruebas presentes.
