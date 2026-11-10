import 'package:flutter/material.dart';

import '../../domain/servicio.dart';

IconData iconoServicio(Servicio servicio) {
  final nombre = servicio.nombreNormalizado;
  if (nombre.contains('luz') || nombre.contains('energ')) {
    return Icons.lightbulb_outline;
  }
  if (nombre.contains('agua')) {
    return Icons.water_drop_outlined;
  }
  if (nombre.contains('gas')) {
    return Icons.local_fire_department_outlined;
  }
  return Icons.speed;
}
