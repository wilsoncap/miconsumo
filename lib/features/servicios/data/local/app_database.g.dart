// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServiciosTable extends Servicios
    with TableInfo<$ServiciosTable, Servicio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreNormalizadoMeta = const VerificationMeta(
    'nombreNormalizado',
  );
  @override
  late final GeneratedColumn<String> nombreNormalizado =
      GeneratedColumn<String>(
        'nombre_normalizado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etiquetaContratoMeta = const VerificationMeta(
    'etiquetaContrato',
  );
  @override
  late final GeneratedColumn<String> etiquetaContrato = GeneratedColumn<String>(
    'etiqueta_contrato',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    nombreNormalizado,
    unidad,
    etiquetaContrato,
    activo,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servicios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Servicio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('nombre_normalizado')) {
      context.handle(
        _nombreNormalizadoMeta,
        nombreNormalizado.isAcceptableOrUnknown(
          data['nombre_normalizado']!,
          _nombreNormalizadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreNormalizadoMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadMeta);
    }
    if (data.containsKey('etiqueta_contrato')) {
      context.handle(
        _etiquetaContratoMeta,
        etiquetaContrato.isAcceptableOrUnknown(
          data['etiqueta_contrato']!,
          _etiquetaContratoMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Servicio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Servicio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      nombreNormalizado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_normalizado'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
      etiquetaContrato: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etiqueta_contrato'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $ServiciosTable createAlias(String alias) {
    return $ServiciosTable(attachedDatabase, alias);
  }
}

class Servicio extends DataClass implements Insertable<Servicio> {
  /// Identificador asignado por el sistema.
  final int id;

  /// Nombre tal como lo escribió el usuario.
  final String nombre;

  /// Forma normalizada del nombre, sin acentos y en minúsculas.
  final String nombreNormalizado;

  /// Código de la unidad de medida (`kwh`, `m3`, `kg`).
  final String unidad;

  /// Etiqueta de contrato opcional. De uso estrictamente local.
  final String? etiquetaContrato;

  /// Falso cuando el servicio está desactivado.
  final bool activo;

  /// Marca de captura.
  final DateTime creadoEn;

  /// Marca de última modificación.
  final DateTime actualizadoEn;
  const Servicio({
    required this.id,
    required this.nombre,
    required this.nombreNormalizado,
    required this.unidad,
    this.etiquetaContrato,
    required this.activo,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['nombre_normalizado'] = Variable<String>(nombreNormalizado);
    map['unidad'] = Variable<String>(unidad);
    if (!nullToAbsent || etiquetaContrato != null) {
      map['etiqueta_contrato'] = Variable<String>(etiquetaContrato);
    }
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  ServiciosCompanion toCompanion(bool nullToAbsent) {
    return ServiciosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      nombreNormalizado: Value(nombreNormalizado),
      unidad: Value(unidad),
      etiquetaContrato: etiquetaContrato == null && nullToAbsent
          ? const Value.absent()
          : Value(etiquetaContrato),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Servicio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Servicio(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      nombreNormalizado: serializer.fromJson<String>(json['nombreNormalizado']),
      unidad: serializer.fromJson<String>(json['unidad']),
      etiquetaContrato: serializer.fromJson<String?>(json['etiquetaContrato']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'nombreNormalizado': serializer.toJson<String>(nombreNormalizado),
      'unidad': serializer.toJson<String>(unidad),
      'etiquetaContrato': serializer.toJson<String?>(etiquetaContrato),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Servicio copyWith({
    int? id,
    String? nombre,
    String? nombreNormalizado,
    String? unidad,
    Value<String?> etiquetaContrato = const Value.absent(),
    bool? activo,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => Servicio(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    nombreNormalizado: nombreNormalizado ?? this.nombreNormalizado,
    unidad: unidad ?? this.unidad,
    etiquetaContrato: etiquetaContrato.present
        ? etiquetaContrato.value
        : this.etiquetaContrato,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  Servicio copyWithCompanion(ServiciosCompanion data) {
    return Servicio(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      nombreNormalizado: data.nombreNormalizado.present
          ? data.nombreNormalizado.value
          : this.nombreNormalizado,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      etiquetaContrato: data.etiquetaContrato.present
          ? data.etiquetaContrato.value
          : this.etiquetaContrato,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Servicio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('nombreNormalizado: $nombreNormalizado, ')
          ..write('unidad: $unidad, ')
          ..write('etiquetaContrato: $etiquetaContrato, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    nombreNormalizado,
    unidad,
    etiquetaContrato,
    activo,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Servicio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.nombreNormalizado == this.nombreNormalizado &&
          other.unidad == this.unidad &&
          other.etiquetaContrato == this.etiquetaContrato &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class ServiciosCompanion extends UpdateCompanion<Servicio> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> nombreNormalizado;
  final Value<String> unidad;
  final Value<String?> etiquetaContrato;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const ServiciosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.nombreNormalizado = const Value.absent(),
    this.unidad = const Value.absent(),
    this.etiquetaContrato = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  ServiciosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String nombreNormalizado,
    required String unidad,
    this.etiquetaContrato = const Value.absent(),
    this.activo = const Value.absent(),
    required DateTime creadoEn,
    required DateTime actualizadoEn,
  }) : nombre = Value(nombre),
       nombreNormalizado = Value(nombreNormalizado),
       unidad = Value(unidad),
       creadoEn = Value(creadoEn),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<Servicio> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? nombreNormalizado,
    Expression<String>? unidad,
    Expression<String>? etiquetaContrato,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (nombreNormalizado != null) 'nombre_normalizado': nombreNormalizado,
      if (unidad != null) 'unidad': unidad,
      if (etiquetaContrato != null) 'etiqueta_contrato': etiquetaContrato,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  ServiciosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? nombreNormalizado,
    Value<String>? unidad,
    Value<String?>? etiquetaContrato,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return ServiciosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      nombreNormalizado: nombreNormalizado ?? this.nombreNormalizado,
      unidad: unidad ?? this.unidad,
      etiquetaContrato: etiquetaContrato ?? this.etiquetaContrato,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (nombreNormalizado.present) {
      map['nombre_normalizado'] = Variable<String>(nombreNormalizado.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (etiquetaContrato.present) {
      map['etiqueta_contrato'] = Variable<String>(etiquetaContrato.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiciosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('nombreNormalizado: $nombreNormalizado, ')
          ..write('unidad: $unidad, ')
          ..write('etiquetaContrato: $etiquetaContrato, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServiciosTable servicios = $ServiciosTable(this);
  late final Index serviciosNombreNormalizado = Index(
    'servicios_nombre_normalizado',
    'CREATE UNIQUE INDEX servicios_nombre_normalizado ON servicios (nombre_normalizado)',
  );
  late final ServiciosDao serviciosDao = ServiciosDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    servicios,
    serviciosNombreNormalizado,
  ];
}

typedef $$ServiciosTableCreateCompanionBuilder = ServiciosCompanion Function({
  Value<int> id,
  required String nombre,
  required String nombreNormalizado,
  required String unidad,
  Value<String?> etiquetaContrato,
  Value<bool> activo,
  required DateTime creadoEn,
  required DateTime actualizadoEn,
});
typedef $$ServiciosTableUpdateCompanionBuilder = ServiciosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> nombreNormalizado,
  Value<String> unidad,
  Value<String?> etiquetaContrato,
  Value<bool> activo,
  Value<DateTime> creadoEn,
  Value<DateTime> actualizadoEn,
});

class $$ServiciosTableFilterComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreNormalizado => $composableBuilder(
    column: $table.nombreNormalizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etiquetaContrato => $composableBuilder(
    column: $table.etiquetaContrato,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiciosTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreNormalizado => $composableBuilder(
    column: $table.nombreNormalizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etiquetaContrato => $composableBuilder(
    column: $table.etiquetaContrato,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get nombreNormalizado => $composableBuilder(
    column: $table.nombreNormalizado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<String> get etiquetaContrato => $composableBuilder(
    column: $table.etiquetaContrato,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$ServiciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiciosTable,
          Servicio,
          $$ServiciosTableFilterComposer,
          $$ServiciosTableOrderingComposer,
          $$ServiciosTableAnnotationComposer,
          $$ServiciosTableCreateCompanionBuilder,
          $$ServiciosTableUpdateCompanionBuilder,
          (Servicio, BaseReferences<_$AppDatabase, $ServiciosTable, Servicio>),
          Servicio,
          PrefetchHooks Function()
        > {
  $$ServiciosTableTableManager(_$AppDatabase db, $ServiciosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> nombreNormalizado = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<String?> etiquetaContrato = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => ServiciosCompanion(
                id: id,
                nombre: nombre,
                nombreNormalizado: nombreNormalizado,
                unidad: unidad,
                etiquetaContrato: etiquetaContrato,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String nombreNormalizado,
                required String unidad,
                Value<String?> etiquetaContrato = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                required DateTime creadoEn,
                required DateTime actualizadoEn,
              }) => ServiciosCompanion.insert(
                id: id,
                nombre: nombre,
                nombreNormalizado: nombreNormalizado,
                unidad: unidad,
                etiquetaContrato: etiquetaContrato,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServiciosTable, Servicio>(table),
                  BaseReferences<_$AppDatabase, $ServiciosTable, Servicio>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiciosTable,
      Servicio,
      $$ServiciosTableFilterComposer,
      $$ServiciosTableOrderingComposer,
      $$ServiciosTableAnnotationComposer,
      $$ServiciosTableCreateCompanionBuilder,
      $$ServiciosTableUpdateCompanionBuilder,
      (Servicio, BaseReferences<_$AppDatabase, $ServiciosTable, Servicio>),
      Servicio,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServiciosTableTableManager get servicios =>
      $$ServiciosTableTableManager(_db, _db.servicios);
}
