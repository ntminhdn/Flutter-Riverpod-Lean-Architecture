import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'index.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> _downloadLanguageModel() async {
    final downloadModelFutures = <Future<void>>[];
    final modelManager = OnDeviceTranslatorModelManager();
    LanguageCode.values.forEach((element) async {
      final response = await modelManager.isModelDownloaded(element.localeCode);
      if (!response) {
        downloadModelFutures.add(modelManager.downloadModel(element.localeCode));
      }
    });
    await Future.wait(downloadModelFutures);
  }

  static Future<void> init() async {
    Env.init();
    unawaited(_downloadLanguageModel());
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
