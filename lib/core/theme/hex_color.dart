import 'package:flutter/material.dart';

Color colorFromHex(String hexColor) {
  final normalized = hexColor.replaceFirst('#', '');
  final value = int.tryParse(normalized, radix: 16);

  if (value == null || normalized.length != 6) {
    return const Color(0xFF5B67D6);
  }

  return Color(0xFF000000 | value);
}
