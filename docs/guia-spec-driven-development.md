# Guía de Spec-Driven Development con OpenCode

**Para quién es este documento**: para alguien que nunca ha usado esta metodología. No hace falta saber
nada de antemano. Cada palabra técnica se explica la primera vez que aparece, y todas están reunidas en
el diccionario de la sección 2.

**Qué vas a encontrar**: qué es esto, para qué sirve, cómo se usa, cómo se ve aplicado a un proyecto que
ya existe, y qué errores conviene evitar.

---

## 1. Qué es esto y por qué

### 1.1 La idea, con una analogía

Imagina que quieres construir una casa.

Puedes hacerlo así: llamas a un albañil, le dices "hazme una casa", y él empieza a pegar ladrillos donde
le parece. Al cabo de unas semanas tienes paredes, pero la cocina quedó donde querías el baño, no hay
ventanas en el cuarto principal, y el baño no tiene tubería.

O puedes hacerlo así: primero dibujas **el plano** (qué cuartos quieres y para qué), después el
**presupuesto y los materiales** (cómo se va a construir y con qué), después la **lista de trabajo**
(primero los cimientos, luego las paredes, luego el techo), y solo entonces empiezas a pegar ladrillos.

**Spec-Driven Development** (desarrollo guiado por especificaciones) es la segunda forma de trabajar,
pero aplicada al software. Es una manera de trabajar, no un programa ni una marca.

### 1.2 Por qué esto importa cuando trabajas con una IA

Cuando le pides código a una IA sin estructura, pasa algo parecido al albañil sin plano: te escribe
archivos al primer mensaje, con decisiones que tú no aprobaste. A veces acierta. Cuando no acierta, ya
escribió doscientos archivos y deshacerlo es más caro que hacerlo bien.

Con esta metodología, la IA **no puede** escribir código hasta que existan tres documentos aprobados por
ti:

1. Qué quieres y para qué.
2. Cómo se va a construir.
3. La lista de tareas concretas.

Y si algo estaba mal planteado, se descubre **en el papel**, donde corregirlo cuesta dos líneas, y no en
el código, donde cuesta una tarde.

### 1.3 Qué NO es esto

Conviene aclararlo, porque hay mucha confusión:

- **No es una herramienta que te hace la aplicación sola.** Es una forma de ordenar el trabajo. La IA
  sigue escribiendo el código, pero con instrucciones claras y aprobadas.
- **No es solo para proyectos nuevos.** Funciona igual en un proyecto que llevas años manteniendo. La
  sección 6 está dedicada justo a eso.
- **No hace falta usarlo con todos los comandos.** Se puede usar un subconjunto. La metodología es
  flexible.
- **No es una marca ni un producto.** Es una forma de trabajar. Existen herramientas que la facilitan
  (Spec Kit, OpenSpec, Kiro), y aquí usamos **Spec Kit**, que es de GitHub y es gratis.

---

## 2. Diccionario

Esta sección existe para que puedas volver a ella. No hace falta memorizar nada.

### 2.1 De la metodología

| Término | Qué significa, en palabras normales |
|---|---|
| **Spec-Driven Development (SDD)** | Desarrollo guiado por especificaciones. Acordar qué se va a construir antes de construirlo. |
| **Especificación** (o **spec**) | El documento que dice **qué** quieres y **para qué**, en palabras normales, sin detalles técnicos. Se escribe para que lo entienda alguien que no programa. |
| **Plan** | El documento que dice **cómo** se va a construir: con qué herramientas, en qué archivos, con qué estructura. Es el documento técnico. |
| **Tareas** (o **tasks**) | La lista numerada de trabajos concretos, en orden de ejecución. Cada tarea dice qué archivo toca. |
| **Constitución** | Las reglas permanentes del proyecto. Cosas como "nunca se borran datos" o "todo se guarda en el teléfono". Se escribe una vez y vale para siempre. |
| **Artefacto** | Cualquier documento que produce el proceso: la especificación, el plan, la lista de tareas, la constitución. |
| **Funcionalidad** (o **feature**) | Una cosa concreta que la aplicación hace. "Registrar tipos de servicio" es una funcionalidad. "Compartir en redes" es otra. |
| **Compuerta** (o **gate**) | Un punto de parada donde alguien revisa antes de seguir. Sirve para no avanzar sobre algo mal planteado. |
| **Converger** | Buscar lo que quedó faltando respecto a lo acordado, y añadirlo a la lista de tareas. |
| **Brownfield** | Proyecto que ya existe y lleva tiempo en uso. Literalmente "campo ya trabajado". |
| **Greenfield** | Proyecto nuevo, desde cero. "Campo virgen". |
| **MVP** | *Minimum Viable Product*, producto mínimo viable. La versión más pequeña que ya sirve para algo. Se hace primero lo que aporta valor solo. |
| **Deuda técnica** | Trabajo pendiente que se acumuló por hacer las cosas rápido. |
| **Refactorizar** | Reorganizar el código sin cambiar lo que hace. |
| **Regresión** | Un error que aparece en algo que antes funcionaba. |

