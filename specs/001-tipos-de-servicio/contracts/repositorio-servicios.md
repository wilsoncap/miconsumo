# Contract: Repositorio de Servicios

**Feature**: `001-tipos-de-servicio` | **Date**: 2026-10-18

Contrato que la capa de dominio expone a los ViewModel y que la capa de datos implementa. Vive en
`domain/repositories/` como interfaz abstracta, en Dart puro: no conoce Drift, ni Flutter, ni
`go_router`.

## Tipo de resultado

Toda operación devuelve un resultado explícito. No se lanzan excepciones hacia la presentación: los
errores de negocio son valores, no fallos del sistema.

```text
Resultado<T>
├── Exito<T>(valor)
└── Fallo<T>(motivo: MotivoDeFallo)
```

## Fallos previstos

| Fallo | Cuándo ocurre | Requisito |
|---|---|---|
| `NombreVacio` | El nombre queda vacío tras recortar espacios | FR-002 |
| `NombreDemasiadoLargo` | El nombre supera la longitud máxima admitida | FR-002 |
| `NombreDuplicado` | Ya existe un servicio con el mismo nombre normalizado | FR-003 |
| `UnidadRequerida` | No se seleccionó unidad | FR-004 |
| `UnidadInmutable` | Se intenta cambiar la unidad de un servicio con mediciones | FR-006 |
| `ServicioNoEncontrado` | El identificador no corresponde a ningún servicio | — |
| `Almacenamiento` | Fallo del motor de base de datos | — |

## Operaciones

| Operación | Entrada | Salida | Notas |
|---|---|---|---|
| `observarServicios()` | — | `Stream<Resultado<List<TipoDeServicio>>>` | **FLUJO**, no una foto: emite la lista actual y vuelve a emitir ante cualquier cambio. Incluye activos e inactivos, ordenados por nombre |
| `obtenerServicio(id)` | identificador | `Resultado<TipoDeServicio>` | Devuelve `ServicioNoEncontrado` si no existe |
| `crearServicio(nombre, unidad, etiquetaContrato)` | datos del formulario | `Resultado<TipoDeServicio>` | Valida nombre, unidad y duplicados |
| `actualizarServicio(id, nombre, etiquetaContrato)` | datos del formulario | `Resultado<TipoDeServicio>` | NO acepta `unidad`: el cambio de unidad se solicita por una operación aparte |
| `cambiarUnidad(id, unidad)` | identificador, unidad | `Resultado<TipoDeServicio>` | Devuelve `UnidadInmutable` si el servicio tiene mediciones |
| `desactivarServicio(id)` | identificador | `Resultado<TipoDeServicio>` | No borra nada |
| `reactivarServicio(id)` | identificador | `Resultado<TipoDeServicio>` | — |

## Reglas del contrato

- **Sin borrado de servicios**: no existe operación de eliminación. La desactivación es el único camino
  (FR-015, Principio II). No es una omisión: es una decisión de diseño que hace imposible borrar
  evidencia por accidente.
- **Unidad separada del formulario de edición**: si `actualizarServicio` aceptara la unidad, sería
  fácil saltarse la regla de inmutabilidad desde la interfaz. Al separarla, la única forma de cambiar
  una unidad es la operación que aplica la validación.
- **Orden estable**: `observarServicios` devuelve siempre el mismo orden para el mismo conjunto de datos,
  para que la interfaz no "salte" entre reconstrucciones.
- **El listado se observa, no se consulta**: `observarServicios` es un flujo, no una foto. Cualquier
  cambio —venga de la pantalla que venga— vuelve a emitir. Así el listado no puede quedarse con datos
  viejos, que fue exactamente el defecto que apareció al crear un servicio y no verlo en la lista.
- **Un fallo del flujo no lo rompe**: si el motor falla, el flujo emite un `Fallo` en lugar de
  terminar con error, para que la interfaz pueda ofrecer reintentar.
- **Sin efectos secundarios ocultos**: ninguna operación de lectura escribe.
- **Sin conceptos de facturación ni mediciones**: esas entidades pertenecen a funcionalidades
  posteriores. Este contrato no las anticipa para no acoplar la interfaz a algo que aún no existe.
