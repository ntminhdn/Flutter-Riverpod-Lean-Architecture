import 'package:flutter/material.dart';

class CommonInkWell extends StatelessWidget {
  CommonInkWell({
    super.key,
    this.child,
    this.onTap,
    this.onTapDown,
    this.onDoubleTap,
    this.onLongPress,
    this.padding,
    Color? color,
    this.splashColor,
    this.hoverColor,
    this.highlightColor,
    Decoration? decoration,
    this.width,
    this.height,
    this.borderRadius,
  })  : assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(
          color == null || decoration == null,
          'Cannot provide both a color and a decoration\n'
          'The color argument is just a shorthand for "decoration: BoxDecoration(color: color)".',
        ),
        decoration = decoration ?? (color != null ? BoxDecoration(color: color) : null);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Called when the user taps this part of the material.
  final GestureTapCallback? onTap;

  /// Called when the user taps down this part of the material.
  final GestureTapDownCallback? onTapDown;

  /// Called when the user double taps this part of the material.
  final GestureTapCallback? onDoubleTap;

  /// Called when the user long-presses on this part of the material.
  final GestureLongPressCallback? onLongPress;

  final EdgeInsetsGeometry? padding;

  final Decoration? decoration;

  /// A width to apply to the [decoration] and the [child]. The width includes
  /// any [padding].
  final double? width;

  /// A height to apply to the [decoration] and the [child]. The height includes
  /// any [padding].
  final double? height;

  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        padding: padding,
        decoration: decoration,
        height: height,
        width: width,
        child: InkWell(
          onTap: onTap,
          onTapDown: onTapDown,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          splashColor: splashColor ?? Theme.of(context).highlightColor,
          hoverColor: hoverColor ?? Theme.of(context).highlightColor,
          highlightColor: highlightColor ?? Theme.of(context).highlightColor,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