### 2.2 De Spec Kit y OpenCode

| Término | Qué significa |
|---|---|
| **Spec Kit** | La herramienta de GitHub que implementa esta metodología. Es gratis y de código abierto. |
| **Comando** | Una instrucción que escribes en el chat de OpenCode empezando con `/`. Por ejemplo `/speckit.specify`. |
| **Integración** | La pieza que conecta Spec Kit con el agente que uses. Aquí es `opencode`, porque es el agente con el que trabajas. |
| **Extensión** | Un añadido que le da una capacidad extra a Spec Kit. Por ejemplo, la extensión `git` automatiza ramas. **Aquí no la usamos.** |
| **Preset** | Un conjunto de plantillas adaptadas a un tipo de proyecto o de organización. |
| **Hook** | Un gancho que se dispara antes o después de un comando. Aquí no hay ninguno configurado. |
| **Sync Impact Report** | Un pequeño informe que acompaña a cada cambio de la constitución, explicando qué cambió y por qué. Es material temporal: se lee y se retira. |
| **Plantilla** | Un documento de ejemplo con huecos, que el agente rellena. |
| **Agente** | La IA que ejecuta el trabajo. En este proyecto, OpenCode. |

### 2.3 De arquitectura (lo que aparece en el código de este proyecto)

| Término | Qué significa |
|---|---|
| **MVVM** | *Model-View-ViewModel*. Una forma de organizar el código en tres partes: lo que se ve, lo que decide, y los datos. Se explica en la sección 4.3. |
| **View** (vista) | La parte que se ve en la pantalla. Solo dibuja. No decide nada. |
| **ViewModel** | La parte que decide. Recibe lo que el usuario hace, consulta los datos, y le dice a la vista qué mostrar. No sabe nada de pantallas. |
| **Dominio** | Las reglas del negocio, escritas sin depender de ninguna herramienta. "El consumo se calcula así", "no se puede cambiar la unidad si hay historial". Es la parte más valiosa y la más fácil de probar. |
| **Entidad** | Un objeto con identidad propia. "El servicio de agua" es una entidad. |
| **Objeto de valor** | Un objeto que se define por su valor, no por su identidad. "La unidad kWh" es un objeto de valor: no importa cuál sea, importa qué es. |
| **Repositorio** (patrón) | La pieza que sabe leer y guardar datos. El resto del código le pide cosas sin saber si los datos están en una base de datos, en un archivo o en otro sitio. |
| **Capa** | Un nivel de organización del código. Aquí hay tres: dominio, datos y presentación. |
| **Migración** | Un cambio en la estructura de la base de datos, con su forma de deshacerlo. Necesario cuando añades una columna nueva sin perder lo que había. |
| **Esquema** | La forma que tiene la base de datos: qué tablas hay y qué columnas tiene cada una. |
| **Generación de código** (codegen) | Escribir código automáticamente a partir de otro código. Ahorra mucho trabajo repetitivo. |
| **Drift** | La herramienta que este proyecto usa para guardar datos en el teléfono. |
| **Riverpod** | La herramienta que este proyecto usa para manejar el estado y conectar las piezas. |
| **go_router** | La herramienta que maneja la navegación entre pantallas. |
| **Token de diseño** | Un valor reutilizable de estilo: cuánto espacio, qué radio, qué duración de animación. Se definen una vez y se usan en todas partes. |

### 2.4 De calidad

| Término | Qué significa |
|---|---|
| **Prueba** (o **test**) | Un programa pequeño que verifica que otra parte del código hace lo que debe. |
| **Prueba unitaria** | Prueba una pieza pequeña y aislada. Por ejemplo: "¿el nombre 'Agua' y 'agua' se consideran iguales?". |
| **Prueba de widget** | Prueba que una parte de la pantalla se dibuja y responde como debe. |
| **Prueba golden** | Compara una pantalla contra una imagen guardada. Si cambia un pixel, avisa. Sirve para detectar cambios visuales sin querer. |
| **Lint** | Un revisor automático de estilo. Avisa de cosas como "esta variable no se usa" o "falta una coma". |
| **Puerta de calidad** | Un conjunto de comprobaciones que deben pasar antes de dar algo por terminado. |
| **Regresión** | Un error nuevo en algo que ya funcionaba. |
| **`dart analyze`** | El comando que corre el revisor automático y reporta problemas. **Es el que usamos**, porque `flutter analyze` no ejecuta los plugins del analizador (entre ellos el de Riverpod). |
| **`flutter analyze`** | Parecido al anterior, pero no ejecuta los plugins. Por eso no lo usamos como puerta de calidad. |
| **`flutter test`** | El comando que corre todas las pruebas. |
| **`dart format`** | El comando que ordena el formato del código automáticamente. |

### 2.5 Lo específico de esta aplicación

