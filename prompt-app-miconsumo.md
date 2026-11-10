# Prompt maestro — Mi Consumo

**Qué es esto**: un prompt único y autosuficiente para pedirle a una IA que genere un prototipo visual navegable (o la app completa) de **Mi Consumo**, sin pasar por el flujo de Spec-Driven Development.

**Cómo usarlo**:
- Copia todo lo que está entre `<!-- PROMPT: INICIO -->` y `<!-- PROMPT: FIN -->`.
- Si la herramienta genera pantallas (Figma AI, Stitch, v0, Lovable, etc.), funciona tal cual.
- Si la herramienta genera código Flutter, añade también el **Anexo técnico**.
- Si la herramienta pide un texto corto, usa el **Prompt corto** del final.

---

<!-- PROMPT: INICIO -->

# ROL

Eres un equipo de producto formado por diseñador UX/UI y desarrollador Flutter senior, especializado en apps móviles Android, offline-first y Material 3.

# OBJETIVO

Diseña y entrega un **prototipo visual navegable de alta fidelidad** de **Mi Consumo**, una app Android para que una persona registre el consumo diario de los servicios de su hogar —luz, agua y gas— y lo compare con lo que le cobra la empresa proveedora.

No es una app de finanzas, ni un dashboard corporativo, ni una red social. Es una **libreta de evidencia doméstica**: tranquila, clara y confiable.

# 1. CONTEXTO DEL PRODUCTO

- **Nombre**: Mi Consumo.
- **Idioma**: español de Colombia (`es_CO`). Todos los textos visibles, fechas y números deben estar en español.
- **Plataforma**: Android, móvil, vertical.
- **Usuario**: responsable del hogar en Colombia, sin conocimientos técnicos. Registra las lecturas del medidor para tener evidencia frente a la empresa de servicios.
- **Problema**: la factura llega y no se sabe si el cobro corresponde al consumo real. Las fotos del medidor se pierden en la galería y no hay historial ordenado.
- **Propuesta de valor**: registrar la lectura del medidor en segundos, con foto opcional de respaldo, y ver el consumo del mes comparado con el mes anterior. Todo se guarda en el teléfono; nada sale a Internet.
- **Estado actual**: ya existen dos módulos funcionales: **Tipos de servicio** y **Mediciones diarias con foto**. Los módulos de conceptos de facturación, fechas de corte, cálculo de la factura y compartir como protesta son visión de producto y se pueden mostrar como fase 2.

# 2. PRINCIPIOS IRRENUNCIABLES

1. **Offline-first**: la app funciona completa sin conexión. No hay login, backend, nube, sincronización ni llamadas de red.
2. **Evidencia primero**: una lectura registrada no se edita ni se borra. Corregir es añadir una lectura nueva que reemplaza a la anterior; la anterior queda visible y marcada como “Reemplazada”.
3. **Nada se elimina**: los servicios y los conceptos se desactivan, nunca se borran. No debe existir ningún botón, menú o gesto de eliminar.
4. **La foto no se pierde**: la foto del medidor es opcional, se guarda en el almacenamiento privado con un nombre nuevo y nunca se sobrescribe ni se borra al corregir una lectura.
5. **Privacidad total**: sin publicidad, sin analítica de terceros, sin rastreo. El número de contrato es opcional y de uso estrictamente local. Compartir solo ocurre si el usuario lo pide explícitamente.
6. **Números claros**: los valores de consumo y dinero usan decimales, nunca `double`. Los totales en pesos se redondean una sola vez al final.
7. **Tranquilidad, no culpa**: el tono es informativo y sereno. No se regaña al usuario ni se usan alarmas rojas innecesarias.

# 3. DIRECCIÓN VISUAL

**Concepto**: “una libreta de evidencia que da calma”. Debe sentirse ordenada, honesta y fácil de leer, no fría ni corporativa.

## Material 3

- Usa Material 3 con `ColorScheme.fromSeed`.
- Semilla: **verde teal profundo `#00695C`**.
- Variantes clara y oscura.
- Superficie clara: blanco cálido (`#F7F9F8`), no blanco puro.
- Superficie oscura: gris verdoso muy oscuro (`#101413`), no negro puro.
- Acento de advertencia: ámbar (`#B26A00`).
- Error: rojo (`#B3261E`).
- Éxito o mejora: verde del tema primario.

