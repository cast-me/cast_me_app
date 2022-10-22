import 'package:flutter/material.dart';

/// A container that reports it's height when it changes after builds.
class SizeReportingContainer extends StatefulWidget {
  const SizeReportingContainer({
    Key? key,
    required this.child,
    required this.sizeCallback,
  }) : super(key: key);

  final Widget child;
  final ValueChanged<Size> sizeCallback;

  @override
  State<SizeReportingContainer> createState() => _SizeReportingContainerState();
}

class _SizeReportingContainerState extends State<SizeReportingContainer> {
  final GlobalKey key = GlobalKey();
  Size? lastSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Size? newSize = key.currentContext?.size;
      if (newSize != null && lastSize != newSize) {
        lastSize = newSize;
        widget.sizeCallback(newSize);
      }
    });
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