| Término | Qué significa |
|---|---|
| **Locale** | El idioma y la región. Aquí `es_CO`: español de Colombia. Afecta a cómo se escriben las fechas y los números. |
| **COP** | Peso colombiano. En Colombia los precios se escriben con punto para los miles y sin centavos: `$ 1.234.567`. |
| **ARB** | El formato de archivo donde se guardan los textos de la aplicación, para que no estén sueltos por el código. |
| **Vigencia temporal** | Que un valor cambia con el tiempo. El precio del m³ hoy es uno y en marzo será otro. Se resuelve guardando cada cambio con su fecha. |
| **Evento append-only** | Una forma de guardar que consiste en **añadir** registros y nunca modificar los que ya están. Si te equivocaste, añades uno nuevo que corrige. Así nunca se pierde la historia. |
| **Congelamiento** | Cuando un período se cierra, su resultado se guarda tal cual y ya no se recalcula. Así un cambio posterior no altera lo que ya revisaste. |
| **Festivos** | Los días festivos de Colombia. Importan porque las fechas de corte de los servicios se corren dos o tres días cuando caen en festivo. |

---

## 3. El flujo completo, paso a paso

### 3.1 El diagrama

```text
                    ┌──────────────────────────────┐
                    │  1. CONSTITUCIÓN             │
                    │  Una vez por proyecto        │
                    │  Las reglas de la casa       │
                    └──────────────┬───────────────┘
                                   │
        ┌──────────────────────────▼──────────────────────────┐
        │  POR CADA FUNCIONALIDAD (una funcionalidad = 1 ciclo)│
        └──────────────────────────┬──────────────────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  2. SPECIFY                  │
                    │  Qué quieres y para qué      │
                    │  → spec.md                   │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  3. CLARIFY  (opcional)      │
                    │  Preguntas para cerrar huecos│
                    └──────────────┬───────────────┘
                                   │
                        ══════ COMPUERTA: revisas la spec ══════
                                   │
                    ┌──────────────▼───────────────┐
                    │  4. PLAN                     │
                    │  Cómo se construye           │
                    │  → plan.md + otros           │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  5. TASKS                    │
                    │  Lista de tareas numeradas   │
                    │  → tasks.md                  │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  6. ANALYZE  (opcional)      │
                    │  ¿Se contradicen los docs?   │
                    └──────────────┬───────────────┘
                                   │
                        ══════ COMPUERTA: revisas el plan ══════
                                   │
                    ┌──────────────▼───────────────┐
                    │  7. IMPLEMENT                │
                    │  ← AQUÍ SE ESCRIBE CÓDIGO    │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  8. CONVERGE                 │
                    │  ¿Qué quedó faltando?        │
                    └──────────────┬───────────────┘
                                   │
                    ¿Faltó algo? ──┴── No → FUNCIONALIDAD TERMINADA
                         │
                         └──────► volver al paso 7
```

### 3.2 Los comandos, uno por uno

Estos comandos se escriben en el chat de OpenCode, empezando con `/`. Nota: se escriben con **punto**,
no con guion (`/speckit.specify`, no `/speckit-specify`). Es la forma que usa OpenCode.

| Comando | Cuándo se usa | Qué produce | ¿Escribe código? |
|---|---|---|---|
| `/speckit.constitution` | Una vez por proyecto, o cuando cambian las reglas de fondo | `constitution.md` | No |
| `/speckit.specify` | Al empezar una funcionalidad | `spec.md` | No |
| `/speckit.clarify` | Si la especificación dejó dudas | Actualiza `spec.md` | No |
| `/speckit.plan` | Con la especificación ya revisada | `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` | No |
| `/speckit.tasks` | Con el plan ya revisado | `tasks.md` | No |
| `/speckit.checklist` | Opcional, para generar listas de control de calidad | Un checklist | No |
| `/speckit.analyze` | Opcional, antes de implementar | Un informe de coherencia | No |
| `/speckit.implement` | Con las tareas aprobadas | **Código de verdad** | **Sí** |
| `/speckit.converge` | Después de implementar | Añade tareas que faltaron | No |

**Regla de oro**: repetir **implement → converge** hasta que converger diga que ya no falta nada.

### 3.3 Qué produce cada comando, con nombres de archivo

Cada funcionalidad vive en su propia carpeta dentro de `specs/`, numerada:

```text
specs/001-tipos-de-servicio/
├── spec.md              ← qué y para qué        (paso 2)
├── plan.md              ← cómo se construye     (paso 4)
├── research.md          ← decisiones técnicas   (paso 4)
├── data-model.md        ← qué datos se guardan  (paso 4)
├── quickstart.md        ← cómo se valida        (paso 4)
├── contracts/           ← acuerdos de interfaz  (paso 4)
├── checklists/          ← listas de control     (paso 2 y 6)
└── tasks.md             ← lista de tareas       (paso 5)
```

