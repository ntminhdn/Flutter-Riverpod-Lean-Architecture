import 'package:flutter/services.dart';

import 'index.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> init() async {
    Env.init();
    await configureInjection();
    await getIt.get<PackageHelper>().init();
    await SystemChrome.setPreferredOrientations(
      getIt.get<DeviceHelper>().deviceType == DeviceType.mobile
          ? Constant.mobileOrientation
          : Constant.tabletOrientation,
    );
    SystemChrome.setSystemUIOverlayStyle(Constant.systemUiOverlay);
  }
}