## Tipografía

- Sans-serif del sistema (Roboto en Android).
- Títulos en semibold; cuerpo en regular.
- Números grandes y legibles; usa cifras tabulares cuando sea posible.
- Jerarquía clara: título de pantalla, título de sección, cuerpo, etiqueta pequeña.

## Forma y espacio

- Márgenes laterales: 16 dp.
- Grid de espacio: 4, 8, 12, 16, 24, 32 dp.
- Radios: 8 dp (chips), 12 dp (tarjetas pequeñas), 16 dp (tarjetas y hojas).
- Elevación baja y sutil; separadores finos de 1 dp.
- Área táctil mínima: 48 dp.
- Botones principales: `FilledButton`; acciones secundarias: `OutlinedButton` o `TextButton`.
- FAB extendido solo en pantallas con listas.

## Iconografía

- Iconos outlined de Material:
  - `add` para agregar.
  - `speed` para mediciones.
  - `bar_chart` para consumo.
  - `event` para fecha.
  - `photo_camera_outlined` y `photo_library_outlined` para foto.
  - `badge_outlined` para contrato.
  - `toggle_on` / `toggle_off` para activo/inactivo.
  - `warning_amber_rounded` para avisos.
  - `chevron_left` / `chevron_right` para mes.
  - `broken_image_outlined` para foto no disponible.

## Lo que NO debe parecer

- No uses degradados morados, azules corporativos ni “look SaaS”.
- No uses gamificación, medallas, rachas ni emojis.
- No uses ilustraciones infantiles ni personajes.
- No uses tablas densas ni gráficas 3D.
- No uses un menú hamburguesa ni una barra inferior si no aporta.

# 4. MAPA DE PANTALLAS

```text
Mis servicios
├── Nuevo servicio
└── Editar servicio
    ├── Mediciones (historial)
    │   ├── Registrar lectura
    │   │   └── Aviso de lectura menor
    │   └── Visor de foto
    └── Consumo (gráfica + tarjetas)

Fase 2 (opcional):
Editar servicio
├── Conceptos de facturación
│   └── Historial de valores
├── Fechas de corte y festivos
├── Cálculo de la factura
└── Compartir como protesta
```

Navegación jerárquica con botón de volver. No hay login ni pantalla de inicio separada: la app abre en **Mis servicios**.

# 5. PANTALLAS

## 5.1 Mis servicios

**Propósito**: ver todos los servicios del hogar y su estado.

**Layout**:
- `AppBar` con título **“Mis servicios”**.
- Lista de filas.
- FAB extendido **“Agregar servicio”** con icono `+` cuando hay datos.
- Estado vacío con botón **“Registrar el primero”**.

**Fila de servicio**:
- Nombre del servicio, por ejemplo **“Luz”**.
- Subtítulo con la unidad: **“kWh”**, **“m³”** o **“kg”**.
- Icono de contrato (`badge_outlined`) si tiene número de contrato.
- Texto **“Inactivo”** si está desactivado.
- Botón de estado a la derecha: `toggle_on` para activo, `toggle_off` para inactivo. Al pulsarlo, desactiva o reactiva sin borrar.
- Toda la fila abre el detalle del servicio.

**Estados**:
- **Cargando**: spinner centrado.
- **Vacío**: título **“Todavía no tienes servicios”**, mensaje **“Registra la luz, el agua o el gas para empezar a medir su consumo.”**, botón **“Registrar el primero”**.
- **Con datos**: lista.
- **Error**: mensaje y botón **“Reintentar”**.

**Datos de ejemplo**:
- Luz — kWh — contrato 12345-2026 — activo.
- Agua — m³ — contrato 88421 — activo.
- Gas — m³ — activo.
- Gas pipeta — kg — inactivo.

## 5.2 Nuevo servicio / Editar servicio

**Propósito**: crear o editar un servicio.

