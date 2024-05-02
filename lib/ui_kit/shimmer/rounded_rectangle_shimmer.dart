// ignore_for_file: avoid_hard_coded_colors
import 'package:flutter/material.dart';

import '../../index.dart';

class RounedRectangleShimmer extends StatelessWidget {
  const RounedRectangleShimmer({
    this.width,
    this.height,
    this.radius,
    super.key,
  });

  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_common_widgets
    return Container(
      width: width,
      height: height ?? 16.rps,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius ?? 8.rps),
      ),
    );
  }
}
