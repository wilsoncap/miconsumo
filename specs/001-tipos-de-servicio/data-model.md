# Phase 1 — Data Model: Tipos de Servicio

**Feature**: `001-tipos-de-servicio` | **Date**: 2026-10-18

Los tipos de abajo son los del dominio (Dart puro). La forma exacta de las tablas se decide en la
implementación; aquí se fija el contrato de datos y sus reglas.

## Entidades

### TipoDeServicio

Un servicio recibido en el hogar.

| Campo | Tipo | Obligatorio | Notas |
|---|---|---|---|
| `id` | identificador | sí | Generado por el sistema |
| `nombre` | texto | sí | No vacío tras recortar espacios; único sin distinguir mayúsculas ni acentos |
| `nombreNormalizado` | texto | sí | Forma derivada de `nombre`, usada para la unicidad. No se edita a mano |
| `unidad` | `UnidadMedida` | sí | kWh, m³ o kg |
| `etiquetaContrato` | texto | no | Opcional, texto libre, uso estrictamente local |
| `activo` | booleano | sí | Por defecto verdadero |
| `creadoEn` | fecha y hora | sí | Marca de captura |
| `actualizadoEn` | fecha y hora | sí | Marca de última modificación |

**Relaciones**: será referenciado por las mediciones y por los conceptos de facturación en
funcionalidades posteriores. En esta funcionalidad no tiene entidades hijas.

**Transiciones de estado**:

```text
activo ──(desactivar)──> inactivo
inactivo ──(reactivar)──> activo
```

No existe transición hacia "eliminado": un servicio NUNCA se borra (FR-015, Principio II). El sistema
no ofrece esa operación en ningún punto. Un servicio inactivo deja de ofrecerse para mediciones nuevas
(FR-009) pero conserva todo su historial.

### UnidadMedida (objeto de valor)

Enum cerrado del dominio.

| Valor | Símbolo | Servicios típicos |
|---|---|---|
| `kWh` | kWh | Electricidad |
| `m3` | m³ | Agua, gas natural |
| `kg` | kg | Gas licuado en pipeta |

El símbolo visible se resuelve en la capa de presentación con `intl`; el dominio solo conoce el valor.

### NombreDeServicio (objeto de valor)

Encapsula el nombre y su forma normalizada, de modo que la regla de unicidad no pueda aplicarse de dos
maneras distintas.

| Aspecto | Regla |
|---|---|
| Recorte | Se eliminan los espacios al inicio y al final |
| No vacío | Tras el recorte, no puede quedar vacío (FR-002) |
| Normalización | Se eliminan los acentos y se pasa a minúsculas, para comparar (FR-003) |
| Longitud | Se fija un máximo razonable en la implementación, para que el nombre quepa en la lista |

## Reglas de validación

| Regla | Requisito | Comportamiento esperado |
|---|---|---|
| Nombre no vacío | FR-002 | Rechaza el guardado e indica que el nombre es obligatorio |
| Nombre único | FR-003 | Compara sobre la forma normalizada; rechaza duplicados |
| Unidad obligatoria | FR-004 | El guardado no puede completarse sin unidad seleccionada |
| Unidad del catálogo | FR-005 | Solo se admiten los valores del enum |
| Unidad inmutable con historial | FR-006 | Bloquea el cambio de unidad cuando el servicio ya tiene mediciones, explicando el motivo |
| Etiqueta opcional | FR-013 | Puede estar vacía; se recorta y se guarda como ausente si queda vacía |
| Etiqueta local | FR-014 | Nunca forma parte de ningún dato que salga del dispositivo |
| Sin eliminación | FR-015 | No existe operación de borrado; solo desactivar y reactivar |

## Funciones de dominio

Puras, sin dependencias de Flutter ni de Drift (Principio IV):

| Función | Entrada | Salida | Notas |
|---|---|---|---|
| `normalizarNombre` | texto | texto normalizado | Sin acentos, en minúsculas, sin espacios sobrantes |
| `validarNombre` | texto | resultado de validación | Aplica las reglas de recorte, no vacío y longitud |
| `puedeCambiarUnidad` | servicio, ¿tiene mediciones? | booleano | Falso cuando ya existe historial (FR-006) |

`puedeCambiarUnidad` recibe el dato "¿tiene mediciones?" como parámetro en lugar de consultarlo, para
que siga siendo una función pura y comprobable sin base de datos. En esta funcionalidad siempre
recibirá falso, porque aún no existen mediciones; la regla queda implementada y probada para cuando
lleguen.

## Persistencia

| Aspecto | Decisión |
|---|---|
| Motor | SQLite vía Drift, en el directorio privado de la aplicación |
| Esquema inicial | `schemaVersion = 1` |
| Unicidad del nombre | Índice único sobre `nombreNormalizado` |
| Borrado | No existe operación de borrado de servicios |
| Migraciones | `MigrationStrategy` con `onCreate`, `onUpgrade` y `beforeOpen`; cada migración con prueba de conservación de datos |
| Ubicación de archivos | `path_provider` resuelve el directorio; las fotografías futuras usarán el mismo directorio |

## Trazabilidad requisito → modelo

| Requisito | Dónde se resuelve |
|---|---|
| FR-001, FR-002, FR-004, FR-005 | `TipoDeServicio` + reglas de validación |
| FR-003 | `NombreDeServicio` + índice único sobre `nombreNormalizado` |
| FR-006 | Función `puedeCambiarUnidad` |
| FR-007, FR-009, FR-010 | Transiciones de estado de `TipoDeServicio` |
| FR-008 | Ausencia de operación de borrado + historial en entidades posteriores |
| FR-011 | Contrato de la vista de listado |
| FR-012 | Persistencia local sin red |
| FR-013, FR-014 | Campo `etiquetaContrato` + regla de no transmisión |
| FR-015 | Ausencia total de operación de eliminación |
