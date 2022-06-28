import 'package:flutter/material.dart';

extension UtilStyle on TextStyle {
  TextStyle get asBold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get asNotBold => copyWith(fontWeight: FontWeight.normal);

  TextStyle get asItalic => copyWith(fontStyle: FontStyle.italic);

  TextStyle get asNotItalic => copyWith(fontStyle: FontStyle.normal);

  TextStyle asSize(double size) => copyWith(fontSize: size);

  TextStyle asColor(Color color) => copyWith(color: color);
}
