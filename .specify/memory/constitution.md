# Constitución de miconsumo

## Principios Fundamentales

### I. Offline-First y Evidencia en el Dispositivo

La aplicación DEBE funcionar por completo sin conexión a red. Los tipos de servicio, las mediciones
de consumo, las fechas de corte y las fotografías de respaldo DEBEN almacenarse en el dispositivo
(Drift para datos estructurados y almacenamiento local para archivos). Ningún dato del hogar PUEDE
salir del dispositivo salvo por una acción de compartir explícita e iniciada por el usuario.

**Justificación**: el valor de la app es servir como evidencia frente a la empresa de servicios.
Depender de un servidor rompería ese propósito y expondría datos sensibles del hogar.

### II. Integridad de la Evidencia (INNEGOCIABLE)

Una medición registrada es inmutable. NUNCA se DEBE editar ni borrar en su lugar: una corrección
DEBE ser un registro nuevo que reemplaza al anterior, conservando la marca de tiempo y los valores
originales. Las fotografías DEBEN referenciarse por un identificador estable y NUNCA sobrescribirse.
Toda medición DEBE registrar fecha de captura, fecha de modificación y origen (captura manual).

**Justificación**: un registro editable no sirve como prueba. La trazabilidad es el producto.

### III. Precisión Numérica y Unidades Explícitas

Los montos monetarios y los valores de consumo NO DEBEN almacenarse como `double`. Se DEBE usar
representación de punto fijo o decimal, y cada servicio DEBE declarar explícitamente su unidad de
medida (kWh para electricidad, m³ para agua y gas natural, kg para gas licuado en pipeta). Las
conversiones y el redondeo DEBEN centralizarse en un único lugar del dominio.

**Justificación**: los errores de coma flotante se acumulan entre períodos de facturación y
debilitan cualquier reclamo.

### IV. Reglas de Dominio Puras y Testeables

El cálculo de fechas de corte —incluido el desfase de 2 a 3 días por los festivos colombianos— y el
cálculo del monto de la factura a partir de sus conceptos DEBEN implementarse como funciones puras en
la capa de dominio, independientes de los widgets de Flutter y de Drift. Cada una DEBE tener pruebas
unitarias que cubran el desfase, los festivos y los conceptos calculados como porcentaje. La interfaz
de usuario NO DEBE calcular estas reglas de forma dispersa.

**Justificación**: son exactamente las reglas que el usuario discute con la empresa proveedora; si
viven en la UI, no pueden verificarse ni auditarse.

### V. Puertas de Calidad (INNEGOCIABLE)

Antes de dar por terminada una funcionalidad DEBEN pasar sin errores: `dart format`, `flutter
analyze` (cero advertencias) y `flutter test`. DEBEN existir pruebas unitarias para toda regla de
dominio y para todo ViewModel con lógica. Las vistas DEBEN cubrirse con pruebas de widget cuando su
comportamiento no sea trivial, y el sistema de diseño DEBE cubrirse con pruebas golden.

**Justificación**: sin una barrera automática, la evidencia y los cálculos del dominio se degradan
sin que nadie lo note.

### VI. Sin Publicidad ni Rastreo

La aplicación NUNCA DEBE incluir SDKs de publicidad ni de analítica de terceros. La monetización SOLO
PUEDE ser por donación voluntaria, y el enlace de donación DEBE vivir fuera de la aplicación (ficha de
la tienda y repositorio). Ningún dato del hogar PUEDE transmitirse durante el flujo de donación. La
aplicación DEBE poder declarar ante la tienda que no recopila datos del usuario.

**Justificación**: la credibilidad de la app depende de que sus datos sean privados y verificables. Un
SDK de terceros accedería a la red y al identificador de publicidad del dispositivo, rompiendo el
Principio I y la confianza que sostiene el propósito de denuncia.

### VII. Vigencia Temporal y Congelamiento

Todo valor sujeto a cambios en el tiempo —precio por unidad, cargo fijo, alumbrado público,
alcantarillado, subsidio o cualquier otro concepto de facturación— DEBE modelarse como eventos
append-only con fecha efectiva. El valor aplicable a una fecha DEBE ser el último evento cuya fecha
efectiva sea menor o igual a esa fecha. NUNCA DEBEN modelarse valores "por año" ni modificarse un
valor en su lugar. Todo período cerrado DEBE congelarse y es inmutable.

**Justificación**: un incremento de tarifa no puede alterar lo ya calculado, y dos incrementos dentro
del mismo año deben poder convivir. Modelar por intervalos deja huecos y solapamientos; modelar por
año impide el segundo incremento. El historial de eventos resuelve ambos casos y, junto con el
congelamiento, protege la evidencia frente a correcciones retroactivas.

## Stack y Arquitectura

- **Plataforma**: Flutter estable y Dart, en las versiones fijadas en `pubspec.yaml`
  (Flutter 3.47.2 / SDK `^3.13.2` al momento de ratificar).
