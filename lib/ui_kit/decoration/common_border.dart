import 'package:flutter/material.dart';

import '../../index.dart';

abstract class CommonBorder {
  CommonBorder({
    double? borderWidth,
    this.borderColor,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  }) : borderWidth = borderWidth ?? (borderColor != null ? 1.rps : null);

  final Color? borderColor;
  final double? borderWidth;
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;

  BorderRadius? get borderRadius =>
      topLeft == null && topRight == null && bottomLeft == null && bottomRight == null
          ? null
          : BorderRadius.only(
              topLeft: Radius.circular(topLeft ?? 0),
              topRight: Radius.circular(topRight ?? 0),
              bottomLeft: Radius.circular(bottomLeft ?? 0),
              bottomRight: Radius.circular(bottomRight ?? 0),
            );

  bool get hasBorderWidth => borderColor != null && borderWidth != null;

  BoxBorder? get boxBorder =>
      hasBorderWidth ? Border.all(color: borderColor!, width: borderWidth!) : null;

  BorderSide? get borderSide =>
      hasBorderWidth ? BorderSide(color: borderColor!, width: borderWidth!) : null;

  InputBorder? get inputBorder => hasBorderWidth
      ? OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor!,
            width: borderWidth!,
          ),
          borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(0)),
        )
      : borderRadius != null
          ? OutlineInputBorder(borderRadius: borderRadius!)
          : null;
}
