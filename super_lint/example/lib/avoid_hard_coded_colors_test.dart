// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~
void main() {
  // ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~
  final cl = AppColor();
  final red = cl.red;
  Container(color: cl.white);
  setColor(cl.red2);
}

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~
void test() {
  // expect_lint: avoid_hard_coded_colors
  final red = Colors.red;
  // expect_lint: avoid_hard_coded_colors
  Container(color: Color(0xFFFFFFFF));
  // expect_lint: avoid_hard_coded_colors
  setColor(Color.fromARGB(255, 226, 52, 52));
}

class AppColor {
  // expect_lint: avoid_hard_coded_colors
  final Color red = Colors.red;
  // expect_lint: avoid_hard_coded_colors
  final Color white = Color(0xFFFFFFFF);
  // expect_lint: avoid_hard_coded_colors
  final Color red2 = Color.fromARGB(255, 226, 52, 52);
}

void setColor(Color color) {}
