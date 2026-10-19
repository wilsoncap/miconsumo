# Feature Specification: Tipos de Servicio

**Feature Branch**: `001-tipos-de-servicio`

**Created**: 2026-10-18

**Status**: Draft

**Input**: User description: "Gestionar los tipos de servicio del hogar con su unidad de medida y una etiqueta de contrato opcional"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Registrar un tipo de servicio con su unidad (Priority: P1)

Como responsable del hogar, quiero dar de alta los servicios que recibo (luz, agua, gas) indicando
con qué unidad se mide su consumo y, si quiero, el número de contrato que aparece en la factura, para
poder registrar después las mediciones diarias en la unidad correcta y reconocer cada servicio.

**Why this priority**: sin tipos de servicio no existe nada más en la aplicación: las mediciones, los
conceptos de facturación, las fechas de corte y las comparaciones cuelgan de esta entidad. Es el
cimiento de todo el producto.

**Independent Test**: se prueba por completo creando un tipo de servicio y verificando que aparece en
la lista con su unidad. Entrega valor por sí solo, porque deja el catálogo listo para empezar a medir.

**Acceptance Scenarios**:

1. **Given** un hogar sin servicios configurados, **When** el usuario crea el servicio "Luz" con
   unidad kWh, **Then** el servicio aparece en la lista mostrando "Luz — kWh".
2. **Given** que ya existe un servicio llamado "Luz", **When** el usuario intenta crear otro servicio
   llamado "luz" en minúsculas, **Then** el sistema rechaza la creación e indica que el nombre ya está
   en uso.
3. **Given** un servicio "Agua" con unidad m³, **When** el usuario lo abre, **Then** la unidad se
   muestra como m³ y no puede confundirse con la de otro servicio.
4. **Given** un servicio "Luz" recién creado, **When** el usuario añade la etiqueta de contrato
   "12345-2026", **Then** la etiqueta queda guardada y visible en el detalle del servicio.
5. **Given** un servicio con etiqueta de contrato, **When** el usuario la elimina, **Then** el
   servicio conserva todos sus demás datos y queda sin etiqueta.
6. **Given** un usuario que va a crear un servicio, **When** no escribe etiqueta de contrato, **Then**
   el servicio se crea igualmente sin ningún error.

---

### User Story 2 - Desactivar un servicio sin perder historial (Priority: P2)

Como responsable del hogar, quiero desactivar un servicio que ya no recibo (por ejemplo, si dejo de
usar gas), sin que se borren las mediciones que ya registré, para conservar la evidencia histórica.

**Why this priority**: protege la evidencia acumulada. Es importante, pero la aplicación ya aporta
valor sin esta función.

**Independent Test**: se prueba desactivando un servicio que tiene mediciones y verificando que el
servicio deja de ofrecerse para nuevas mediciones pero sus datos históricos siguen consultables.

**Acceptance Scenarios**:

1. **Given** un servicio con mediciones registradas, **When** el usuario lo desactiva, **Then** el
   servicio deja de aparecer al registrar una medición nueva.
2. **Given** un servicio desactivado, **When** el usuario consulta el historial, **Then** las
   mediciones anteriores siguen disponibles.
3. **Given** un servicio desactivado, **When** el usuario decide volver a usarlo, **Then** puede
   reactivarlo y vuelve a estar disponible para mediciones nuevas.

---

### Edge Cases

- El nombre del servicio está vacío o contiene solo espacios.
- Dos servicios con el mismo nombre pero distinta capitalización o acentos ("Agua" y "agua").
- El usuario intenta cambiar la unidad de un servicio que ya tiene mediciones registradas.
- El usuario intenta eliminar definitivamente un servicio con mediciones asociadas.
- La etiqueta de contrato se deja vacía, o es tan larga que no cabe en la pantalla de detalle.
- El usuario tiene más servicios de los que caben en una pantalla.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE permitir crear un tipo de servicio indicando un nombre y una unidad de
  medida.
