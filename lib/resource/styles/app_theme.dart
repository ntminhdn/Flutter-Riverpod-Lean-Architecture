// ignore_for_file: avoid_hard_coded_colors
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../index.dart';

/// define custom themes here
final lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: Colors.transparent,
  fontFamily: defaultTargetPlatform == TargetPlatform.android ? FontFamily.notoSansJP : null,
)..addAppColor(
    type: AppThemeType.light,
    appColor: AppColor.defaultAppColor,
  );

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  splashColor: Colors.transparent,
  fontFamily: defaultTargetPlatform == TargetPlatform.android ? FontFamily.notoSansJP : null,
)..addAppColor(
    type: AppThemeType.dark,
    appColor: AppColor.darkThemeColor,
  );

enum AppThemeType { light, dark }

extension ThemeDataExtensions on ThemeData {
  static final Map<AppThemeType, AppColor> _appColorMap = {};

  void addAppColor({
    required AppThemeType type,
    required AppColor appColor,
  }) {
    _appColorMap[type] = appColor;
  }

  AppColor get appColor {
    return _appColorMap[AppThemeSetting.currentAppThemeType] ?? AppColor.defaultAppColor;
  }
}

class AppThemeSetting {
  const AppThemeSetting._();
  static late AppThemeType currentAppThemeType = AppThemeType.light;
}
