// Flutter imports:
import 'package:flutter/material.dart';

Widget subPageTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: SlideTransition(
      position: Tween(
        begin: Offset.zero,
        end: const Offset(-.5, 0),
      ).animate(secondaryAnimation),
      child: child,
    ),
  );
}
