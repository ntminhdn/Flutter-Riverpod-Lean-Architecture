import 'package:flutter/foundation.dart';

class Config {
  const Config._();

  static const enableGeneralLog = kDebugMode;
  static const isPrettyJson = kDebugMode;

  /// provider observer
  static const logOnDidAddProvider = false;
  static const logOnDidDisposeProvider = kDebugMode;
  static const logOnDidUpdateProvider = false;
  static const logOnProviderDidFail = kDebugMode;

  /// navigator observer
  static const enableNavigatorObserverLog = kDebugMode;

  /// disposeBag
  static const enableDisposeBagLog = false;

  /// stream event log
  static const logOnStreamListen = false;
  static const logOnStreamData = false;
  static const logOnStreamError = false;
  static const logOnStreamDone = false;
  static const logOnStreamCancel = false;

  /// log interceptor
  static const enableLogInterceptor = kDebugMode;
  static const enableLogRequestInfo = kDebugMode;
  static const enableLogSuccessResponse = kDebugMode;
  static const enableLogErrorResponse = kDebugMode;

  /// load more executor
  static const enableLogExecutorOutput = false;

  /// device preview
  static const enableDevicePreview = false;
}
