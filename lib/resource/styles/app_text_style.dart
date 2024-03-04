import 'package:flutter/material.dart';

const _defaultLetterSpacing = 0.03;

const _baseTextStyle = TextStyle(
  letterSpacing: _defaultLetterSpacing,
  // height: 1.0,
);

TextStyle ts({
  required Color? color,
  required double? fontSize,
  Color? backgroundColor,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  TextOverflow? overflow,
  List<Shadow>? shadows,
  Locale? locale,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) {
  return _baseTextStyle.merge(
    TextStyle(
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      overflow: overflow,
      shadows: shadows,
      locale: locale,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    ),
  );
}