**Layout**:
- `AppBar`: **“Nuevo servicio”** o **“Editar servicio”**.
- En edición, acción superior con icono `speed` y tooltip **“Ver mediciones”**.
- Formulario con scroll.
- Botón inferior fijo **“Guardar”**.

**Campos**:
1. **Nombre del servicio**
   - Etiqueta: “Nombre del servicio”.
   - Ayuda: “Por ejemplo: Luz, Agua, Gas”.
   - Máximo 60 caracteres.
   - Error si está vacío: “Escribe un nombre para el servicio.”
   - Error si es duplicado: “Ya tienes un servicio con ese nombre.” La comparación ignora mayúsculas, minúsculas y acentos.
2. **Unidad de medida**
   - Etiqueta: “Unidad de medida”.
   - Chips seleccionables: **kWh**, **m³**, **kg**.
   - Si el servicio ya tiene lecturas, los chips se deshabilitan y aparece: “No puedes cambiar la unidad porque este servicio ya tiene mediciones registradas.”
3. **Número de contrato (opcional)**
   - Etiqueta: “Número de contrato (opcional)”.
   - Ayuda: “Aparece en tu factura. Se queda en este teléfono.”

**Comportamiento**:
- Al guardar, vuelve a la pantalla anterior.
- No hay botón de eliminar.
- Si el servicio está inactivo, se puede editar igual, pero no admite lecturas nuevas.

## 5.3 Mediciones (historial)

**Propósito**: ver todas las lecturas de un servicio, de la más reciente a la más antigua.

**Layout**:
- `AppBar`: **“Mediciones”**.
- Acción superior con icono `bar_chart` y tooltip **“Consumo”**.
- FAB extendido **“Registrar lectura”** si hay datos o si está vacío.
- Lista de lecturas.

**Fila de lectura**:
- Fecha a la izquierda, formato **“29 nov”**.
- Valor principal: **“45.151 kWh”**.
- Subtítulo:
  - **“Sin consumo aún”** si es la primera lectura.
  - **“43 kWh”** si abarca un día.
  - **“3 días · 43 kWh”** si abarca varios días.
- Etiqueta **“Reemplazada”** en gris si la lectura fue corregida.
- Miniatura de la foto de 48 dp si tiene foto; al pulsarla se abre el visor.
- Las lecturas reemplazadas se ven más discretas, pero siguen consultables.

**Estados**:
- **Cargando**: spinner.
- **Vacío**: título **“Todavía no hay lecturas”**, mensaje **“Anota el número que muestra tu medidor para empezar a ver tu consumo.”**, botón **“Registrar la primera”**.
- **Con datos**: lista.
- **Error**: mensaje y **“Reintentar”**.

## 5.4 Registrar lectura

**Propósito**: anotar el número del medidor de un servicio en una fecha.

**Layout**:
- `AppBar`: **“Registrar lectura”**.
- Nombre del servicio como título grande, por ejemplo **“Luz”**.
- Botón de fecha con icono `event`: **“Fecha de la lectura: 29 noviembre 2026”**.
- Campo **“Lectura del medidor”** con ayuda **“El número que muestra el contador”** y sufijo con la unidad.
- Sección **“Foto del medidor (opcional)”** con texto **“Una foto refuerza tu evidencia.”**
  - Botones **“Tomar foto”** y **“Elegir de la galería”**.
  - Si ya hay foto: miniatura, texto **“Foto lista para guardar”**, acción **“Ver foto”** y **“Quitar la foto”**.
- Botón inferior **“Registrar”**.

**Reglas de la pantalla**:
- Fecha por defecto: hoy. No se permiten fechas futuras.
- El valor acepta coma y punto como separador decimal.
- Si el valor es menor que la lectura vigente anterior a esa fecha, se muestra un aviso antes de guardar:
  - Icono de advertencia.
  - Título **“La lectura es menor que la anterior”**.
  - Mensaje: “Anotaste 44.970 kWh y la lectura anterior fue 44.978 kWh. Puede pasar si cambiaron el medidor. ¿La guardamos igual?”
  - Botón **“Guardar igual”** y **“Cancelar”**.
