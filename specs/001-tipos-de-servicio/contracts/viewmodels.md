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
├── ListaCargando
├── ListaVacia
├── ListaConDatos(servicios: List<ServicioEnLista>, errorParcial: MotivoDeFallo?)
└── ListaConError(motivo: MotivoDeFallo)
```

- `ListaVacia` es distinto de `ListaConDatos` con lista vacía: la interfaz debe poder mostrar un estado vacío
  con una acción para crear el primer servicio, no una lista en blanco.
- `errorParcial` permite informar de que una acción (por ejemplo desactivar) falló sin perder los datos
  ya cargados en pantalla.

### Intenciones

| Intención | Efecto | Requisito |
|---|---|---|
| `reintentar()` | Vuelve a suscribirse al flujo de datos | FR-011 |
| `desactivar(id)` | Desactiva el servicio; el flujo refleja el cambio | FR-007 |
| `reactivar(id)` | Reactiva el servicio; el flujo refleja el cambio | FR-010 |

### Cómo se mantiene al día

El ViewModel se **suscribe** al flujo de datos del repositorio en lugar de pedir una foto una vez. No
existe ninguna intención de "recargar": cualquier cambio, venga de donde venga, vuelve a emitir y el
listado se actualiza solo. `reintentar()` solo sirve para volver a suscribirse cuando el flujo falló.

### Datos que ve la View

`ServicioEnLista` es un modelo de presentación con lo mínimo para pintar la fila: nombre, símbolo de
unidad, estado activo/inactivo y si tiene etiqueta de contrato. La View NO recibe la entidad de
dominio: así no puede acceder a campos que no le corresponden ni depender de la forma del dominio.

## Pantalla 2 — Detalle y edición de servicio

### Estado

```text
DetalleServicioEstado (sealed)
├── DetalleCargando
├── DetalleNuevo(formulario: FormularioDeServicio, guardando: bool)
├── DetalleExistente(id: int, formulario, guardando: bool, unidadBloqueada: bool)
├── DetalleGuardado(id: int)
└── DetalleConError(motivo: MotivoDeFallo)
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
| `cambiarNombre(texto)` | Actualiza el formulario y limpia el error de nombre | FR-002, FR-003 |
| `cambiarUnidad(unidad)` | Actualiza el formulario (no disponible si está bloqueada) | FR-004, FR-005, FR-006 |
| `cambiarEtiquetaContrato(texto)` | Actualiza la etiqueta opcional | FR-013 |
| `guardar()` | Persiste y emite `DetalleGuardado` o `DetalleConError` | FR-001 |

### Reglas del contrato

- **La View no valida**: todos los mensajes de error vienen del formulario del ViewModel. Si la View
  validara, existirían dos fuentes de verdad y podrían divergir.
- **El estado guarda el motivo, no el texto**: el ViewModel no puede traducir nada porque no importa
  Flutter. Guarda un `MotivoDeFallo` y es la View quien resuelve el texto con `mensajeDeFallo` y los
  recursos ARB.
- **Guardar no navega**: el ViewModel emite `DetalleGuardado` y es la View quien decide a dónde ir. Así
  el ViewModel no depende de `go_router`.
- **Un solo estado de guardado**: `guardando` evita el doble envío mientras la operación está en curso.
- **La validación ocurre al guardar, no al escribir**: `cambiarNombre` limpia el error anterior en
  lugar de revalidar en cada pulsación, que sería ruidoso. Al pulsar Guardar se validan nombre y unidad
  y se marcan los errores por campo.
- **La View no recibe la entidad de dominio**: el listado recibe `ServicioEnLista` y el detalle recibe
  el formulario y el identificador. Así la interfaz no depende de la forma del dominio.
- **No hay intención de eliminar**: la interfaz no ofrece borrar un servicio, en coherencia con
  FR-015.
