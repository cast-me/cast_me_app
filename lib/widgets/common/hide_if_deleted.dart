import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:flutter/material.dart';

class HideIfDeleted extends StatelessWidget {
  const HideIfDeleted({
    Key? key,
    required this.child,
    required this.isDeleted,
  }) : super(key: key);

  final Widget child;
  final bool isDeleted;

  @override
  Widget build(BuildContext context) {
    if (!isDeleted) {
      return child;
    }
    return Stack(
      children: [
        const Positioned.fill(
          child: Center(
            child: Text('[Removed]'),
          ),
        ),
        IgnorePointer(
          child: Opacity(
            opacity: 0,
            child: child,
          ),
        ),
      ],
    );
  }
}
