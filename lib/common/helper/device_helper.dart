import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final deviceHelperProvider = Provider<DeviceHelper>(
  (ref) => getIt.get<DeviceHelper>(),
);

enum DeviceType { mobile, tablet }

@LazySingleton()
class DeviceHelper {
  Future<String> get deviceId async {
    return await FlutterUdid.udid;
  }

  Future<String> get deviceModelName async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.name;
    } else {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return '${androidInfo.brand} ${androidInfo.device}';
    }
  }

  DeviceType get deviceType {
    const _maxMobileWidthForDeviceType = 550;

    return MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first)
                .size
                .shortestSide <
            _maxMobileWidthForDeviceType
        ? DeviceType.mobile
        : DeviceType.tablet;
  }

  String get operatingSystem => Platform.operatingSystem;
}
