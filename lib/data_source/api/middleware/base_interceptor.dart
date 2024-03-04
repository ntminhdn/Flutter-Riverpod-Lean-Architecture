import 'package:dio/dio.dart';

abstract class BaseInterceptor extends InterceptorsWrapper {
  BaseInterceptor(this.type);

  final InterceptorType type;
}

enum InterceptorType {
  retryOnError(100), // add first
  connectivity(99), // add second
  basicAuth(40),
  refreshToken(30),
  accessToken(20),
  header(10),
  customLog(1); // add last

  const InterceptorType(this.priority);

  /// higher, add first
  /// lower, add last
  final int priority;
}
