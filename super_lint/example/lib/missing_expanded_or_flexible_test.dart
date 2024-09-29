// ignore_for_file: unused_local_variable, prefer_common_widgets

import 'package:flutter/material.dart';

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~
void main() {
  Row(
    children: [],
  );
  Row(
    children: [
      SizedBox(),
    ],
  );
  Column(
    children: [],
  );
  Column(
    children: [
      SizedBox(),
    ],
  );
  Stack(
    children: [
      SizedBox(),
      SizedBox(),
      SizedBox(),
    ],
  );
  Column(
    children: [
      SizedBox(),
      Expanded(child: SizedBox()),
    ],
  );
  Column(
    children: [
      SizedBox(),
      Flexible(child: SizedBox()),
    ],
  );
  Row(
    children: [
      SizedBox(),
      Expanded(child: SizedBox()),
    ],
  );
  Row(
    children: [
      SizedBox(),
      Flexible(child: SizedBox()),
    ],
  );
}

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~
void test() {
  // expect_lint: missing_expanded_or_flexible
  Row(
    children: [
      SizedBox(),
      SizedBox(),
    ],
  );
  // expect_lint: missing_expanded_or_flexible
  Row(
    children: [
      SizedBox(),
      SizedBox(),
      SizedBox(),
    ],
  );
  // expect_lint: missing_expanded_or_flexible
  Column(
    children: [
      SizedBox(),
      SizedBox(),
    ],
  );
  // expect_lint: missing_expanded_or_flexible
  Column(
    children: [
      SizedBox(),
      SizedBox(),
      SizedBox(),
    ],
  );
}
