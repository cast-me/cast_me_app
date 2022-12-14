// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class CastMePage extends StatelessWidget {
  const CastMePage({
    super.key,
    this.headerText,
    this.trailingIcon,
    required this.child,
    this.footer,
    this.showBackButton = true,
    this.scrollable = false,
    this.material = AdaptiveMaterialType.surface,
    this.padding,
  });

  final String? headerText;
  final Widget? trailingIcon;
  final Widget child;
  final Widget? footer;
  final bool showBackButton;
  final bool scrollable;
  final AdaptiveMaterialType material;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // We put the padding around the child and the rest of the column's content
    // separately so that the scrollable content, if applicable, is padded
    // internally not externally.
    final Widget paddedChild = Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
    return AdaptiveMaterial(
      material: material,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconTheme(
              data: IconThemeData(
                // We should use the on color instead of secondary on color for
                // the header.
                color: material.onColorOf(context),
              ),
              child: Row(
                children: [
                  if (showBackButton)
                    const ImplicitNavigatorBackButton(
                      transitionDuration: Duration.zero,
                    ),
                  if (headerText != null)
                    Expanded(
                      child: Text(
                        headerText!,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                  if (headerText == null) const Spacer(),
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
            if (footer != null)
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: footer!,
              ),
          ],
        ),
      ),
    );
  }
}
