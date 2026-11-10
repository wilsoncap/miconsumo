# Mi Consumo

App Android offline-first para registrar el consumo diario de los servicios del
hogar (luz, agua y gas) y compararlo con lo que cobra la empresa proveedora.

Es una libreta de evidencia doméstica: nada se elimina, las lecturas no se
editan (corregir es agregar una lectura nueva) y las fotos del medidor nunca se
sobrescriben.

## Estado

Núcleo implementado:

- Mis servicios (crear, editar, activar/desactivar sin borrar).
- Mediciones por servicio, con corrección y lecturas reemplazadas.
- Registro de lectura con fecha, validaciones, aviso de lectura menor y foto
  opcional en almacenamiento privado.
- Consumo mensual con gráfica de barras, promedio, comparación con el mes
  anterior y aviso de consumo negativo.
- Visor de foto.
- Estados de carga, vacío, error y avisos.
- Tema Material 3 claro y oscuro, textos en español de Colombia (`es_CO`).

Fuera de alcance por ahora: conceptos de facturación, fechas de corte, cálculo
de factura y compartir como protesta (Fase 2 del prompt).

## Arquitectura

- Flutter + Material 3.
- Riverpod para estado e inyección de dependencias.
- Drift para persistencia local (`schemaVersion = 2`).
- go_router para navegación jerárquica.
- Dominio en Dart puro, sin Flutter, Drift ni go_router.
- `intl` + ARB para localización; `decimal` para consumo y dinero (sin `double`).
- `fl_chart` para la gráfica de consumo; `image_picker` para las fotos.

Estructura principal:

```text
lib/
├── app/          # app, router, base de datos y DI
├── core/         # tema, widgets compartidos, utilidades y errores
├── features/
│   ├── servicios/
│   └── mediciones/
└── l10n/         # ARB y traducciones generadas
```

## Ejecutar

```bash
flutter pub get
dart run build_runner build
flutter gen-l10n
flutter run
```

## Puertas de calidad

```bash
dart format --set-exit-if-changed .
dart analyze
flutter test
```

Las pruebas cubren dominio, repositorios Drift, ViewModels, widgets, goldens y
pureza del dominio. Los datos de ejemplo del prompt se usan solo en pruebas.

## Supuestos

- La app arranca vacía; no se precargan datos de demostración.
- Un solo hogar por instalación, sin login, nube ni analítica.
- La unidad no se puede cambiar cuando el servicio ya tiene lecturas.
- El promedio diario se calcula sobre los días transcurridos del mes hasta la
  última lectura.
- Si un mes solo contiene la primera lectura histórica, se muestra un estado
  informativo de “sin consumo” en lugar de una gráfica vacía.