- **FR-002**: El sistema DEBE exigir que el nombre del servicio no esté vacío.
- **FR-003**: El sistema DEBE rechazar un nombre de servicio duplicado, sin distinguir mayúsculas,
  minúsculas ni acentos.
- **FR-004**: El sistema DEBE exigir que cada tipo de servicio tenga una unidad de medida asignada.
- **FR-005**: El sistema DEBE ofrecer un catálogo de unidades que incluya kWh (electricidad), m³ (agua
  y gas natural) y kg (gas licuado en pipeta).
- **FR-006**: El sistema NO DEBE permitir modificar la unidad de medida de un servicio que ya tiene
  mediciones registradas. El intento DEBE bloquearse de forma explícita, explicando el motivo al
  usuario.
- **FR-007**: El sistema DEBE permitir desactivar un tipo de servicio.
- **FR-008**: Desactivar un servicio NUNCA DEBE eliminar ni alterar sus mediciones registradas.
- **FR-009**: Un servicio desactivado NO DEBE ofrecerse al registrar mediciones nuevas.
- **FR-010**: El sistema DEBE permitir reactivar un servicio desactivado.
- **FR-011**: El sistema DEBE mostrar la lista de servicios con su nombre, su unidad y su estado
  (activo o inactivo).
- **FR-012**: El sistema DEBE conservar los tipos de servicio en el dispositivo y DEBE mantenerlos
  disponibles sin conexión a red.
- **FR-013**: El sistema DEBE permitir asociar a cada tipo de servicio una etiqueta de contrato
  opcional, de texto libre, que refuerce la evidencia al compartir.
- **FR-014**: La etiqueta de contrato NUNCA DEBE transmitirse fuera del dispositivo ni a terceros.
- **FR-015**: El sistema NUNCA DEBE ofrecer la eliminación definitiva de un tipo de servicio.

### Key Entities *(include if feature involves data)*

- **Tipo de Servicio**: un servicio recibido en el hogar (luz, agua, gas). Tiene nombre, unidad de
  medida, estado (activo o inactivo) y una etiqueta de contrato opcional.
- **Unidad de Medida**: la magnitud en la que se expresa el consumo de un servicio. Catálogo inicial:
  kWh para electricidad, m³ para agua y gas natural, y kg para gas licuado en pipeta.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Un usuario puede dejar un tipo de servicio listo para medir en menos de 30 segundos.
- **SC-002**: El 100% de los servicios listados muestran su unidad de medida sin ambigüedad.
- **SC-003**: El sistema permite 0 nombres de servicio duplicados.
- **SC-004**: Desactivar un servicio pierde 0 mediciones históricas.
- **SC-005**: El catálogo de servicios está disponible sin conexión en el 100% de los casos.
- **SC-006**: Un usuario puede identificar la unidad de un servicio sin abrir su detalle, en una sola
  lectura de la lista.

## Assumptions

- **Un solo hogar por instalación**: la aplicación no contempla múltiples usuarios ni múltiples hogares
  en esta versión.
- **Catálogo de unidades cerrado**: por ahora kWh, m³ y kg. Se ampliará cuando aparezca un servicio con
  otra unidad.
- **Los servicios se desactivan, no se eliminan**: se preserva la integridad de la evidencia histórica
  y se evita romper las mediciones y los conceptos de facturación que dependan de ellos.
- **La etiqueta de contrato es opcional y local**: es texto libre, no se valida contra ningún formato
  de empresa y nunca sale del dispositivo. Existe solo para reforzar la evidencia al compartir.
- **Fuera de alcance**: los conceptos de facturación y sus valores con vigencia, el registro de
  mediciones diarias, las fotografías de respaldo, las fechas de corte por servicio, el cálculo del
  monto de la factura, la detección de cobro indebido y la compartición en redes sociales. Cada una es
  una funcionalidad propia.
- **Localización**: la aplicación está dirigida a Colombia, con locale `es_CO` y montos en pesos
  colombianos.
- **Sin conexión**: la aplicación funciona por completo sin red.
