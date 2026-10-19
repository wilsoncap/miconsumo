# Feature Specification: Conceptos de Facturación

**Feature Branch**: `002-conceptos-de-facturacion`

**Created**: 2026-10-18

**Status**: Draft

**Input**: User description: "Definir los conceptos que la empresa de servicios cobra en la factura, con su base de cálculo, su signo y el historial de cambios de valor en el tiempo"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Definir los conceptos que la empresa cobra (Priority: P1)

Como responsable del hogar, quiero declarar cada uno de los conceptos que aparecen en mi factura —el
consumo, el cargo fijo, el alumbrado público, el alcantarillado, un subsidio— indicando cómo se calcula
cada uno y si suma o resta, para poder reconstruir el monto que la empresa me cobra.

**Why this priority**: sin los conceptos no existe forma de comparar lo que medí contra lo que me
cobran, que es el propósito central de la aplicación.

**Independent Test**: se prueba creando un concepto sobre un servicio existente y verificando que
aparece listado bajo ese servicio con su base de cálculo y su signo.

**Acceptance Scenarios**:

1. **Given** un servicio "Agua" con unidad m³, **When** el usuario crea el concepto "Cargo fijo" como
   monto fijo que suma, **Then** el concepto aparece listado bajo el servicio "Agua".
2. **Given** el servicio "Agua", **When** el usuario crea el concepto "Consumo" como precio por
   consumo que suma, **Then** el concepto queda expresado como precio por m³.
3. **Given** un servicio con el concepto "Subsidio", **When** el usuario consulta otro servicio,
   **Then** solo ve los conceptos del servicio consultado.
4. **Given** un servicio "Luz", **When** el usuario crea el concepto "Alumbrado público" como monto
   fijo que suma, **Then** el concepto queda registrado de forma independiente del consumo.

---

### User Story 2 - Registrar cambios de valor sin alterar el pasado (Priority: P1)

Como responsable del hogar, quiero registrar cuándo cambia el valor de un concepto —porque el precio
del m³ sube, o porque el cargo fijo se ajusta— sin que eso modifique los cálculos de meses anteriores
que ya revisé.

**Why this priority**: es lo que hace que la comparación contra facturas pasadas siga siendo válida.
Sin esto, cualquier corrección hacia atrás contamina el historial y la evidencia deja de servir.

**Independent Test**: se prueba registrando un cambio de valor con fecha efectiva en el pasado y
verificando que el valor aplicable a una fecha anterior sigue siendo el que regía entonces.

**Acceptance Scenarios**:

1. **Given** un concepto cuyo valor es 500 con fecha efectiva del 1 de enero de 2025, **When** el
   usuario registra un valor de 700 con fecha efectiva del 1 de enero de 2026, **Then** una fecha de
   corte de diciembre de 2025 sigue resolviendo 500, y una de febrero de 2026 resuelve 700.
2. **Given** un concepto con un valor vigente desde enero de 2026, **When** el usuario registra un
   segundo incremento con fecha efectiva del 1 de julio de 2026, **Then** ambos incrementos conviven y
   una fecha de corte de agosto de 2026 resuelve el segundo valor.
3. **Given** un concepto con valores ya registrados, **When** el usuario intenta corregir un valor
   anterior, **Then** el sistema no modifica el registro existente sino que exige uno nuevo.
4. **Given** dos cambios de valor con la misma fecha efectiva, **When** el usuario consulta el valor
   aplicable a esa fecha, **Then** el sistema resuelve de forma determinista y explica cuál prevalece.

---

### User Story 3 - Conceptos calculados como porcentaje de otro concepto (Priority: P2)

Como responsable del hogar, quiero declarar conceptos que se calculan como un porcentaje de otro —por
ejemplo, el alcantarillado, que suele ser un porcentaje del cargo por consumo de agua— para no tener
que recalcularlos a mano cada período.

**Why this priority**: es muy común en las facturas reales, pero la aplicación ya aporta valor sin
esta función, porque esos conceptos pueden registrarse como montos fijos.

**Independent Test**: se prueba creando un concepto que es porcentaje de otro y verificando que el
sistema lo acepta solo si el concepto base pertenece al mismo servicio y no se forma un ciclo.

**Acceptance Scenarios**:

1. **Given** el servicio "Agua" con el concepto "Consumo", **When** el usuario crea "Alcantarillado"
   como 15% de "Consumo", **Then** el concepto queda aceptado y vinculado a "Consumo".
2. **Given** "Alcantarillado" como porcentaje de "Consumo", **When** el usuario intenta hacer que
   "Consumo" sea porcentaje de "Alcantarillado", **Then** el sistema rechaza la operación porque
   formaría un ciclo.
3. **Given** un concepto por porcentaje, **When** el usuario indica un porcentaje mayor que 100,
   **Then** el sistema lo rechaza.

---

### Edge Cases

- Dos cambios de valor con la misma fecha efectiva.
- Un cambio de valor con fecha efectiva retroactiva, anterior a valores ya registrados.
- Un ciclo entre conceptos calculados por porcentaje.
- Un concepto por porcentaje cuyo concepto base se desactiva.
- Un porcentaje mayor que 100 o menor que cero.
- Un subsidio cuyo valor supera el total de los demás conceptos, dejando un total negativo.
- Un concepto con un valor expresado con más decimales de los que admite su unidad.
- Un concepto creado por error con el nombre equivocado.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE permitir crear un concepto de facturación asociado a un tipo de
  servicio, indicando nombre, base de cálculo y signo.
- **FR-002**: El sistema DEBE exigir que el nombre del concepto no esté vacío.
- **FR-003**: El sistema DEBE rechazar un nombre de concepto duplicado dentro del mismo servicio, sin
  distinguir mayúsculas, minúsculas ni acentos. El mismo nombre PUEDE repetirse en servicios distintos.
