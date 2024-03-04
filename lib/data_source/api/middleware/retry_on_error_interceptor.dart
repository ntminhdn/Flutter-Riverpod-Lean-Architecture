import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../index.dart';

class RetryOnErrorInterceptor extends BaseInterceptor {
  // ignore: prefer_named_parameters
  RetryOnErrorInterceptor(
    this._dio,
    this._retryHelper,
  ) : super(InterceptorType.retryOnError);

  final Dio _dio;
  final RetryOnErrorInterceptorHelper _retryHelper;

  @visibleForTesting
  static const retryHeaderKey = 'isRetry';
  @visibleForTesting
  static const retryCountKey = 'retryCount';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.headers.containsKey(retryHeaderKey)) {
      options.headers[retryCountKey] = Constant.maxRetries;
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    assert(err.requestOptions.headers[retryCountKey] != null);
    final retryCount = safeCast<int>(err.requestOptions.headers[retryCountKey]) ?? 0;
    if (retryCount > 0 && shouldRetry(err)) {
      await Future<void>.delayed(_retryHelper.getRetryInterval(retryCount));
      try {
        final response = await _dio.fetch<dynamic>(
          err.requestOptions
            ..headers[retryHeaderKey] = true
            ..headers[retryCountKey] = retryCount - 1,
        );

        return handler.resolve(response);
      } on Object catch (_) {
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }

  @visibleForTesting
  bool shouldRetry(DioException error) =>
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.sendTimeout;
}

class RetryOnErrorInterceptorHelper {
  Duration getRetryInterval(int remainingRetryCount) {
    switch (remainingRetryCount) {
      case 3:
        return Constant.firstRetryInterval;
      case 2:
        return Constant.secondRetryInterval;
      case 1:
        return Constant.thirdRetryInterval;
      default:
        throw Exception(
          'Invalid retry count',
        );
    }
  }
}
