// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servicios_dao.dart';

// ignore_for_file: type=lint
mixin _$ServiciosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ServiciosTable get servicios => attachedDatabase.servicios;
  ServiciosDaoManager get managers => ServiciosDaoManager(this);
}

class ServiciosDaoManager {
  final _$ServiciosDaoMixin _db;
  ServiciosDaoManager(this._db);
  $$ServiciosTableTableManager get servicios =>
      $$ServiciosTableTableManager(_db.attachedDatabase, _db.servicios);
}
