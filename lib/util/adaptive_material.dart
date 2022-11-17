// Flutter imports:
import 'package:flutter/material.dart';

enum AdaptiveColor {
  primary,
  secondary,
  background,
  surface,
  canvas,
}

extension ToColor on AdaptiveColor {
  Color color(BuildContext context) {
    switch (this) {
      case AdaptiveColor.primary:
        return Theme.of(context).colorScheme.primary;
      case AdaptiveColor.secondary:
        return Theme.of(context).colorScheme.secondary;
      case AdaptiveColor.background:
        return Theme.of(context).colorScheme.background;
      case AdaptiveColor.surface:
        return Theme.of(context).colorScheme.surface;
      case AdaptiveColor.canvas:
        return Theme.of(context).canvasColor;
    }
  }

  Color onColor(BuildContext context) {
    switch (this) {
      case AdaptiveColor.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case AdaptiveColor.secondary:
        return Theme.of(context).colorScheme.onSecondary;
      case AdaptiveColor.background:
        return Theme.of(context).colorScheme.onBackground;
      case AdaptiveColor.surface:
        return Theme.of(context).colorScheme.onSurface;
      case AdaptiveColor.canvas:
        return Theme.of(context).colorScheme.onSurface;
    }
  }
}

class AdaptiveMaterial extends StatelessWidget {
  const AdaptiveMaterial({
    required this.adaptiveColor,
    required this.child,
    this.isVisible = true,
    Key? key,
  }) : super(key: key);

  final AdaptiveColor adaptiveColor;
  final Widget? child;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return _ColorProvider<_OnColor>(
      adaptiveColor,
      _ColorProvider<_Color>(
        adaptiveColor,
        isVisible
            ? Material(
                color: adaptiveColor.color(context),
                child: child,
              )
            : Container(child: child),
        adaptiveColor.color(context),
      ),
      adaptiveColor.onColor(context),
    );
  }

  static Color? colorOf(BuildContext context) {
    final _ColorProvider? result =
        context.dependOnInheritedWidgetOfExactType<_ColorProvider<_Color>>();
    if (result == null) {
      return null;
    }
    return result._colorFromScheme;
  }

  static Color? onColorOf(BuildContext context) {
    return adaptiveColorOf(context)?.onColor(context);
  }

  static Color? secondaryOnColorOf(BuildContext context) {
    return onColorOf(context)?.withAlpha(120);
  }

  static AdaptiveColor? adaptiveColorOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ColorProvider<_OnColor>>()
        ?.adaptiveColor;
  }
}

abstract class _ColorProviderType {}

class _Color implements _ColorProviderType {}

class _OnColor implements _ColorProviderType {}

class _ColorProvider<T extends _ColorProviderType> extends InheritedWidget {
  const _ColorProvider(
    this.adaptiveColor,
    Widget child,
    this._colorFromScheme,
  ) : super(child: child);

  final AdaptiveColor adaptiveColor;

  final Color _colorFromScheme;

  @override
  bool updateShouldNotify(covariant _ColorProvider oldWidget) {
    return oldWidget.adaptiveColor != adaptiveColor ||
        oldWidget._colorFromScheme != _colorFromScheme;
  }
}

class AdaptiveIcon extends StatelessWidget {
  const AdaptiveIcon(
    this.icon, {
    Key? key,
    this.forcePrimary = false,
    this.size,
    this.semanticLabel,
    this.textDirection,
    this.color,
  }) : super(key: key);

  final bool forcePrimary;
  final IconData icon;
  final double? size;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color? onColor = color ??
        (forcePrimary
            ? AdaptiveMaterial.onColorOf(context)
            : AdaptiveMaterial.secondaryOnColorOf(context));
    assert(
      onColor != null,
      'The current `context` did not contain a parent `AdaptiveColor`. To use '
      'and adaptive widget, place an `AdaptiveColor` widget above this one '
      'in the widget tree.',
    );
    return Icon(
      icon,
      color: onColor,
      size: size,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}

class AdaptiveText extends StatelessWidget {
  const AdaptiveText(
    String this.data, {
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  }) : super(key: key);

  final String? data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      key: key,
      style: (style ?? const TextStyle())
          .copyWith(color: AdaptiveMaterial.onColorOf(context)),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
    );
  }
}

class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    Key? key,
    this.iconSize = 24.0,
    this.visualDensity,
    this.padding = const EdgeInsets.all(8),
    this.alignment = Alignment.center,
    this.splashRadius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    required this.onPressed,
    this.mouseCursor = SystemMouseCursors.click,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback = true,
    this.constraints,
    required this.icon,
  }) : super(key: key);

  final double iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsets padding;
  final Alignment alignment;
  final double? splashRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final MouseCursor mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool enableFeedback;
  final BoxConstraints? constraints;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final Color? onColor = AdaptiveMaterial.secondaryOnColorOf(context);
    assert(
      onColor != null,
      'The current `context` did not contain a parent `AdaptiveColor`. To use '
      'and adaptive widget, place an `AdaptiveColor` widget above this one '
      'in the widget tree.',
    );
    return IconButton(
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      color: onColor,

      /// TODO(caseycrogers): These colors should reflect `onColor` too.
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
      onPressed: onPressed,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      constraints: constraints,
      icon: icon,
    );
  }
}
