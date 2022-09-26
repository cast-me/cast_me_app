import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class CastMePage extends StatelessWidget {
  const CastMePage({
    Key? key,
    required this.headerText,
    required this.child,
    this.isBasePage = false,
  }) : super(key: key);

  final String headerText;
  final Widget child;
  final bool isBasePage;

  @override
  Widget build(BuildContext context) {
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  if (!isBasePage) const ImplicitNavigatorBackButton(
                    transitionDuration: Duration.zero,
                  ),
                  Text(
                    headerText,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline3!.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
