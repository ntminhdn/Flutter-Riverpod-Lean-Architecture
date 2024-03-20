// ignore_for_file: prefer_named_parameters
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import '../../index.dart';

enum LogColor {
  black('\x1B[30m'),
  white('\x1B[37m'),
  red('\x1B[31m'),
  green('\x1B[32m'),
  yellow('\x1B[33m'),
  blue('\x1B[34m'),
  cyan('\x1B[36m');

  const LogColor(this.code);

  final String code;
}

class Log {
  const Log._();

  static const _enableLog = Config.enableGeneralLog;

  static void d(
    Object? message, {
    LogColor color = LogColor.green,
    String? name,
    DateTime? time,
  }) {
    _log('$message', color: color, name: name ?? '', time: time);
  }

  static void e(
    Object? errorMessage, {
    LogColor color = LogColor.red,
    String? name,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    _log(
      '$errorMessage',
      color: color,
      name: name ?? '',
      error: errorObject,
      stackTrace: stackTrace,
      time: time,
    );
  }

  static String prettyJson(Map<String, dynamic> json) {
    if (!Config.isPrettyJson) {
      return json.toString();
    }

    final indent = '  ' * 2;
    final encoder = JsonEncoder.withIndent(indent);

    return encoder.convert(json);
  }

  static void _log(
    String message, {
    LogColor color = LogColor.yellow,
    int level = 0,
    String name = '',
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_enableLog) {
      dev.log(
        '${color.code}$message\x1B[0m',
        name: name,
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

mixin LogMixin on Object {
  void logD(
    String message, {
    LogColor color = LogColor.green,
    DateTime? time,
  }) {
    Log.d(
      message,
      name: runtimeType.toString(),
      time: time,
      color: color,
    );
  }

  void logE(
    Object? errorMessage, {
    LogColor color = LogColor.red,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    Log.e(
      errorMessage,
      name: runtimeType.toString(),
      errorObject: errorObject,
      stackTrace: stackTrace,
      time: time,
      color: color,
    );
  }
}