- Si el servicio está desactivado: “Ese servicio está desactivado, así que no admite lecturas.”
- Si la fecha es futura: “No puedes registrar una lectura con una fecha futura.”
- Si el valor no es válido: “Escribe un número válido para la lectura.”
- Al guardar correctamente, vuelve al historial.

## 5.5 Consumo

**Propósito**: ver la gráfica del consumo diario del mes y compararlo con el mes anterior.

**Layout**:
- `AppBar`: **“Consumo”**.
- Selector de mes: `chevron_left`, **“noviembre 2026”**, `chevron_right`.
  - El mes siguiente se deshabilita si es futuro.
- Gráfica de barras:
  - Una barra por lectura del mes.
  - Eje X: días del mes (1, 5, 9, 13, 17, 21, 25, 29).
  - Eje Y: unidad del servicio.
  - Línea horizontal punteada con el promedio diario.
  - Tooltip al tocar una barra: fecha y consumo.
  - Barras de consumo negativo en rojo.
- Tarjetas debajo:
  - **“Este mes”**: total del mes.
  - **“Mes anterior”**: total de referencia.
  - **“Variación”**: porcentaje con signo. Si no hay comparación: **“Sin comparación”**.
  - **“Promedio diario”**: total dividido por los días del período.
  - **“Día de mayor consumo”**: valor y fecha de la barra más alta.
- Si hay consumo negativo, aviso: **“Hay un consumo negativo. Revisa si el medidor se reinició o si corregiste una lectura.”**

**Estados**:
- **Sin lecturas**: título **“Sin lecturas todavía”**, mensaje **“Registra la lectura de tu medidor para empezar a ver tu consumo.”**, botón **“Registrar la primera”**.
- **Una sola lectura**: título **“Hace falta una segunda lectura”**, mensaje **“Con una sola lectura no hay consumo que calcular. Registra otra y verás aquí tu consumo en kWh.”**, botón **“Registrar otra”**.
- **Mes sin lecturas**: título **“Este mes no tiene lecturas”**, mensaje **“Registra una lectura para este período o cambia de mes para ver otro consumo.”**
- **Con datos**: gráfica y tarjetas.
- **Error**: mensaje y **“Reintentar”**.

**Cálculos visibles**:
- Consumo entre dos lecturas = lectura actual − lectura anterior.
- La primera lectura no produce consumo.
- El consumo se atribuye a la fecha de la lectura que lo cierra y muestra cuántos días abarca. No se reparte entre los días intermedios.
- Total del mes = última lectura del mes − última lectura del mes anterior.
- Variación = (total actual − total anterior) / total anterior × 100. Si falta el mes anterior o es cero, no se muestra porcentaje.
- Promedio diario = total del mes / días del período.

## 5.6 Visor de foto

- Se abre desde la miniatura del historial o desde el formulario.
- Fondo oscuro, imagen centrada con `BoxFit.contain`.
- Título **“Foto del medidor”**.
- Botón **“Cerrar”**.
- Si el archivo ya no existe: **“La foto ya no está disponible”**.

## 5.7 Fase 2 — Conceptos de facturación (opcional)

Pantalla dentro del detalle del servicio:
- Lista de conceptos: nombre, base de cálculo, signo (+/−), valor vigente y estado.
- Botón **“Agregar concepto”**.
- Formulario:
  - Nombre del concepto.
  - Base: **Monto fijo**, **Por consumo** o **Porcentaje de otro concepto**.
  - Signo: **Suma** o **Resta**.
  - Valor.
  - Si es porcentaje, selector del concepto base del mismo servicio.
  - Fecha efectiva.
- Historial de valores: línea de tiempo con valor y fecha efectiva. Se agrega un valor nuevo; nunca se edita ni se borra el anterior.
- Reglas: nombre único dentro del servicio, porcentaje entre 0 y 100, sin ciclos, sin referencias a otro servicio, nunca eliminar.

## 5.8 Fase 2 — Fechas de corte y festivos (opcional)

- Configuración por servicio: día de corte y ajuste por festivos colombianos.
- Vista del próximo corte y de los períodos.
- Los festivos corren la fecha de corte dos o tres días.
- No se recalcula un período cerrado.