- **Alcance de plataforma**: Android es la única plataforma objetivo en esta etapa. iOS queda fuera
  hasta que exista un entorno de compilación macOS.
- **Patrón de presentación**: MVVM. La presentación de cada funcionalidad se divide en `view/`,
  `viewmodel/` y `state/`. No se DEBE introducir un patrón de presentación alternativo.
- **Estructura**: por funcionalidad, con capa de dominio propia. El arranque vive en `lib/app/`, el
  código compartido en `lib/core/` y cada funcionalidad en `lib/features/<feature>/`:

  ```text
  lib/features/<feature>/
    domain/            # Dart puro: entidades, objetos de valor, contratos de repositorio, reglas
    data/              # Drift, mapeadores e implementaciones de repositorio
    presentation/
      view/            # View
      viewmodel/       # ViewModel
      state/           # estados de UI
  ```

- **Regla de la View**: NUNCA contiene lógica de negocio, cálculos ni acceso a datos. Lee estado con
  `ref.watch` y envía intenciones con `ref.read(...notifier).<metodo>()`. Es la única capa que conoce
  Flutter y `BuildContext`.
- **Regla del ViewModel**: NO DEBE importar Flutter ni usar `BuildContext`. Usa
  `package:riverpod_annotation` y `package:riverpod` —nunca `flutter_riverpod`— de modo que sea
  testeable sin `WidgetTester`. Orquesta las reglas de dominio y expone los estados de UI.
- **Regla del dominio**: `domain/` es Dart puro. NUNCA DEBE importar `package:flutter`,
  `package:drift`, `package:go_router` ni ningún paquete de presentación o persistencia. Una prueba
  DEBE verificar esta regla y fallar si se rompe.
- **Inyección de dependencias**: exclusivamente Riverpod, con `ProviderScope` en el arranque. NO DEBEN
  usarse localizadores de servicio ni singletons globales.
- **Estado**: exclusivamente Riverpod 3. NO se DEBE usar `setState` para lógica de negocio.
- **Persistencia**: exclusivamente Drift. Todo cambio de esquema DEBE incluir una migración y un plan
  de reversión.
- **Navegación**: `go_router`, con las rutas declaradas de forma centralizada.
- **Generación de código**: `build_runner`. Los archivos generados (`*.g.dart`, `*.freezed.dart`) NO
  DEBEN editarse a mano y DEBEN regenerarse en el mismo cambio.
- **Fotografías**: se guardan en almacenamiento privado de la app y se referencian desde la base de
  datos por ruta o identificador, nunca como blobs embebidos.

## Estándares de UI

- **Tema**: Material 3 con `ColorScheme.fromSeed`, con variantes clara y oscura.
- **Tokens de diseño**: espaciados, radios, duraciones y tipografía DEBEN exponerse vía
  `ThemeExtension`. Los widgets NO DEBEN contener números mágicos de estilo.
- **Estados de UI**: cada pantalla DEBE modelar sus estados con `sealed class` (cargando, vacío,
  datos, error) en `presentation/state/`. NUNCA se DEBE inferir el estado con comprobaciones dispersas
  de nulos o booleanos.
- **Accesibilidad**: los elementos interactivos DEBEN exponer etiquetas `Semantics`; el área táctil
  mínima es de 48 dp; la interfaz DEBE soportar el escalado de texto del sistema y mantener contraste
  AA.
- **Responsive**: la adaptación DEBE resolverse con breakpoints (`LayoutBuilder`). NUNCA se DEBEN fijar
  anchos o altos absolutos que se rompan en otra pantalla.
- **Localización**: los textos visibles DEBEN provenir de recursos ARB gestionados con `intl`; el
  locale base es `es_CO`, español de Colombia. NUNCA se DEBEN incrustar cadenas literales en los
  widgets.
- **Moneda y formato numérico**: la moneda es el peso colombiano (COP), con símbolo `$`, punto como
  separador de miles y coma como separador decimal. La moneda y el símbolo DEBEN pasarse SIEMPRE de
  forma explícita a `NumberFormat`, porque `intl` no incluye datos propios para `es_CO` y recurre a
  `es`. Los campos de entrada DEBEN aceptar coma y punto como separador decimal.
- **Redondeo monetario**: los totales de factura DEBEN expresarse en peso entero, pero los valores
  unitarios —precios por unidad, porcentajes y montos de concepto— DEBEN conservar sus decimales. El
  redondeo se aplica UNA sola vez, sobre el total final, y NUNCA antes de multiplicar.
- **Fotografías en listas**: DEBEN mostrarse como miniaturas con `cacheWidth`; NUNCA se DEBE decodificar
  una imagen a resolución completa dentro de una lista.
- **Composición de la interfaz**: toda pantalla DEBE **componer** componentes. NUNCA DEBE construir sus
  partes internamente ni acumular en un solo archivo el estado vacío, las filas y los formularios.
