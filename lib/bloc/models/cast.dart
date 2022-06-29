import 'package:flutter/painting.dart';

import 'package:path/path.dart';

class Cast {
  const Cast({
    required this.author,
    required this.title,
    required this.duration,
    this.baseImage,
    this.accentColor,
  }) : assert((baseImage == null && accentColor == null) ||
            (baseImage != null && accentColor != null));

  final String author;
  final String title;
  final Duration duration;
  final String? baseImage;
  final Color? accentColor;

  String get image => baseImage ?? 'thisisfine.png';

  String get imagePath => join('assets', 'images', image);
}
