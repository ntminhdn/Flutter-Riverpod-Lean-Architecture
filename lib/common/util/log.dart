// ignore_for_file: prefer_named_parameters
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

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

enum LogMode { all, apiOnly, logEventOnly, normalLogOnly, none }

class Log {
  const Log._();

  static const _enableLog = Config.enableGeneralLog;
  static const generalLogMode = LogMode.logEventOnly;

  static void d(
    Object? message, {
    LogColor color = LogColor.green,
    LogMode mode = LogMode.normalLogOnly,
    String? name,
    DateTime? time,
  }) {
    if (!kDebugMode ||
        generalLogMode == LogMode.none ||
        (generalLogMode != LogMode.all && generalLogMode != mode)) return;
    _log('$message', color: color, name: name ?? '', time: time);
  }

  static void e(
    Object? errorMessage, {
    LogColor color = LogColor.red,
    LogMode mode = LogMode.normalLogOnly,
    String? name,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    if (!kDebugMode ||
        generalLogMode == LogMode.none ||
        (generalLogMode != LogMode.all && generalLogMode != mode)) return;
    _log(
      '$errorMessage',
      color: color,
      name: name ?? '',
      error: errorObject,
      stackTrace: stackTrace,
      time: time,
    );
  }

  static String prettyJson(dynamic json) {
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

  static String prettyResponse(dynamic data) {
    if (data is Map) {
      final indent = '  ' * 2;
      final encoder = JsonEncoder.withIndent(indent);

      return encoder.convert(data as Map<String, dynamic>);
    }

    return data.toString();
  }
}
