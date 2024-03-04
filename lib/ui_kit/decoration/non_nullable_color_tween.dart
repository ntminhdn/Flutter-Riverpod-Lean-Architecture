import 'package:flutter/material.dart';

class NonNullableColorTween extends Tween<Color> {
  NonNullableColorTween({required Color begin, required Color end}) : super(begin: begin, end: end);

  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}
