// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/adaptive_material.dart';

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({
    required this.builder,
    required this.child,
    this.padding,
    this.selectedColor,
    this.adaptiveBackgroundColor,
  });

  final Widget Function(BuildContext, VoidCallback) builder;
  final Widget child;
  final EdgeInsets? padding;
  final Color? selectedColor;
  final AdaptiveColor? adaptiveBackgroundColor;

  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveIconButton(
      splashColor: widget.selectedColor,
      highlightColor: widget.selectedColor,
      icon: widget.child,
      onPressed: () => _show(),
    );
  }

  void _show() {
    final renderBox = context.findRenderObject() as RenderBox;
    final Offset upperLeft = renderBox.localToGlobal(Offset.zero);
    bool onLeft = true;
    final double width = MediaQuery.of(context).size.width;
    if (upperLeft.dx > width / 2) {
      onLeft = false;
    }
    BoxConstraints? prevConstraints;
    showDialog<void>(
      useRootNavigator: false,
      useSafeArea: false,
      context: context,
      builder: (context) {
        return LayoutBuilder(builder: (context, constraints) {
          if (prevConstraints != null && constraints != prevConstraints) {
            _show();
          }
          prevConstraints = constraints;
          return Stack(
            children: [
              Positioned(
                top: upperLeft.dy + renderBox.size.height - 4 / 2,
                left: onLeft ? upperLeft.dx : null,
                right: onLeft
                    ? null
                    : width - upperLeft.dx - 2 * renderBox.size.width / 3,
                child: AdaptiveMaterial(
                  adaptiveColor:
                      widget.adaptiveBackgroundColor ?? AdaptiveColor.surface,
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(2),
                    child: widget.builder(
                      context,
                      Navigator.of(context).pop,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
