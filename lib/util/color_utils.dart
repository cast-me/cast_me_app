// Dart imports:
import 'dart:ui';

extension ColorUtils on Color {
  String get serialize => value.toRadixString(16);

  static Color deserialize(String serializedColor) {
    return Color(int.parse(serializedColor, radix: 16));
  }
}