### 3.4 Las compuertas de revisión

Una **compuerta** es un punto donde paras y revisas. No es burocracia: es lo que evita construir sobre
un malentendido.

- **Antes del plan**: lee la especificación. ¿Es lo que querías? Si no, se corrige ahora, que es gratis.
- **Antes de implementar**: lee el plan y las tareas. ¿La forma de construirlo te convence? ¿Falta algo?

Si algo no te gusta, se corrige el documento y se sigue. **No se corrige después, en el código.**

### 3.5 Cómo se invoca, en la práctica

Tú escribes en el chat de OpenCode algo como:

```text
/speckit.specify Quiero que el usuario pueda registrar los servicios de su casa
```

El agente lee las instrucciones del comando y hace el trabajo: crea la carpeta, escribe la
especificación, y te avisa. Luego revisas, y si está bien, sigues con el siguiente comando.

También puedes pedírselo con palabras normales ("especifica esta funcionalidad") y el agente seguirá el
mismo proceso, pero escribir el comando es más directo y no deja lugar a dudas.

---

## 4. Tu proyecto en concreto

### 4.1 El mapa de archivos

```text
miconsumo/
│
├── .specify/                        ← LA METODOLOGÍA (no se toca a mano)
│   ├── memory/
│   │   └── constitution.md          ← TUS REGLAS. Sí se edita, pero vía comando
│   ├── templates/                   ← Plantillas base. NO se tocan
│   ├── scripts/                     ← Scripts internos. NO se tocan
│   └── integration.json             ← Estado de la integración. NO se toca
│
├── .opencode/
│   └── commands/                    ← Los comandos /speckit.*  NO se tocan
│
├── specs/                           ← TUS FUNCIONALIDADES
│   ├── 001-tipos-de-servicio/
│   └── 002-conceptos-de-facturacion/
│
├── AGENTS.md                        ← Reglas para los agentes. Sí se edita
├── opencode.json                    ← Permisos de OpenCode. Sí se edita
│
├── lib/                             ← EL CÓDIGO DE LA APP
├── test/                            ← LAS PRUEBAS
├── android/  ios/                   ← Configuración de cada plataforma
└── pubspec.yaml                     ← Dependencias del proyecto
```

### 4.2 Qué se toca y qué no

| Ruta | ¿Se edita? | Por qué |
|---|---|---|
| `.specify/memory/constitution.md` | Sí, pero **con el comando** `/speckit.constitution` | Para que quede registro del cambio |
| `.specify/templates/` | **No** | Son las plantillas de fábrica |
| `.specify/scripts/` | **No** | Son los scripts internos |
| `.opencode/commands/` | **No** | Son los comandos de fábrica |
| `specs/` | Sí, son tus documentos | Es tu trabajo |
| `AGENTS.md` | Sí | Son las reglas para los agentes |
| `opencode.json` | Sí | Son los permisos |
| `lib/`, `test/` | Sí | Es el código |

### 4.3 Cómo está organizado el código

Esta es la parte que más cuesta al principio, así que la explico con una comparación.

Piensa en un restaurante:

- **La View** es el mesero. Toma tu pedido y te trae el plato. No cocina, no decide si hay ingredientes.
  Solo atiende y sirve.
- **El ViewModel** es el jefe de cocina. Recibe el pedido, decide qué hacer, consulta si hay
  ingredientes, y le dice al mesero qué llevarte. No atiende mesas.
- **El Dominio** son las recetas. "La sopa lleva cebolla y papa". No dependen de quién cocine ni de qué
  cocina se use.
- **El Repositorio** es la despensa. El jefe de cocina le pide ingredientes sin saber si están en la
  nevera o en la bodega.

Traducido a carpetas, cada funcionalidad se ve así:

```text
lib/features/servicios/
├── domain/            ← LAS RECETAS: las reglas, sin depender de nada
│   ├── entities/      ← Las cosas: un servicio, un concepto
│   ├── value_objects/ ← Los valores: la unidad kWh, un nombre
│   ├── repositories/  ← Los acuerdos de la despensa (sin decir dónde está)
│   └── usecases/      ← Las reglas concretas
│
├── data/              ← LA DESPENSA: cómo se guardan de verdad
│   ├── local/         ← La base de datos del teléfono
│   ├── mappers/       ← Traductores entre el formato guardado y el del dominio
│   └── repositories/  ← La despensa de verdad
│
└── presentation/      ← EL SALÓN: lo que se ve
    ├── view/          ← El mesero: las pantallas
    ├── viewmodel/     ← El jefe de cocina: las decisiones
    └── state/         ← Los estados posibles: cargando, vacío, con datos, error
```

**Por qué se organiza así**: porque el dominio (las recetas) es lo único que no cambia aunque cambies de
base de datos, de pantalla o de herramienta. Tenerlo aparte significa que se puede probar solo, sin
necesidad de una pantalla ni de una base de datos.

