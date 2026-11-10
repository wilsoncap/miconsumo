import 'package:intl/intl.dart';

DateTime soloFecha(DateTime fecha) =>
    DateTime(fecha.year, fecha.month, fecha.day);

DateTime primerDiaMes(DateTime fecha) => DateTime(fecha.year, fecha.month);

bool mismoMes(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

int diasEnMes(DateTime fecha) => DateTime(fecha.year, fecha.month + 1, 0).day;

String formatearFechaCorta(DateTime fecha) =>
    DateFormat('d MMM', 'es_CO').format(fecha);

String formatearFechaLarga(DateTime fecha) =>
    DateFormat('d MMMM yyyy', 'es_CO').format(fecha);

String formatearMes(DateTime fecha) =>
    DateFormat('MMMM yyyy', 'es_CO').format(fecha);