## 5.9 Fase 2 — Cálculo de la factura (opcional)

- Elegir servicio y período.
- Ver consumo del período, conceptos aplicados con el valor vigente a la fecha de corte, subtotal y total en pesos.
- Comparar contra el valor facturado por la empresa, si el usuario lo ingresa.
- Marcar el período como cerrado: queda congelado y no se recalcula.
- Total en pesos enteros; valores unitarios con decimales; redondeo una sola vez al final.

## 5.10 Fase 2 — Compartir como protesta (opcional)

- Elegir servicio y período.
- Vista previa de una tarjeta de evidencia: servicio, contrato, lecturas, fotos, consumo y comparación.
- Compartir con la hoja nativa de Android solo cuando el usuario lo pida.
- Nada se sube automáticamente.
- Sin enlaces de donación dentro de la app.

# 6. FLUJOS PRINCIPALES

## Primer uso
1. Abre en **Mis servicios** con estado vacío.
2. Pulsa **“Registrar el primero”**.
3. Crea “Luz” con unidad kWh y contrato opcional.
4. Guarda y vuelve a la lista.
5. Repite para Agua y Gas.

## Registro diario
1. Abre un servicio.
2. Pulsa el icono `speed` para ir a **Mediciones**.
3. Pulsa **“Registrar lectura”**.
4. Confirma la fecha, escribe el número y, si quiere, toma o elige una foto.
5. Pulsa **“Registrar”**.
6. La lectura aparece en el historial con su consumo.

## Corrección
1. Registra otra lectura para la misma fecha.
2. La anterior pasa a **“Reemplazada”** y sigue visible.
3. La foto anterior no se toca.

## Revisión del consumo
1. Desde **Mediciones**, pulsa el icono `bar_chart`.
2. Ve la gráfica del mes y las tarjetas.
3. Cambia de mes con las flechas.
4. Si hay consumo negativo, lee el aviso.

## Desactivar un servicio
1. En **Mis servicios**, pulsa el toggle del servicio.
2. El servicio queda **“Inactivo”**, no se borra.
3. Deja de ofrecerse para lecturas nuevas.
4. Se puede reactivar.

# 7. MODELO DE DATOS

## Servicio
| Campo | Tipo | Regla |
|---|---|---|
| id | entero | Generado |
| nombre | texto | No vacío, máximo 60 |
| nombreNormalizado | texto | Sin acentos, minúsculas; único |
| unidad | kWh \| m³ \| kg | Obligatoria; inmutable si hay lecturas |
| etiquetaContrato | texto opcional | Local, nunca se transmite |
| activo | booleano | Por defecto verdadero |
| creadoEn | fecha y hora | Automático |
| actualizadoEn | fecha y hora | Automático |

## Lectura
| Campo | Tipo | Regla |
|---|---|---|
| id | entero | Generado |
| servicioId | referencia | Obligatorio |
| fecha | fecha sin hora | No futura |
| valor | decimal | Mayor o igual que cero |
| rutaFoto | texto opcional | Ruta relativa en almacenamiento privado |
| estado | vigente \| reemplazada | Una vigente por servicio y día |
| reemplazaA | referencia opcional | Lectura anterior corregida |
| creadaEn | fecha y hora | Automático |

## Concepto (fase 2)
- id, servicioId, nombre, base (`fijo`, `consumo`, `porcentaje`), signo (`suma`, `resta`), conceptoBaseId opcional, activo, orden.

## Valor de concepto (fase 2)
- id, conceptoId, valor decimal, fechaEfectiva, creadoEn. Append-only.

## Período / factura (fase 2)
- id, servicioId, período, estado (`abierto`, `cerrado`), total, congeladoEn.

# 8. REGLAS DE NEGOCIO QUE LA UI DEBE REFLEJAR

