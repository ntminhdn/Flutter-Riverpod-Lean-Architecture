import 'package:flutter/material.dart';

import '../../index.dart';

class DashBorder extends CommonBorder {
  DashBorder({
    super.borderColor,
    super.borderWidth,
    super.topLeft,
    super.topRight,
    super.bottomLeft,
    super.bottomRight,
    this.dash = defaultDash,
  }) : assert(dash.isNotEmpty);

  DashBorder.allRadius({
    required double radius,
    Color? borderColor,
    double? borderWidth,
    List<double> dash = defaultDash,
  }) : this(
          borderColor: borderColor,
          borderWidth: borderWidth,
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
          dash: dash,
        );

  DashBorder.topRadius({
    required double radius,
    Color? borderColor,
    double? borderWidth,
    List<double> dash = defaultDash,
  }) : this(
          borderColor: borderColor,
          borderWidth: borderWidth,
          topLeft: radius,
          topRight: radius,
          dash: dash,
        );

  DashBorder.bottomRadius({
    required double radius,
    Color? borderColor,
    double? borderWidth,
    List<double> dash = defaultDash,
  }) : this(
          borderColor: borderColor,
          borderWidth: borderWidth,
          bottomLeft: radius,
          bottomRight: radius,
          dash: dash,
        );

  final List<double> dash;

  static const defaultDash = <double>[3, 1];

  DashBorder merge(DashBorder otherBorder) {
    return copyWith(
      borderColor: otherBorder.borderColor,
      borderWidth: otherBorder.borderWidth,
      topLeft: otherBorder.topLeft,
      topRight: otherBorder.topRight,
      bottomLeft: otherBorder.bottomLeft,
      bottomRight: otherBorder.bottomRight,
      dash: otherBorder.dash,
    );
  }

  DashBorder copyWith({
    Color? borderColor,
    double? borderWidth,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    List<double>? dash,
  }) {
    return DashBorder(
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
      dash: dash ?? this.dash,
    );
  }
}