- **Datos y acciones**: SOLO la pantalla de nivel superior lee proveedores con `ref.watch`. Los
  componentes DEBEN recibir sus datos y sus acciones **por parámetro**, de modo que puedan probarse y
  previsualizarse con datos fijos.
- **Ubicación de los componentes**: los propios de una funcionalidad viven en
  `presentation/view/widgets/`; los compartidos entre funcionalidades, en `lib/core/ui/widgets/`.
- **Ciclo de vida de un componente**: empieza como widget **privado** en el archivo que lo usa, y DEBE
  pasar a su propio archivo cuando se reutilice en más de un lugar o deje de ser legible.
- **Componentes de presentación**: los que solo pintan DEBEN ser `StatelessWidget` y NO DEBEN contener
  lógica ni cálculos.
- **Nombres**: los componentes DEBEN nombrarse por lo que representan (`FilaDeServicio`, `EstadoVacio`,
  `SelectorDeUnidad`), nunca por su posición (`WidgetSuperior`, `Item1`).
- **Pruebas de componentes**: los componentes de presentación DEBEN cubrirse con pruebas de widget y,
  cuando su apariencia importe, con pruebas golden.
- **Constructores**: DEBEN preferirse constructores `const` y constructores perezosos
  (`ListView.builder`) para colecciones.
- **Animaciones**: DEBEN preferirse las animaciones implícitas y DEBE respetarse
  `MediaQuery.disableAnimations`.

## Privacidad, Cumplimiento y Publicación

- **Política de privacidad**: DEBE existir con una URL pública accesible antes de publicar, alojada en
  GitHub Pages.
- **Declaración de datos**: la app DEBE poder declarar en la tienda que no recopila datos del usuario.
  Cualquier cambio que rompa esa declaración exige enmendar esta constitución primero.
- **Datos del hogar**: los servicios, las mediciones, los conceptos de facturación, las fotografías y
  la etiqueta de contrato viven únicamente en el dispositivo y NUNCA DEBEN transmitirse a terceros.
- **Marco legal**: aplica la Ley 1581 de 2012 de protección de datos personales de Colombia y su
  autoridad, la Superintendencia de Industria y Comercio. La política de privacidad DEBE estar en
  español e incluir la finalidad, los derechos del titular —conocer, actualizar, rectificar, suprimir
  y revocar— y un canal de contacto. DEBE declarar de forma explícita que el desarrollador no accede a
  los datos del hogar y que, por tanto, no actúa como responsable del tratamiento.
- **Etiqueta de contrato**: es opcional, de texto libre y de uso estrictamente local. Su único fin es
  reforzar la evidencia al compartir.
- **Donaciones**: el enlace vive fuera de la aplicación. NO se DEBE enlazar a pasarelas de pago
  externas desde dentro de la app, porque la política de la tienda exige su propio sistema de pago.
- **Publicación**: antes de publicar DEBEN completarse la ficha de la tienda, la declaración de
  seguridad de datos y la política de privacidad.

## Flujo de Trabajo y Puertas de Calidad

- Se sigue el flujo de Spec-Driven Development: constitución (una vez) → specify → clarify → plan →
  tasks → analyze → implement → converge.
- Cada funcionalidad tiene su propio directorio de especificación y sus artefactos se versionan junto
  con el código.
- Los mensajes de commit siguen la convención de commits convencionales (`feat:`, `fix:`, `docs:`,
  `chore:`).
- Ninguna funcionalidad se integra sin superar las puertas de calidad del Principio V.
- Las especificaciones son el contrato: si el código y la especificación difieren, se resuelve de
  forma explícita y documentada, nunca por deriva silenciosa.

## Governance

Esta constitución prevalece sobre cualquier otra práctica del proyecto.

- **Enmiendas**: todo cambio se documenta en este archivo, se acompaña de un Sync Impact Report y se
  registra en el commit correspondiente.
- **Versionado**: semántico. MAJOR ante eliminación o redefinición de un principio; MINOR al agregar
  un principio o sección; PATCH ante aclaraciones o correcciones de redacción.
- **Cumplimiento**: cada `/speckit.plan` y `/speckit.analyze` DEBE contrastar el plan contra estos
  principios; toda violación DEBE justificarse en la sección de seguimiento de complejidad del plan.
- **Commits**: solo el usuario crea commits. Los agentes de IA DEBEN dejar los cambios en el árbol de
  trabajo y reportar los archivos modificados; NUNCA DEBEN ejecutar `git add`, `git commit` ni
  `git push`.
- **Guía de desarrollo**: esta constitución junto con las especificaciones vigentes. El `README.md` y
  las notas del agente pueden añadir guía no normativa.

**Version**: 2.3.0 | **Ratified**: 2026-10-18 | **Last Amended**: 2026-10-18