1. El nombre del servicio no puede estar vacío ni repetirse ignorando mayúsculas y acentos.
2. La unidad es obligatoria y no se puede cambiar si el servicio ya tiene lecturas.
3. Un servicio desactivado no admite lecturas nuevas, pero conserva su historial.
4. Una lectura no se edita ni se borra. Corregir es agregar otra.
5. Solo puede haber una lectura vigente por servicio y día.
6. Una lectura con fecha futura se rechaza.
7. Una lectura menor que la anterior pide confirmación.
8. La primera lectura no produce consumo.
9. El consumo no se guarda: se calcula.
10. El consumo se atribuye a la fecha de la lectura que lo cierra; se muestran los días que abarca.
11. El total del mes usa la última lectura del mes y la última del mes anterior.
12. La variación se omite si no hay mes anterior o si el anterior es cero.
13. La foto es opcional y nunca se sobrescribe.
14. El número de contrato es opcional y local.
15. No existe eliminación de servicios, lecturas, conceptos ni fotos.
16. Los valores monetarios y de consumo usan decimales, nunca `double`.
17. Los totales en pesos se redondean una sola vez al final.
18. Todo funciona sin conexión.
19. Sin publicidad, sin analítica, sin rastreo.
20. Un solo hogar por instalación; no hay usuarios ni cuentas.

# 9. FORMATO Y LOCALIZACIÓN

- Locale: `es_CO`.
- Moneda: peso colombiano (COP), símbolo `$`, separador de miles punto, decimales con coma. Ejemplo: **“$ 1.234.567”**.
- Los totales de factura se muestran en pesos enteros; los valores unitarios conservan decimales.
- Fechas:
  - En listas: **“29 nov”**.
  - En campos: **“29 noviembre 2026”**.
  - En gráfica: **“noviembre 2026”**.
- Unidades: **kWh**, **m³**, **kg**. No uses “m3” ni “KWH”.
- Todos los textos visibles en español. No uses inglés ni lorem ipsum.

# 10. ESTADOS DE UI

Toda pantalla con datos debe tener cuatro estados explícitos:
1. **Cargando**: spinner o esqueleto.
2. **Vacío**: título, explicación y acción.
3. **Con datos**: contenido real.
4. **Error**: qué pasó y botón **“Reintentar”**.

Estados especiales:
- **Aviso**: lectura menor que la anterior.
- **Foto no disponible**.
- **Consumo negativo**.
- **Servicio inactivo**.
- **Una sola lectura** (no es una gráfica vacía).

# 11. ACCESIBILIDAD Y RESPONSIVE

- Área táctil mínima de 48 dp.
- Etiquetas `Semantics` en iconos y miniaturas: “Con número de contrato”, “Con foto del medidor”, “Desactivar”, “Reactivar”, “Ver foto”.
- Contraste AA en texto y fondos.
- Soporta escalado de texto del sistema; nada se desborda.
- No dependas solo del color: usa signos `+` / `−` y texto.
- Respeta `MediaQuery.disableAnimations`.
- En pantallas anchas, limita el contenido a 600–720 dp y usa dos columnas para tarjetas.
- En móvil, una columna y scroll.

# 12. DATOS DE EJEMPLO PARA EL PROTOTIPO

Usa estos datos realistas en las pantallas con contenido. Mes actual: **noviembre 2026**.

## Luz (kWh, contrato 12345-2026, activa)

Lectura anterior (31 oct): 44.842 kWh.

| Fecha | Lectura | Consumo |
|---|---:|---:|
| 1 nov | 44.850 | 8 |
| 5 nov | 44.892 | 42 |
| 9 nov | 44.935 | 43 |
| 13 nov | 44.978 | 43 |
| 17 nov | 45.020 | 42 |
| 21 nov | 45.063 | 43 |
| 25 nov | 45.106 | 43 |
| 29 nov | 45.151 | 45 |

- Total del mes: **309 kWh**.
- Mes anterior: **287 kWh**.
- Variación: **+7,7 %**.
- Promedio diario: **10,66 kWh**.
- Día de mayor consumo: **45 kWh · 29 nov**.
- Foto en la lectura del 29 nov.
- Lectura reemplazada: 13 nov, 44.970 kWh (reemplazada por 44.978).

## Agua (m³, contrato 88421, activa)