Hay una regla dura en este proyecto: **el dominio no puede importar nada de pantallas ni de base de
datos**. Existe una prueba automática que falla si alguien rompe esa regla.

### 4.4 En qué punto está el proyecto hoy

| Funcionalidad | Estado |
|---|---|
| **001 — Tipos de servicio** | Completa: especificación, plan y **50 tareas** listas |
| **002 — Conceptos de facturación** | Solo la especificación (falta plan y tareas) |
| 003 — Mediciones diarias con foto | Sin empezar |
| 004 — Fechas de corte y festivos | Sin empezar |
| 005 — Cálculo de la factura | Sin empezar |
| 006 — Compartir como protesta | Sin empezar |

**Lo que está decidido y no se va a re-discutir**: la arquitectura MVVM, que se usa Riverpod para el
estado, Drift para los datos, go_router para la navegación; que no habrá publicidad ni rastreo; que la
monetización es solo por donación y fuera de la aplicación; que la app es para Android; y que las
unidades son kWh, m³ y kg.

---

## 5. Cómo trabajamos tú y yo

Estas son las reglas de la casa. Están escritas en `AGENTS.md`, así que los agentes las leen
automáticamente.

### 5.1 Los commits los haces tú

**Ningún agente ejecuta `git commit`, `git add` ni `git push`.** Nunca. Los agentes dejan los cambios en
los archivos y te reportan qué tocaron. Tú revisas y commiteas cuando quieras.

**Por qué**: para que puedas ver exactamente qué cambió antes de que quede en el historial. Si algo
salió mal, deshacerlo es trivial.

Esto está protegido de dos formas:

1. `AGENTS.md` se lo prohíbe al agente.
2. `opencode.json` bloquea el comando a nivel de permisos.

### 5.2 Las compuertas se respetan

Antes de pasar al código, revisas la especificación y el plan. Si algo no te gusta, se corrige el
documento. Corregir un documento cuesta minutos; corregir código cuesta horas.

### 5.3 El agente reporta

Al terminar cualquier trabajo, el agente te dice:

- Qué archivos tocó.
- Qué decidió y por qué.
- Qué quedó pendiente.

### 5.4 Cómo pedir las cosas

| Si quieres… | Pide… |
|---|---|
| Una funcionalidad nueva | `/speckit.specify` seguido de la descripción |
| Cambiar una regla permanente | `/speckit.constitution` |
| Ver el plan antes de codificar | `/speckit.plan` |
| Escribir el código | `/speckit.implement` |
| Saber qué falta | `/speckit.converge` |

---

## 6. Usarlo en un proyecto que ya existe

Esta sección es para cuando quieras aplicar esto a un proyecto de Laravel, de Node, o a cualquier cosa
que ya lleva años funcionando.

### 6.1 El error que hay que evitar

Cuando uno descubre esta metodología, la primera reacción es: *"voy a documentar todo mi sistema"*.

**No lo hagas.** Es la forma más segura de abandonar la metodología antes de terminar. Un sistema de
cinco años tiene cientos de decisiones; especificarlas todas es un trabajo de meses que nadie lee
después.

> **La regla**: se documenta **el cambio que vas a hacer**, no el sistema que ya existe. Tu código actual
> es el *contexto* que el agente lee para no romper nada, no el objeto de la especificación.

### 6.2 Los cinco pasos

**Paso 1 — Prepara un punto de partida limpio**

Antes de tocar nada, asegúrate de que todo tu trabajo está guardado en Git y que no hay cambios sin
commitear. Así, cuando la herramienta añada sus carpetas, verás claramente qué se añadió.

**Paso 2 — Inicializa sobre el repositorio**

```bash
specify init --here --force --integration opencode
```

- `--here` significa "en esta carpeta".
- `--force` significa "sí, ya hay archivos aquí, hazlo igual".

Esto **no toca tu código**. Solo añade `.specify/`, `.opencode/commands/` y un par de archivos de
configuración. Revisa el resultado en Git antes de seguir.

**Paso 3 — Escribe la constitución con lo que YA es cierto**

Este es el paso más valioso y el más incomprendido.

La constitución no es una lista de deseos. Es **lo que tu equipo ya hace**, escrito. Preguntas para
guiarte:

- ¿Cómo se corren las pruebas? ¿Todas deben pasar antes de subir algo?
- ¿Hay convenciones de nombres que todo el mundo sigue?
- ¿Las migraciones de base de datos necesitan plan de reversión?
- ¿Qué cosas nunca se hacen, y por qué? (por ejemplo: "nunca tocamos la tabla de facturas")
- ¿Qué decisiones se tomaron en el pasado que un recién llegado no entendería?

Eso es lo que va ahí. Es el conocimiento que hoy vive en la cabeza de la gente.

**Paso 4 — Elige un cambio pequeño y reversible**

No empieces con "migrar el sistema a otra arquitectura". Empieza con algo que puedas terminar en pocos
días y que, si sale mal, puedas deshacer sin drama. Algo así como:

