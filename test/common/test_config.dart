import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class TestConfig {
  const TestConfig._();

  static const _isDarkModeKey = 'IS_DARK_MODE';
  static const _localeKey = 'LOCALE';

  static const targetPlatform = TargetPlatform.android;
  static const goldenTestsLocale = Locale(String.fromEnvironment(_localeKey, defaultValue: 'ja'));
  static const l10nTestLocale = Locale('ja');
  static const isDarkMode = bool.fromEnvironment(_isDarkModeKey);

  static const targetGoldenTestDevices = [
    Device.phone,
    Device.iphone11,
    Device.tabletPortrait,
  ];
}
