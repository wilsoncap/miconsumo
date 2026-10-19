import 'package:flutter/material.dart';

/// Campo de texto con etiqueta, ayuda y error.
///
/// Un solo componente sirve para el nombre del servicio y para la etiqueta de
/// contrato: es más atómico que tener dos casi iguales.
///
/// Componente de presentación: recibe el controlador, los textos y la acción por
/// parámetro. No lee proveedores ni valida nada.
class CampoDeTexto extends StatelessWidget {
  /// Construye el campo.
  const CampoDeTexto({
    required this.etiqueta,
    required this.controlador,
    required this.alCambiar,
    this.ayuda,
    this.error,
    this.longitudMaxima,
    super.key,
  });

  /// Etiqueta del campo.
  final String etiqueta;

  /// Controlador del texto.
  final TextEditingController controlador;

  /// Acción al cambiar el texto.
  final ValueChanged<String> alCambiar;

  /// Texto de ayuda bajo el campo.
  final String? ayuda;

  /// Texto de error, si lo hay.
  final String? error;

  /// Longitud máxima admitida, si la hay.
  final int? longitudMaxima;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      onChanged: alCambiar,
      maxLength: longitudMaxima,
      decoration: InputDecoration(
        labelText: etiqueta,
        helperText: ayuda,
        errorText: error,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