- Añadir un filtro a un listado que ya existe.
- Añadir una exportación a CSV.
- Cambiar el formato de un correo.
- Añadir un campo opcional a un formulario.

**Paso 5 — Especifica el cambio, y haz que el plan respete lo que ya hay**

Aquí está la diferencia clave con un proyecto nuevo: en un proyecto nuevo, el plan propone la
arquitectura. En uno que ya existe, **el plan debe adaptarse a la arquitectura que ya tienes**. Si tu
proyecto Laravel usa servicios y repositorios, el plan no debe inventar otra cosa.

### 6.3 Ejemplo completo en Laravel

Imagina una tienda en línea hecha en Laravel, con cinco años en producción. Quieres añadir algo. Veamos
cómo se vería el ciclo.

#### El cambio elegido

> *"Quiero que se pueda exportar a CSV el listado de pedidos que está viendo el usuario."*

Es pequeño, es reversible, y aporta valor de inmediato. Buen primer intento.

#### Paso 3: la constitución (fragmento)

Observa que cada regla sale de algo que **ya es cierto** en el proyecto:

```markdown
## Principios del proyecto

### I. Compatibilidad hacia atrás

Las rutas públicas de la API NUNCA DEBEN cambiar de forma incompatible. Si un cambio
rompe el contrato, DEBE publicarse una versión nueva y mantener la anterior durante
al menos seis meses.

**Justificación**: hay clientes móviles antiguos que no se pueden actualizar.

### II. Toda migración incluye su reversión

Ninguna migración de base de datos se aprueba sin su método `down()` probado.

**Justificación**: en 2023 un despliegue sin reversión tumbó el servicio seis horas.

### III. Los permisos se declaran, no se comprueban a mano

Toda acción sobre un recurso DEBE pasar por una Policy de Laravel. NUNCA se comprueba
un permiso con un `if` suelto en un controlador.

**Justificación**: fue la causa de una fuga de datos entre clientes.

### IV. Pruebas obligatorias

Toda funcionalidad nueva DEBE traer pruebas de la capa de dominio y de los
controladores. El código antiguo sin pruebas no se toca; solo se exige para lo nuevo.
```

Ese último punto es importante: **no exijas pruebas del código viejo**. Solo del nuevo. Si no, el
primer cambio se convierte en tres meses de trabajo.

#### Paso 2: la especificación (`spec.md`)

Fíjate: está escrita **sin una sola palabra de Laravel**. Nada de controladores, rutas ni bases de
datos. Solo lo que el usuario obtiene.

```markdown
# Especificación: Exportar el listado de pedidos

## Historia de usuario

Como encargado de la tienda, quiero descargar en un archivo los pedidos que estoy
viendo en pantalla, para enviárselos a mi contador sin tener que copiarlos a mano.

## Escenarios de aceptación

1. Dado un usuario viendo el listado de pedidos con un filtro de fecha aplicado,
   cuando pulsa "Exportar", entonces descarga un archivo con exactamente esos
   pedidos, no con todos.

2. Dado un usuario sin permiso para ver pedidos, cuando intenta exportar,
   entonces el sistema le niega la operación.

3. Dado un listado con 5000 pedidos, cuando el usuario exporta, entonces la
   aplicación no se queda congelada.

## Requisitos

- FR-001: la exportación DEBE incluir exactamente los pedidos que el usuario ve,
  respetando los filtros activos.
- FR-002: la exportación DEBE respetar los mismos permisos que el listado.
- FR-003: el archivo DEBE poder abrirse en una hoja de cálculo.
- FR-004: la respuesta JSON del listado NO DEBE cambiar.

## Fuera de alcance

- Exportar a PDF.
- Enviar el archivo por correo.
- Programar exportaciones automáticas.
```

Los requisitos **no dicen cómo**. Dicen qué. Esa separación es lo que hace que la especificación sirva
para discutir con alguien que no programa.

#### Paso 4: el plan (`plan.md`)

Aquí sí aparece Laravel, y **respeta lo que ya existe**:

```markdown
## Contexto técnico

- Lenguaje: PHP 8.3 sobre Laravel 11
- Autorización: Policies existentes (Principio III)
- Pruebas: PHPUnit, siguiendo la convención de tests/Feature y tests/Unit
- Generación del archivo: streaming, para no cargar 5000 pedidos en memoria

## Verificación de la constitución

| Principio | Cómo se cumple |
|---|---|
| I. Compatibilidad | No se toca la respuesta JSON del listado (FR-004) |
| II. Migraciones | No hay migración: la funcionalidad no cambia el esquema |
| III. Permisos | Se reutiliza la Policy de pedidos, sin comprobaciones sueltas |
| IV. Pruebas | Se añaden pruebas de la exportación y del caso sin permiso |

## Estructura

app/
├── Http/Controllers/PedidoExportController.php   ← Controlador nuevo
└── Exports/PedidosExport.php                     ← Generación del CSV

routes/web.php                                    ← Una ruta nueva
tests/Feature/PedidoExportTest.php                ← Pruebas
```

