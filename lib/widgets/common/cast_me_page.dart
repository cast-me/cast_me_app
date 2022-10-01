import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class CastMePage extends StatelessWidget {
  const CastMePage({
    Key? key,
    required this.headerText,
    this.trailingIcon,
    required this.child,
    this.isBasePage = false,
    this.scrollable = false,
  }) : super(key: key);

  final String headerText;
  final Widget? trailingIcon;
  final Widget child;
  final bool isBasePage;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    // We put the padding around the child and the rest of the column's content
    // separately so that the scrollable content, if applicable, is padded
    // internally not externally.
    final Widget paddedChild = Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: child,
    );
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Row(
                children: [
                  if (!isBasePage)
                    const ImplicitNavigatorBackButton(
                      transitionDuration: Duration.zero,
                    ),
                  Text(
                    headerText,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                  if (trailingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconTheme(
                        data: IconThemeData(
                          size: Theme.of(context).textTheme.headline3!.fontSize,
                          color: Colors.white,
                        ),
                        child: trailingIcon!,
                      ),
                    ),
                ],
              ),
            ),
            if (scrollable)
              Expanded(child: SingleChildScrollView(child: paddedChild))
            else
              Expanded(child: paddedChild),
          ],
        ),
      ),
    );
  }
}
