<!--
Sync Impact Report
- Version change: 1.0.0 → 1.1.0
- Modified principles: ninguna (los principios I–V quedan intactos)
- Added sections: ninguna sección nueva; se añade la regla de gobernanza "Commits"
- Removed sections: ninguna
- Bump rationale: MINOR, conforme a la política de versionado de esta constitución
  ("MINOR al agregar un principio o sección"), porque se incorpora una restricción de
  gobernanza nueva y materialmente vinculante, no una mera aclaración de redacción.
- Follow-up TODOs: ninguno
-->

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
medida (kWh para luz, m³ para agua y gas). Las conversiones y el redondeo DEBEN centralizarse en un
único lugar del dominio.

**Justificación**: los errores de coma flotante se acumulan entre períodos de facturación y
debilitan cualquier reclamo.

### IV. Reglas de Dominio Puras y Testeables

El cálculo de fechas de corte —incluido el desfase de 2 a 3 días por feriados— y la fórmula de
consumo facturable (lectura menos deducciones) DEBEN implementarse como funciones puras en la capa
de dominio, independientes de los widgets de Flutter y de Drift. Cada una DEBE tener pruebas
unitarias que cubran el desfase y los casos con feriados. La interfaz de usuario NO DEBE calcular
estas reglas de forma dispersa.

**Justificación**: son exactamente las reglas que el usuario discute con la empresa proveedora; si
viven en la UI, no pueden verificarse ni auditarse.

### V. Puertas de Calidad (INNEGOCIABLE)

Antes de dar por terminada una funcionalidad DEBEN pasar sin errores: `dart format`, `flutter
analyze` (cero advertencias) y `flutter test`. La lógica de dominio nueva DEBE incluir pruebas. El
código de interfaz DEBE cubrirse con pruebas cuando su comportamiento no sea trivial.

**Justificación**: sin una barrera automática, la evidencia y los cálculos del dominio se degradan
sin que nadie lo note.

## Stack y Arquitectura

- **Plataforma**: Flutter estable y Dart, en las versiones fijadas en `pubspec.yaml`
  (Flutter 3.47.2 / SDK `^3.13.2` al momento de ratificar).
- **Estado**: exclusivamente Riverpod 3 (`flutter_riverpod` + `riverpod_annotation`). NO se DEBE usar
  `setState` para lógica de negocio.
- **Persistencia**: exclusivamente Drift. Todo cambio de esquema DEBE incluir una migración y un plan
  de reversión.
- **Navegación**: `go_router`.
- **Generación de código**: `build_runner`. Los archivos generados (`*.g.dart`, `*.freezed.dart`) NO
  DEBEN editarse a mano y DEBEN regenerarse en el mismo cambio.
- **Estructura**: por funcionalidad (`lib/features/<feature>/` con `data/`, `domain/`,
  `presentation/`); el código compartido vive en `lib/core/`.
- **Fotografías**: se guardan en almacenamiento privado de la app y se referencian desde la base de
  datos por ruta o identificador, nunca como blobs embebidos.

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

**Version**: 1.1.0 | **Ratified**: 2026-10-18 | **Last Amended**: 2026-10-18