Y en la sección de seguimiento de complejidad, algo que en un proyecto real aparece mucho:

```markdown
| Desviación | Por qué es necesaria | Alternativa descartada |
|---|---|---|
| Añadir un paquete nuevo para el CSV | El paquete que ya usamos no soporta streaming | Escribir el CSV a mano: más código y más propenso a errores |
```

Ese cuadro es importante: si el plan **se desvía** de la constitución, tiene que **justificarlo por
escrito**. Así las excepciones son decisiones conscientes, no accidentes.

#### Paso 5: las tareas (`tasks.md`)

```markdown
- [ ] T001 Crear la ruta de exportación en routes/web.php
- [ ] T002 [P] Escribir la prueba del caso sin permiso en tests/Feature/PedidoExportTest.php
- [ ] T003 [P] Escribir la prueba de la exportación con filtros aplicados
- [ ] T004 Crear app/Exports/PedidosExport.php con generación en streaming
- [ ] T005 Crear app/Http/Controllers/PedidoExportController.php usando la Policy existente
- [ ] T006 Añadir el botón "Exportar" en la vista del listado
- [ ] T007 Verificar que la respuesta JSON del listado no cambió (FR-004)
- [ ] T008 Ejecutar las pruebas y confirmar que todas pasan
```

La `[P]` significa "esta tarea se puede hacer en paralelo con otras, porque toca archivos distintos".

#### Lo que acabas de ver

- La especificación no menciona Laravel. Habla de lo que el usuario obtiene.
- El plan sí menciona Laravel, y **respeta** lo que ya existe.
- Las tareas son concretas y dicen el archivo exacto.
- La constitución capturó tres decisiones que ya eran ciertas y que un agente nuevo habría ignorado.

### 6.4 Diferencias frente a un proyecto nuevo

| Aspecto | Proyecto nuevo | Proyecto que ya existe |
|---|---|---|
| Constitución | Se escribe desde cero | Se escribe **describiendo lo que ya se hace** |
| Arquitectura | El plan la propone | El plan **se adapta** a la que hay |
| Primera funcionalidad | Puede ser grande | Debe ser **pequeña y reversible** |
| Pruebas | Desde el primer día | Solo del código nuevo |
| Migraciones | Se crean desde cero | Hay que **revisar las que ya existen** |
| Riesgo principal | Elegir mal la arquitectura | Romper algo que funciona |
| Documentación | Se escribe todo | Se escribe **solo el cambio** |

### 6.5 Un caso especial: el proyecto con Node

Si tu proyecto es Node en vez de Laravel, los pasos son idénticos. Solo cambian los detalles:

- La constitución capturará convenciones como "usamos TypeScript estricto" o "nunca se sube código sin
  pasar ESLint".
- El plan respetará tu estructura existente (¿usas capas? ¿usas controladores y servicios?).
- Las tareas hablarán de tus archivos reales.
- Si tienes pruebas con Jest, Vitest o Mocha, eso va en la constitución y el plan las respetará.

La metodología es la misma. Lo que cambia es el contenido, no el proceso.

---

## 7. Errores comunes y cómo evitarlos

### 7.1 Saltarse la constitución

**Qué pasa**: el agente no sabe que en tu proyecto hay reglas, y las rompe. Te das cuenta tres semanas
después.

**Cómo evitarlo**: la constitución es el primer paso, no el último. Cuesta una hora y ahorra semanas.

### 7.2 Hacer una especificación gigante

**Qué pasa**: intentas especificar una funcionalidad de dos meses en un documento. Nadie lo lee, nadie lo
revisa, y para cuando terminas ya cambió todo.

**Cómo evitarlo**: si tu especificación tiene más de dos páginas, probablemente son varias
funcionalidades. Sepáralas.

### 7.3 Confundir la especificación con el plan

**Qué pasa**: metes detalles técnicos en la especificación ("usar un índice en la columna X"), y entonces
el documento ya no sirve para discutir con alguien que no programa.

**Cómo evitarlo**: la especificación habla de lo que el usuario obtiene. El plan habla de cómo. Si en la
especificación aparece el nombre de una herramienta, algo se coló.

### 7.4 Escribir la especificación después del código

**Qué pasa**: se convierte en un trámite. Documentas lo que ya hiciste, y entonces no sirve para
prevenir nada.

**Cómo evitarlo**: la especificación es lo primero. Si ya escribiste el código, no la escribas después:
asume que fue un prototipo y empieza el ciclo bien.

### 7.5 Documentar todo el sistema que ya existe

**Qué pasa**: te agobias, lo abandonas.

**Cómo evitarlo**: solo se documenta el cambio. Ver la sección 6.1.

### 7.6 Dejar que el agente commitee

