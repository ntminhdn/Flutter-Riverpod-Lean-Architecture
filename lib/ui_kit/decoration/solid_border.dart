import 'package:flutter/material.dart';

import '../../index.dart';

class SolidBorder extends CommonBorder {
  SolidBorder({
    super.borderColor,
    super.borderWidth,
    super.topLeft,
    super.topRight,
    super.bottomLeft,
    super.bottomRight,
  });

  SolidBorder.allRadius({
    required double radius,
    Color? borderColor,
    double? borderWidth,
  }) : this(
          borderColor: borderColor,
          borderWidth: borderWidth,
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        );

  SolidBorder.topRadius({
    required double radius,
    Color? borderColor,
    double? borderWidth,
  }) : this(
          borderColor: borderColor,
          borderWidth: borderWidth,
          topLeft: radius,
          topRight: radius,
        );

  SolidBorder.bottomRadius({
    required double radius,
    Color? borderColor,
    double? borderWidth,
  }) : this(
          borderColor: borderColor,
          borderWidth: borderWidth,
          bottomLeft: radius,
          bottomRight: radius,
        );

  SolidBorder merge(SolidBorder otherBorder) {
    return copyWith(
      borderColor: otherBorder.borderColor,
      borderWidth: otherBorder.borderWidth,
      topLeft: otherBorder.topLeft,
      topRight: otherBorder.topRight,
      bottomLeft: otherBorder.bottomLeft,
      bottomRight: otherBorder.bottomRight,
    );
  }

  SolidBorder copyWith({
    Color? borderColor,
    double? borderWidth,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return SolidBorder(
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }
}