| Fecha | Lectura | Consumo |
|---|---:|---:|
| 1 nov | 1.240 | 2 |
| 6 nov | 1.244 | 4 |
| 12 nov | 1.249 | 5 |
| 18 nov | 1.253 | 4 |
| 24 nov | 1.258 | 5 |
| 29 nov | 1.262 | 4 |

- Total del mes: **24 m³**.
- Mes anterior: **22 m³**.
- Variación: **+9,1 %**.
- Promedio diario: **0,83 m³**.
- Día de mayor consumo: **5 m³ · 12 nov**.

## Gas (m³, sin contrato, activo)

| Fecha | Lectura | Consumo |
|---|---:|---:|
| 2 nov | 3.415 | 5 |
| 9 nov | 3.421 | 6 |
| 16 nov | 3.427 | 6 |
| 23 nov | 3.433 | 6 |
| 29 nov | 3.438 | 5 |

- Total del mes: **28 m³**.
- Mes anterior: **30 m³**.
- Variación: **−6,7 %**.
- Promedio diario: **0,97 m³**.
- Día de mayor consumo: **6 m³ · 9 nov**.

## Gas pipeta (kg, inactivo)

- Sin lecturas.
- Aparece en la lista con la etiqueta **“Inactivo”** y el toggle apagado.

# 13. LO QUE NO DEBES HACER

- No agregues login, registro, onboarding de carrusel, paywall ni suscripción.
- No agregues backend, nube, sincronización, notificaciones push ni llamadas de red.
- No agregues publicidad, analítica, SDKs de terceros ni rastreo.
- No agregues botones de eliminar, swipe-to-delete ni “borrar todo”.
- No permitas editar ni borrar lecturas.
- No sobrescribas fotos.
- No inventes una barra de navegación inferior si no está en el mapa.
- No uses inglés, lorem ipsum ni textos genéricos.
- No uses gráficas de líneas suaves: el consumo diario se muestra con barras.
- No ocultes un consumo negativo: muéstralo con un aviso claro.
- No conviertas la app en un dashboard financiero.

# 14. ENTREGABLES

## Si generas un prototipo visual

- Todas las pantallas del mapa, conectadas y navegables.
- Versión clara y oscura de al menos: Mis servicios, Mediciones, Consumo.
- Incluye estados vacíos, cargando, error y aviso.
- Datos de ejemplo realistas de la sección 12.
- Textos en español de Colombia.
- Formato de teléfono Android vertical (360 × 800 dp o similar).
- Si la herramienta lo permite, exporta también una vista general de todas las pantallas.

## Si generas código Flutter

- Proyecto Flutter ejecutable en Android.
- Arquitectura por funcionalidad con MVVM.
- Dominio en Dart puro, sin Flutter, Drift ni `go_router`.
- Persistencia local con Drift; fotos en almacenamiento privado.
- Navegación con `go_router`.
- Estado con Riverpod 3.
- Textos en ARB con `intl`, locale `es_CO`.
- Pruebas de dominio, ViewModel, widgets y goldens.
- Sin advertencias en `dart analyze`; `dart format` y `flutter test` en verde.

# 15. CRITERIOS DE ACEPTACIÓN

1. Se puede crear un servicio en menos de 30 segundos.
2. Se puede registrar una lectura en menos de 20 segundos.
3. La lista muestra nombre, unidad y estado sin abrir el detalle.
4. La unidad no se puede cambiar si hay lecturas.
5. No existe ninguna acción de eliminar.
6. Corregir una lectura conserva la anterior como “Reemplazada”.
7. La foto de una lectura corregida no se pierde.
8. La gráfica muestra una barra por lectura, el promedio y el mes anterior.
9. El total del mes coincide con la diferencia entre la última lectura del mes y la última del mes anterior.
10. La variación se muestra con signo y se omite si no hay comparación.
11. Todo funciona sin conexión.
12. Todos los textos están en español de Colombia.
13. La app se ve coherente en claro y oscuro.
14. Los estados vacíos, de error y de carga están diseñados, no son pantallas en blanco.

# 16. INSTRUCCIÓN FINAL

