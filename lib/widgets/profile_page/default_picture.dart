// Flutter imports:
import 'package:flutter/material.dart';

class DefaultPicture extends StatelessWidget {
  const DefaultPicture({
    super.key,
    required this.displayName,
    this.padding,
  });

  final String displayName;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ColoredBox(
        color: _defaultColors[displayName.hashCode % _defaultColors.length],
        child: Padding(
          padding: padding ?? const EdgeInsets.all(4),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              displayName.substring(0, 2),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

final List<Color> _defaultColors = [
  Colors.red.shade800,
  Colors.pink.shade800,
  Colors.purple.shade800,
  Colors.deepPurple.shade800,
  Colors.indigo.shade800,
  Colors.blue.shade800,
  Colors.lightBlue.shade800,
  Colors.cyan.shade800,
  Colors.teal.shade800,
  Colors.green.shade800,
  Colors.lightGreen.shade800,
  Colors.lime.shade800,
  Colors.yellow.shade800,
  Colors.amber.shade800,
  Colors.orange.shade800,
  Colors.deepOrange.shade800,
];
