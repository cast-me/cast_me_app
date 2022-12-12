// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:just_the_tooltip/just_the_tooltip.dart';

class HideIfDeleted extends StatelessWidget {
  const HideIfDeleted({
    super.key,
    required this.child,
    required this.isDeleted,
  });

  final Widget child;
  final bool isDeleted;

  @override
  Widget build(BuildContext context) {
    if (!isDeleted) {
      return child;
    }
    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Spacer(),
              Text('[Removed]'),
              SizedBox(width: 4),
              JustTheTooltip(
                isModal: true,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('A cast will show up as removed if:\n'
                      'A) the user deleted the cast or their account\n'
                      'B) you have blocked the user who posted the cast\n'
                      'C) CastMe has banned the user or removed the cast'),
                ),
              ),
              Spacer(),
            ],
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