Genera el prototipo completo siguiendo esta guía. No preguntes por detalles menores: toma decisiones razonables, mantén la coherencia visual y documenta al final los supuestos que hayas tomado. Si el alcance incluye la fase 2, márcala claramente como **“Fase 2”** para no confundirla con lo que ya existe.

<!-- PROMPT: FIN -->

---

# Anexo técnico (solo si vas a generar la app Flutter)

## Stack

- Flutter estable, Dart `^3.13.2`.
- `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`.
- `drift` + `drift_dev` + `build_runner`.
- `go_router`.
- `freezed` + `freezed_annotation`.
- `intl`.
- `decimal`.
- `fl_chart`.
- `image_picker`.
- `path_provider` y `path`.

## Estructura

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   ├── data/                 # AppDatabase
│   └── di/
├── core/
│   ├── error/
│   ├── ui/
│   │   ├── theme/
│   │   └── widgets/
│   └── utils/
├── features/
│   ├── servicios/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   └── mediciones/
│       ├── domain/
│       ├── data/
│       └── presentation/
└── l10n/
```

## Reglas de arquitectura

- `domain/` es Dart puro: no importa Flutter, Drift ni `go_router`.
- `presentation/view/` solo compone; lee proveedores en la pantalla de nivel superior y pasa datos y acciones por parámetro.
- `viewmodel/` no importa Flutter ni usa `BuildContext`.
- `state/` usa `sealed class` para cargando, vacío, datos y error.
- Inyección de dependencias solo con Riverpod.
- Persistencia solo con Drift; migraciones con plan de reversión.
- Fotos en almacenamiento privado, referenciadas por ruta relativa; nunca blobs.
- Nada de `double` para dinero o consumo; usa `decimal`.

## Base de datos actual

- `schemaVersion = 2`.
- Tabla `Servicios`: id, nombre, nombreNormalizado, unidad, etiquetaContrato, activo, creadoEn, actualizadoEn.
- Tabla `Lecturas`: id, servicioId, fecha, valor, rutaFoto, estado, reemplazaA, creadaEn.
- `PRAGMA foreign_keys = ON`.
- Migración 1 → 2: crear `Lecturas`; no tocar `Servicios`.
- Reversión: `DROP TABLE IF EXISTS lecturas;`.

## Puertas de calidad

```bash
dart format --set-exit-if-changed .
dart analyze
flutter test
```

- `dart analyze`, no `flutter analyze` (por `riverpod_lint`).
- Pruebas de dominio para consumo, días y resumen.
- Pruebas de ViewModel sin `WidgetTester`.
- Pruebas de widget y goldens para componentes y pantallas.
- Prueba de pureza del dominio.

## Estado del repositorio

- **001 — Tipos de servicio**: implementada.
- **003 — Mediciones diarias**: implementada.
- **002 — Conceptos de facturación**: solo especificada.
- **004 — Fechas de corte y festivos**: sin especificar.
- **005 — Cálculo de la factura**: sin especificar.
- **006 — Compartir como protesta**: sin especificar.

Si trabajas sobre este repositorio, inspecciona primero el código existente y no reescribas lo que ya funciona. Los commits los hace el usuario; el agente solo deja los cambios en el árbol de trabajo.

---

# Prompt corto (para herramientas con límite de texto)

> Diseña un prototipo móvil Android de “Mi Consumo”, una app offline en español de Colombia para registrar los servicios del hogar (luz en kWh, agua y gas en m³, gas pipeta en kg), anotar la lectura del medidor con foto opcional y ver el consumo mensual en una gráfica de barras comparada con el mes anterior. Estilo Material 3, semilla teal #00695C, claro y oscuro, tranquilo y confiable, con tarjetas, chips y tipografía clara. Pantallas: Mis servicios, Nuevo/Editar servicio, Mediciones, Registrar lectura, Consumo y visor de foto. Incluye estados vacíos, carga y error. Reglas: nada se borra, las lecturas no se editan (corregir es agregar una nueva), la foto nunca se sobrescribe, todo se guarda en el teléfono, sin login ni nube. Usa datos realistas en pesos colombianos y fechas en español. No agregues publicidad, analítica, botones de eliminar ni gamificación.
