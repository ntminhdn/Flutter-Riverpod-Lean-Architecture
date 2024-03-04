// ignore_for_file: avoid_hard_coded_colors
import 'package:flutter/material.dart';

import '../../index.dart';

class AppColor {
  const AppColor({
    required this.white,
    required this.black,
    required this.black2,
    required this.black3,
    required this.red1,
    required this.grey1,
    required this.grey2,
    required this.green1,
  });

  static late AppColor current;

  final Color white;
  final Color black;
  final Color black2;
  final Color black3;
  final Color red1;
  final Color grey1;
  final Color grey2;
  final Color green1;

  static const defaultAppColor = AppColor(
    white: Colors.white,
    black: Colors.black,
    black2: Colors.black54,
    black3: Color(0xFF272336),
    red1: Colors.red,
    grey1: Colors.grey,
    grey2: Color(0xFFF2F2F2),
    green1: Colors.green,
  );

  static const darkThemeColor = AppColor(
    white: Colors.black,
    black: Colors.white,
    black2: Colors.white54,
    black3: Color(0xFFd8dcc9),
    red1: Colors.red,
    grey1: Colors.grey,
    grey2: Color(0xFFF2F2F2),
    green1: Colors.green,
  );

  static AppColor of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }
}