- **FR-004**: El sistema DEBE exigir una base de cálculo, elegida entre monto fijo, por consumo y
  porcentaje de otro concepto.
- **FR-005**: El sistema DEBE exigir un signo, suma o resta.
- **FR-006**: El sistema DEBE exigir un valor numérico mayor o igual que cero.
- **FR-007**: Cuando la base sea por consumo, el valor DEBE interpretarse como precio por unidad de
  medida del servicio al que pertenece el concepto.
- **FR-008**: Cuando la base sea porcentaje, el valor DEBE estar entre 0 y 100.
- **FR-009**: Cuando la base sea porcentaje, el sistema DEBE exigir una referencia a otro concepto del
  MISMO servicio. NUNCA DEBE aceptarse una referencia a un concepto de otro servicio.
- **FR-010**: El sistema DEBE rechazar cualquier conjunto de conceptos que forme un ciclo a través de
  las referencias por porcentaje.
- **FR-011**: El sistema DEBE establecer un orden de cálculo determinista para los conceptos por
  porcentaje, de modo que el mismo conjunto de datos produzca siempre el mismo resultado.
- **FR-012**: El sistema DEBE conservar el historial de valores de cada concepto. Cada valor DEBE
  registrarse con una fecha efectiva.
- **FR-013**: El valor aplicable a una fecha DEBE ser el último registrado cuya fecha efectiva sea
  menor o igual a esa fecha.
- **FR-014**: El sistema NUNCA DEBE modificar ni eliminar un valor ya registrado. Una corrección DEBE
  ser un registro nuevo.
- **FR-015**: Cuando dos valores comparten la misma fecha efectiva, el sistema DEBE resolver de forma
  determinista y explicitar cuál prevalece.
- **FR-016**: Registrar un valor NUNCA DEBE alterar un cálculo ya realizado sobre un período cerrado.
- **FR-017**: El sistema DEBE permitir desactivar un concepto. NUNCA DEBE permitir eliminar un
  concepto que tenga valores registrados.
- **FR-018**: Un concepto desactivado NO DEBE ofrecerse al construir cálculos nuevos, pero su historial
  DEBE conservarse.
- **FR-019**: El monto total de una factura DEBE expresarse en pesos colombianos enteros, mientras que
  los valores unitarios DEBEN conservar sus decimales. El redondeo DEBE aplicarse una sola vez, sobre
  el total final, y NUNCA antes de multiplicar.
- **FR-020**: Los conceptos y sus valores DEBEN conservarse en el dispositivo y DEBEN estar disponibles
  sin conexión a red.
- **FR-021**: Los conceptos de un servicio NUNCA DEBEN afectar a los de otro servicio.

### Key Entities *(include if feature involves data)*

- **Concepto de Facturación**: una línea que aparece en la factura de un servicio (consumo, cargo fijo,
  alumbrado público, alcantarillado, subsidio). Tiene nombre, base de cálculo, signo, un valor vigente,
  un orden de cálculo y un estado activo o inactivo. Pertenece a un único tipo de servicio.
- **Base de Cálculo**: la forma en que el concepto produce un monto. Puede ser un monto fijo, un precio
  por unidad de consumo del servicio, o un porcentaje de otro concepto.
- **Signo**: indica si el concepto se suma o se resta en el total de la factura.
- **Valor de Concepto**: un registro histórico con un valor y una fecha efectiva. Los valores nunca se
  modifican; se acumulan.
- **Orden de Cálculo**: la posición en que un concepto por porcentaje debe resolverse respecto de su
  concepto base.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Un usuario puede registrar un concepto completo en menos de un minuto.
- **SC-002**: El sistema permite 0 configuraciones con ciclos entre conceptos por porcentaje.
- **SC-003**: Tras registrar un cambio de valor con fecha retroactiva, el 100% de los cálculos de
  períodos cerrados permanece idéntico.
- **SC-004**: Dos incrementos dentro del mismo año se resuelven correctamente, y el 100% de las fechas
  de corte obtiene el valor que regía en esa fecha.
- **SC-005**: El total calculado coincide exactamente con el resultado de aplicar el redondeo una sola
  vez al final, sin desviación de ningún peso.
- **SC-006**: Los conceptos están disponibles sin conexión en el 100% de los casos.
- **SC-007**: Un usuario puede identificar la base de cálculo y el signo de un concepto sin abrir su
  detalle.

## Assumptions

- **Los conceptos los crea el usuario manualmente.** La aplicación no propone automáticamente subsidios
  ni contribuciones según el estrato del inmueble: un subsidio es simplemente un concepto con signo
  resta, y una contribución, uno con signo suma.
- **Un servicio sin conceptos no produce monto.** No se asume ningún concepto por defecto.
- **No se eliminan conceptos con historial.** Se desactivan, igual que los servicios, para no romper
  cálculos anteriores.
- **La base "por consumo" usa la unidad del servicio.** El concepto no declara su propia unidad; la
  hereda, de modo que no pueda quedar expresada en una unidad distinta a la de su servicio.
- **Fuera de alcance**: el registro de mediciones diarias, las fotografías de respaldo, las fechas de
  corte, el cálculo efectivo del monto de la factura, el congelamiento de períodos, la comparación
  contra la factura emitida y la compartición en redes sociales. Cada una es una funcionalidad propia.
- **Dependencia**: esta funcionalidad requiere que existan tipos de servicio (`001-tipos-de-servicio`).
- **Localización**: Colombia, locale `es_CO` y montos en pesos colombianos.
- **Sin conexión**: la aplicación funciona por completo sin red.
