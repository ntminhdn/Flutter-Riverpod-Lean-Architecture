import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class TestConfig {
  const TestConfig._();

  static const targetPlatform = TargetPlatform.android;
  static const goldenTestsLocale = Locale('ja');
  static const l10nTestLocale = Locale('ja');

  static const targetGoldenTestDevices = [
    Device.phone,
    Device.iphone11,
    Device.tabletPortrait,
  ];
}
