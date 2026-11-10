// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServiciosTable extends Servicios
    with TableInfo<$ServiciosTable, ServicioRow> {
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
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    Insertable<ServicioRow> instance, {
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
  ServicioRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServicioRow(
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

class ServicioRow extends DataClass implements Insertable<ServicioRow> {
  final int id;
  final String nombre;
  final String nombreNormalizado;
  final String unidad;
  final String? etiquetaContrato;
  final bool activo;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const ServicioRow({
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

  factory ServicioRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServicioRow(
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

  ServicioRow copyWith({
    int? id,
    String? nombre,
    String? nombreNormalizado,
    String? unidad,
    Value<String?> etiquetaContrato = const Value.absent(),
    bool? activo,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => ServicioRow(
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
  ServicioRow copyWithCompanion(ServiciosCompanion data) {
    return ServicioRow(
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
    return (StringBuffer('ServicioRow(')
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
      (other is ServicioRow &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.nombreNormalizado == this.nombreNormalizado &&
          other.unidad == this.unidad &&
          other.etiquetaContrato == this.etiquetaContrato &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class ServiciosCompanion extends UpdateCompanion<ServicioRow> {
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
  static Insertable<ServicioRow> custom({
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

class $LecturasTable extends Lecturas
    with TableInfo<$LecturasTable, LecturaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LecturasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _servicioIdMeta = const VerificationMeta(
    'servicioId',
  );
  @override
  late final GeneratedColumn<int> servicioId = GeneratedColumn<int>(
    'servicio_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servicios (id)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaFotoMeta = const VerificationMeta(
    'rutaFoto',
  );
  @override
  late final GeneratedColumn<String> rutaFoto = GeneratedColumn<String>(
    'ruta_foto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('vigente'),
  );
  static const VerificationMeta _reemplazaAMeta = const VerificationMeta(
    'reemplazaA',
  );
  @override
  late final GeneratedColumn<int> reemplazaA = GeneratedColumn<int>(
    'reemplaza_a',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    servicioId,
    fecha,
    valor,
    rutaFoto,
    estado,
    reemplazaA,
    creadaEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lecturas';
  @override
  VerificationContext validateIntegrity(
    Insertable<LecturaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('servicio_id')) {
      context.handle(
        _servicioIdMeta,
        servicioId.isAcceptableOrUnknown(data['servicio_id']!, _servicioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_servicioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('ruta_foto')) {
      context.handle(
        _rutaFotoMeta,
        rutaFoto.isAcceptableOrUnknown(data['ruta_foto']!, _rutaFotoMeta),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('reemplaza_a')) {
      context.handle(
        _reemplazaAMeta,
        reemplazaA.isAcceptableOrUnknown(data['reemplaza_a']!, _reemplazaAMeta),
      );
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadaEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LecturaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LecturaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      servicioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servicio_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
      rutaFoto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_foto'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      reemplazaA: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reemplaza_a'],
      ),
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
    );
  }

  @override
  $LecturasTable createAlias(String alias) {
    return $LecturasTable(attachedDatabase, alias);
  }
}

class LecturaRow extends DataClass implements Insertable<LecturaRow> {
  final int id;
  final int servicioId;
  final DateTime fecha;
  final String valor;
  final String? rutaFoto;
  final String estado;
  final int? reemplazaA;
  final DateTime creadaEn;
  const LecturaRow({
    required this.id,
    required this.servicioId,
    required this.fecha,
    required this.valor,
    this.rutaFoto,
    required this.estado,
    this.reemplazaA,
    required this.creadaEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['servicio_id'] = Variable<int>(servicioId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['valor'] = Variable<String>(valor);
    if (!nullToAbsent || rutaFoto != null) {
      map['ruta_foto'] = Variable<String>(rutaFoto);
    }
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || reemplazaA != null) {
      map['reemplaza_a'] = Variable<int>(reemplazaA);
    }
    map['creada_en'] = Variable<DateTime>(creadaEn);
    return map;
  }

  LecturasCompanion toCompanion(bool nullToAbsent) {
    return LecturasCompanion(
      id: Value(id),
      servicioId: Value(servicioId),
      fecha: Value(fecha),
      valor: Value(valor),
      rutaFoto: rutaFoto == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaFoto),
      estado: Value(estado),
      reemplazaA: reemplazaA == null && nullToAbsent
          ? const Value.absent()
          : Value(reemplazaA),
      creadaEn: Value(creadaEn),
    );
  }

  factory LecturaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LecturaRow(
      id: serializer.fromJson<int>(json['id']),
      servicioId: serializer.fromJson<int>(json['servicioId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      valor: serializer.fromJson<String>(json['valor']),
      rutaFoto: serializer.fromJson<String?>(json['rutaFoto']),
      estado: serializer.fromJson<String>(json['estado']),
      reemplazaA: serializer.fromJson<int?>(json['reemplazaA']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'servicioId': serializer.toJson<int>(servicioId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'valor': serializer.toJson<String>(valor),
      'rutaFoto': serializer.toJson<String?>(rutaFoto),
      'estado': serializer.toJson<String>(estado),
      'reemplazaA': serializer.toJson<int?>(reemplazaA),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
    };
  }

  LecturaRow copyWith({
    int? id,
    int? servicioId,
    DateTime? fecha,
    String? valor,
    Value<String?> rutaFoto = const Value.absent(),
    String? estado,
    Value<int?> reemplazaA = const Value.absent(),
    DateTime? creadaEn,
  }) => LecturaRow(
    id: id ?? this.id,
    servicioId: servicioId ?? this.servicioId,
    fecha: fecha ?? this.fecha,
    valor: valor ?? this.valor,
    rutaFoto: rutaFoto.present ? rutaFoto.value : this.rutaFoto,
    estado: estado ?? this.estado,
    reemplazaA: reemplazaA.present ? reemplazaA.value : this.reemplazaA,
    creadaEn: creadaEn ?? this.creadaEn,
  );
  LecturaRow copyWithCompanion(LecturasCompanion data) {
    return LecturaRow(
      id: data.id.present ? data.id.value : this.id,
      servicioId: data.servicioId.present
          ? data.servicioId.value
          : this.servicioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      valor: data.valor.present ? data.valor.value : this.valor,
      rutaFoto: data.rutaFoto.present ? data.rutaFoto.value : this.rutaFoto,
      estado: data.estado.present ? data.estado.value : this.estado,
      reemplazaA: data.reemplazaA.present
          ? data.reemplazaA.value
          : this.reemplazaA,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LecturaRow(')
          ..write('id: $id, ')
          ..write('servicioId: $servicioId, ')
          ..write('fecha: $fecha, ')
          ..write('valor: $valor, ')
          ..write('rutaFoto: $rutaFoto, ')
          ..write('estado: $estado, ')
          ..write('reemplazaA: $reemplazaA, ')
          ..write('creadaEn: $creadaEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    servicioId,
    fecha,
    valor,
    rutaFoto,
    estado,
    reemplazaA,
    creadaEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LecturaRow &&
          other.id == this.id &&
          other.servicioId == this.servicioId &&
          other.fecha == this.fecha &&
          other.valor == this.valor &&
          other.rutaFoto == this.rutaFoto &&
          other.estado == this.estado &&
          other.reemplazaA == this.reemplazaA &&
          other.creadaEn == this.creadaEn);
}

class LecturasCompanion extends UpdateCompanion<LecturaRow> {
  final Value<int> id;
  final Value<int> servicioId;
  final Value<DateTime> fecha;
  final Value<String> valor;
  final Value<String?> rutaFoto;
  final Value<String> estado;
  final Value<int?> reemplazaA;
  final Value<DateTime> creadaEn;
  const LecturasCompanion({
    this.id = const Value.absent(),
    this.servicioId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.valor = const Value.absent(),
    this.rutaFoto = const Value.absent(),
    this.estado = const Value.absent(),
    this.reemplazaA = const Value.absent(),
    this.creadaEn = const Value.absent(),
  });
  LecturasCompanion.insert({
    this.id = const Value.absent(),
    required int servicioId,
    required DateTime fecha,
    required String valor,
    this.rutaFoto = const Value.absent(),
    this.estado = const Value.absent(),
    this.reemplazaA = const Value.absent(),
    required DateTime creadaEn,
  }) : servicioId = Value(servicioId),
       fecha = Value(fecha),
       valor = Value(valor),
       creadaEn = Value(creadaEn);
  static Insertable<LecturaRow> custom({
    Expression<int>? id,
    Expression<int>? servicioId,
    Expression<DateTime>? fecha,
    Expression<String>? valor,
    Expression<String>? rutaFoto,
    Expression<String>? estado,
    Expression<int>? reemplazaA,
    Expression<DateTime>? creadaEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (servicioId != null) 'servicio_id': servicioId,
      if (fecha != null) 'fecha': fecha,
      if (valor != null) 'valor': valor,
      if (rutaFoto != null) 'ruta_foto': rutaFoto,
      if (estado != null) 'estado': estado,
      if (reemplazaA != null) 'reemplaza_a': reemplazaA,
      if (creadaEn != null) 'creada_en': creadaEn,
    });
  }

  LecturasCompanion copyWith({
    Value<int>? id,
    Value<int>? servicioId,
    Value<DateTime>? fecha,
    Value<String>? valor,
    Value<String?>? rutaFoto,
    Value<String>? estado,
    Value<int?>? reemplazaA,
    Value<DateTime>? creadaEn,
  }) {
    return LecturasCompanion(
      id: id ?? this.id,
      servicioId: servicioId ?? this.servicioId,
      fecha: fecha ?? this.fecha,
      valor: valor ?? this.valor,
      rutaFoto: rutaFoto ?? this.rutaFoto,
      estado: estado ?? this.estado,
      reemplazaA: reemplazaA ?? this.reemplazaA,
      creadaEn: creadaEn ?? this.creadaEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (servicioId.present) {
      map['servicio_id'] = Variable<int>(servicioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rutaFoto.present) {
      map['ruta_foto'] = Variable<String>(rutaFoto.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (reemplazaA.present) {
      map['reemplaza_a'] = Variable<int>(reemplazaA.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LecturasCompanion(')
          ..write('id: $id, ')
          ..write('servicioId: $servicioId, ')
          ..write('fecha: $fecha, ')
          ..write('valor: $valor, ')
          ..write('rutaFoto: $rutaFoto, ')
          ..write('estado: $estado, ')
          ..write('reemplazaA: $reemplazaA, ')
          ..write('creadaEn: $creadaEn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServiciosTable servicios = $ServiciosTable(this);
  late final $LecturasTable lecturas = $LecturasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [servicios, lecturas];
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

final class $$ServiciosTableReferences
    extends BaseReferences<_$AppDatabase, $ServiciosTable, ServicioRow> {
  $$ServiciosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LecturasTable, List<LecturaRow>>
  _lecturasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lecturas,
    aliasName: 'servicios__id__lecturas__servicio_id',
  );

  $$LecturasTableProcessedTableManager get lecturasRefs {
    final manager = $$LecturasTableTableManager(
      $_db,
      $_db.lecturas,
    ).filter((f) => f.servicioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lecturasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> lecturasRefs(
    Expression<bool> Function($$LecturasTableFilterComposer f) f,
  ) {
    final $$LecturasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lecturas,
      getReferencedColumn: (t) => t.servicioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LecturasTableFilterComposer(
            $db: $db,
            $table: $db.lecturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> lecturasRefs<T extends Object>(
    Expression<T> Function($$LecturasTableAnnotationComposer a) f,
  ) {
    final $$LecturasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lecturas,
      getReferencedColumn: (t) => t.servicioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LecturasTableAnnotationComposer(
            $db: $db,
            $table: $db.lecturas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiciosTable,
          ServicioRow,
          $$ServiciosTableFilterComposer,
          $$ServiciosTableOrderingComposer,
          $$ServiciosTableAnnotationComposer,
          $$ServiciosTableCreateCompanionBuilder,
          $$ServiciosTableUpdateCompanionBuilder,
          (ServicioRow, $$ServiciosTableReferences),
          ServicioRow,
          PrefetchHooks Function({bool lecturasRefs})
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
                  e.readTable<$ServiciosTable, ServicioRow>(table),
                  $$ServiciosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lecturasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lecturasRefs) db.lecturas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lecturasRefs)
                    await $_getPrefetchedData<
                      ServicioRow,
                      $ServiciosTable,
                      LecturaRow
                    >(
                      currentTable: table,
                      referencedTable: $$ServiciosTableReferences
                          ._lecturasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ServiciosTableReferences(
                            db,
                            table,
                            p0,
                          ).lecturasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.servicioId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServiciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiciosTable,
      ServicioRow,
      $$ServiciosTableFilterComposer,
      $$ServiciosTableOrderingComposer,
      $$ServiciosTableAnnotationComposer,
      $$ServiciosTableCreateCompanionBuilder,
      $$ServiciosTableUpdateCompanionBuilder,
      (ServicioRow, $$ServiciosTableReferences),
      ServicioRow,
      PrefetchHooks Function({bool lecturasRefs})
    >;
typedef $$LecturasTableCreateCompanionBuilder = LecturasCompanion Function({
  Value<int> id,
  required int servicioId,
  required DateTime fecha,
  required String valor,
  Value<String?> rutaFoto,
  Value<String> estado,
  Value<int?> reemplazaA,
  required DateTime creadaEn,
});
typedef $$LecturasTableUpdateCompanionBuilder = LecturasCompanion Function({
  Value<int> id,
  Value<int> servicioId,
  Value<DateTime> fecha,
  Value<String> valor,
  Value<String?> rutaFoto,
  Value<String> estado,
  Value<int?> reemplazaA,
  Value<DateTime> creadaEn,
});

final class $$LecturasTableReferences
    extends BaseReferences<_$AppDatabase, $LecturasTable, LecturaRow> {
  $$LecturasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiciosTable _servicioIdTable(_$AppDatabase db) =>
      db.servicios.createAlias('lecturas__servicio_id__servicios__id');

  $$ServiciosTableProcessedTableManager get servicioId {
    final $_column = $_itemColumn<int>('servicio_id')!;

    final manager = $$ServiciosTableTableManager(
      $_db,
      $_db.servicios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_servicioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LecturasTableFilterComposer
    extends Composer<_$AppDatabase, $LecturasTable> {
  $$LecturasTableFilterComposer({
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

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutaFoto => $composableBuilder(
    column: $table.rutaFoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reemplazaA => $composableBuilder(
    column: $table.reemplazaA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiciosTableFilterComposer get servicioId {
    final $$ServiciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.servicioId,
      referencedTable: $db.servicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiciosTableFilterComposer(
            $db: $db,
            $table: $db.servicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LecturasTableOrderingComposer
    extends Composer<_$AppDatabase, $LecturasTable> {
  $$LecturasTableOrderingComposer({
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

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaFoto => $composableBuilder(
    column: $table.rutaFoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reemplazaA => $composableBuilder(
    column: $table.reemplazaA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiciosTableOrderingComposer get servicioId {
    final $$ServiciosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.servicioId,
      referencedTable: $db.servicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiciosTableOrderingComposer(
            $db: $db,
            $table: $db.servicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LecturasTableAnnotationComposer
    extends Composer<_$AppDatabase, $LecturasTable> {
  $$LecturasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<String> get rutaFoto =>
      $composableBuilder(column: $table.rutaFoto, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get reemplazaA => $composableBuilder(
    column: $table.reemplazaA,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);

  $$ServiciosTableAnnotationComposer get servicioId {
    final $$ServiciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.servicioId,
      referencedTable: $db.servicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiciosTableAnnotationComposer(
            $db: $db,
            $table: $db.servicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LecturasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LecturasTable,
          LecturaRow,
          $$LecturasTableFilterComposer,
          $$LecturasTableOrderingComposer,
          $$LecturasTableAnnotationComposer,
          $$LecturasTableCreateCompanionBuilder,
          $$LecturasTableUpdateCompanionBuilder,
          (LecturaRow, $$LecturasTableReferences),
          LecturaRow,
          PrefetchHooks Function({bool servicioId})
        > {
  $$LecturasTableTableManager(_$AppDatabase db, $LecturasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LecturasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LecturasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LecturasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> servicioId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<String?> rutaFoto = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int?> reemplazaA = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
              }) => LecturasCompanion(
                id: id,
                servicioId: servicioId,
                fecha: fecha,
                valor: valor,
                rutaFoto: rutaFoto,
                estado: estado,
                reemplazaA: reemplazaA,
                creadaEn: creadaEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int servicioId,
                required DateTime fecha,
                required String valor,
                Value<String?> rutaFoto = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int?> reemplazaA = const Value.absent(),
                required DateTime creadaEn,
              }) => LecturasCompanion.insert(
                id: id,
                servicioId: servicioId,
                fecha: fecha,
                valor: valor,
                rutaFoto: rutaFoto,
                estado: estado,
                reemplazaA: reemplazaA,
                creadaEn: creadaEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LecturasTable, LecturaRow>(table),
                  $$LecturasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({servicioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (servicioId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.servicioId,
                        referencedTable: $$LecturasTableReferences
                            ._servicioIdTable(db),
                        referencedColumn: $$LecturasTableReferences
                            ._servicioIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LecturasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LecturasTable,
      LecturaRow,
      $$LecturasTableFilterComposer,
      $$LecturasTableOrderingComposer,
      $$LecturasTableAnnotationComposer,
      $$LecturasTableCreateCompanionBuilder,
      $$LecturasTableUpdateCompanionBuilder,
      (LecturaRow, $$LecturasTableReferences),
      LecturaRow,
      PrefetchHooks Function({bool servicioId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServiciosTableTableManager get servicios =>
      $$ServiciosTableTableManager(_db, _db.servicios);
  $$LecturasTableTableManager get lecturas =>
      $$LecturasTableTableManager(_db, _db.lecturas);
}
