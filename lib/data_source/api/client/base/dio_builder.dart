import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';

import '../../../../index.dart';

class DioBuilder {
  const DioBuilder._();

  static Dio createDio({
    BaseOptions? options,
    List<Interceptor> Function(Dio)? interceptors,
  }) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: options?.connectTimeout ?? Constant.connectTimeout,
        receiveTimeout: options?.receiveTimeout ?? Constant.receiveTimeout,
        sendTimeout: options?.sendTimeout ?? Constant.sendTimeout,
        baseUrl: options?.baseUrl ?? Constant.appApiBaseUrl,
      ),
    );

    final sortedInterceptors =
        (interceptors?.call(dio) ?? <Interceptor>[]).sortedByDescending((element) {
      return element.safeCast<BaseInterceptor>()?.type.priority ?? -1;
    });

    dio.interceptors.addAll(sortedInterceptors);

    return dio;
  }
}