**Qué pasa**: el historial se llena de commits que no revisaste, y cuando algo sale mal no sabes qué
deshacer.

**Cómo evitarlo**: en este proyecto está bloqueado. Tú commiteas, siempre.

### 7.7 Meter varias funcionalidades en un ciclo

**Qué pasa**: el plan se vuelve inmanejable y las tareas se pisan entre sí.

**Cómo evitarlo**: una funcionalidad, un ciclo. Si se te ocurre otra cosa a mitad, la anotas y la haces
después.

---

## 8. Preguntas frecuentes

**¿Tengo que usar todos los comandos?**
No. El mínimo es: constitución (una vez), specify, plan, tasks e implement. Los demás son opcionales y
sirven para casos concretos.

**¿Puedo escribir la especificación yo, a mano?**
Sí. Spec Kit son archivos de texto. Si prefieres escribirla tú, adelante; el agente la leerá igual.

**¿Y si me equivoco en la especificación?**
Se corrige el documento. Es gratis. Ese es justamente el punto: equivocarse en el papel cuesta minutos,
equivocarse en el código cuesta días.

**¿Cuánto tiempo añade esto?**
Al principio, bastante: puede que el doble de tiempo en la primera funcionalidad. A partir de la tercera,
se recupera, porque dejas de rehacer trabajo. Y en proyectos que ya existen, se recupera mucho antes,
porque evitas romper cosas.

**¿Sirve para proyectos pequeños?**
Sí, con menos ceremonia. En un proyecto de una sola pantalla, la constitución puede tener tres reglas y
la especificación media página.

**¿Qué pasa si el agente se desvía de lo acordado?**
Para eso están `/speckit.analyze` (compara los documentos entre sí) y `/speckit.converge` (busca lo que
falta respecto a lo acordado). Y si algo se coló, se ve en tu revisión del código antes de commitear.

**¿Puedo usar esto con otro agente, como Claude o Copilot?**
Sí. Spec Kit es independiente del agente. De hecho, aquí usamos la integración de OpenCode, pero se
puede cambiar con `specify integration switch`.

**¿Qué pasa si quiero cambiar una regla de la constitución?**
Se usa `/speckit.constitution` de nuevo. El cambio queda documentado con su versión y su justificación.

**¿Esto reemplaza a Git?**
No, se apoya en Git. Pero no lo automatiza: aquí los commits los haces tú.

**¿Qué es eso de que la constitución tiene "versión"?**
Igual que el software: si cambias algo que rompe lo anterior, sube el número grande; si añades algo,
sube el del medio; si solo corriges redacción, sube el último. Sirve para saber cuándo cambió una regla.

**¿Y si el proyecto ya tiene sus propias convenciones y no quiero cambiarlas?**
Perfecto: esas convenciones son exactamente lo que va en la constitución. La constitución sirve para
**preservar** lo que ya funciona, no para cambiarlo.

---

## 9. Chuleta final

### El flujo, en cinco líneas

```text
1. Constitución  →  una vez por proyecto
2. Specify       →  qué quieres y para qué
3. Plan          →  cómo se construye
4. Tasks         →  la lista de tareas
5. Implement     →  el código  (y converge hasta que no falte nada)
```

### Los comandos

```text
/speckit.constitution   las reglas de la casa (una vez)
/speckit.specify        qué y para qué
/speckit.clarify        resolver dudas de la especificación
/speckit.plan           cómo se construye
/speckit.tasks          la lista de tareas
/speckit.analyze        ¿se contradicen los documentos?
/speckit.checklist      listas de control de calidad
/speckit.implement      el código
/speckit.converge       ¿qué faltó?
```

### Las tres reglas que no se negocian

```text
1. Los commits los haces tú. Siempre.
2. Nada de código antes de tener especificación y plan aprobados.
3. La especificación dice QUÉ. El plan dice CÓMO. No se mezclan.
```

### Los tres archivos que vas a mirar

```text
.specify/memory/constitution.md    las reglas permanentes
specs/NNN-nombre/spec.md           qué se va a construir
specs/NNN-nombre/tasks.md          qué falta por hacer
```

### Para un proyecto que ya existe

```text
1. Git limpio antes de empezar
2. specify init --here --force --integration opencode
3. Constitución con lo que YA se hace
4. Un cambio pequeño y reversible
5. El plan respeta la arquitectura que ya tienes
6. Pruebas del código nuevo, no del viejo
```

### Dónde está este proyecto

```text
✅ 001 Tipos de servicio            especificada + 50 tareas
⚠️ 002 Conceptos de facturación     solo especificada
❌ 003 Mediciones con foto
❌ 004 Fechas de corte y festivos
❌ 005 Cálculo de la factura
❌ 006 Compartir como protesta
```

---

*Documento de referencia del proyecto miconsumo. Si algo de aquí no coincide con lo que hace el
proyecto, gana el proyecto: revisa `.specify/memory/constitution.md` y `AGENTS.md`, que son las fuentes
reales.*
