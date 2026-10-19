# Contract: ViewModels (contratos de interfaz)

**Feature**: `001-tipos-de-servicio` | **Date**: 2026-10-18

Para una aplicación Flutter, el contrato de interfaz es la superficie que el ViewModel expone a la
View: qué estados puede emitir y qué intenciones acepta. La View no conoce nada más que esto.

Recordatorio de la regla de arquitectura: el ViewModel NO importa Flutter ni `BuildContext`, de modo
que estas pruebas se pueden escribir sin `WidgetTester`.

## Pantalla 1 — Lista de servicios

### Estado

```text
ListaServiciosEstado (sealed)
├── Cargando
├── Vacio
├── ConDatos(servicios: List<ServicioEnLista>, errorParcial: Fallo?)
└── Error(fallo: Fallo)
```

- `Vacio` es distinto de `ConDatos` con lista vacía: la interfaz debe poder mostrar un estado vacío
  con una acción para crear el primer servicio, no una lista en blanco.
- `errorParcial` permite informar de que una acción (por ejemplo desactivar) falló sin perder los datos
  ya cargados en pantalla.

### Intenciones

| Intención | Efecto | Requisito |
|---|---|---|
| `cargar()` | Carga la lista; emite `Cargando` y luego `ConDatos` o `Vacio` | FR-011 |
| `desactivar(id)` | Desactiva el servicio y recarga | FR-007 |
| `reactivar(id)` | Reactiva el servicio y recarga | FR-010 |

### Datos que ve la View

`ServicioEnLista` es un modelo de presentación con lo mínimo para pintar la fila: nombre, símbolo de
unidad, estado activo/inactivo y si tiene etiqueta de contrato. La View NO recibe la entidad de
dominio: así no puede acceder a campos que no le corresponden ni depender de la forma del dominio.

## Pantalla 2 — Detalle y edición de servicio

### Estado

```text
DetalleServicioEstado (sealed)
├── Cargando
├── Nuevo(formulario, guardando: bool)
├── Existente(servicio, formulario, guardando: bool, unidadBloqueada: bool)
├── Guardado(id: identificador)
└── Error(fallo: Fallo)
```

- `unidadBloqueada` es verdadero cuando el servicio ya tiene mediciones: la View DEBE deshabilitar el
  selector de unidad y explicar por qué (FR-006). En esta funcionalidad siempre llega falso, porque aún
  no existen mediciones; el contrato queda preparado para cuando lleguen.
- `formulario` contiene los valores en edición (nombre, unidad, etiqueta de contrato) y sus errores de
  validación por campo, de modo que la View no valide nada por su cuenta.

### Intenciones

| Intención | Efecto | Requisito |
|---|---|---|
| `cargar(id)` | Carga el servicio | — |
| `iniciarNuevo()` | Prepara un formulario vacío | FR-001 |
| `cambiarNombre(texto)` | Actualiza el formulario y revalida | FR-002, FR-003 |
| `cambiarUnidad(unidad)` | Actualiza el formulario (no disponible si está bloqueada) | FR-004, FR-005, FR-006 |
| `cambiarEtiquetaContrato(texto)` | Actualiza la etiqueta opcional | FR-013 |
| `guardar()` | Persiste y emite `Guardado` o `Error` | FR-001 |

### Reglas del contrato

- **La View no valida**: todos los mensajes de error vienen del formulario del ViewModel. Si la View
  validara, existirían dos fuentes de verdad y podrían divergir.
- **Guardar no navega**: el ViewModel emite `Guardado` y es la View quien decide a dónde ir. Así el
  ViewModel no depende de `go_router`.
- **Un solo estado de guardado**: `guardando` evita el doble envío mientras la operación está en curso.
- **Los errores de negocio se muestran, no se lanzan**: `NombreVacio`, `NombreDuplicado` y
  `UnidadInmutable` llegan como valores dentro del estado, con el texto ya resuelto para el usuario.
- **No hay intención de eliminar**: la interfaz no ofrece borrar un servicio, en coherencia con
  FR-015.
