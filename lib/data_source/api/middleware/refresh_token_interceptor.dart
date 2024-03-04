import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../index.dart';

class RefreshTokenInterceptor extends BaseInterceptor {
  // ignore: prefer_named_parameters
  RefreshTokenInterceptor(
    this.appPreferences,
    this.refreshTokenService,
    this.noneAuthAppServerApiClient,
  ) : super(InterceptorType.refreshToken);

  final AppPreferences appPreferences;
  final RefreshTokenApiService refreshTokenService;
  final NoneAuthAppServerApiClient noneAuthAppServerApiClient;

  var _isRefreshing = false;
  final _queue = Queue<({RequestOptions options, ErrorInterceptorHandler handler})>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      final options = err.response!.requestOptions;
      _onExpiredToken(options: options, handler: handler);
    } else {
      handler.next(err);
    }
  }

  void _putAccessToken({
    required Map<String, dynamic> headers,
    required String accessToken,
  }) {
    headers[Constant.basicAuthorization] = '${Constant.bearer} $accessToken';
  }

  Future<void> _onExpiredToken({
    required RequestOptions options,
    required ErrorInterceptorHandler handler,
  }) async {
    _queue.addLast((options: options, handler: handler));
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        await _onRefreshTokenSuccess(newToken);
      } catch (e) {
        _onRefreshTokenError(e);
      } finally {
        _isRefreshing = false;
        _queue.clear();
      }
    }
  }

  Future<String> _refreshToken() async {
    _isRefreshing = true;
    final refreshToken = await appPreferences.refreshToken;
    final refreshTokenResponse = await refreshTokenService.refreshToken(refreshToken);
    await appPreferences.saveAccessToken(
      refreshTokenResponse?.data?.accessToken ?? '',
    );

    return refreshTokenResponse?.data?.accessToken ?? '';
  }

  Future<void> _onRefreshTokenSuccess(String newToken) async {
    await Future.wait(_queue.map(
      (requestInfo) => _requestWithNewToken(
        options: requestInfo.options,
        handler: requestInfo.handler,
        newAccessToken: newToken,
      ),
    ));
  }

  void _onRefreshTokenError(Object? error) {
    _queue.forEach((element) {
      final options = element.options;
      final handler = element.handler;
      handler.next(DioException(requestOptions: options, error: error));
    });
  }

  Future<void> _requestWithNewToken({
    required RequestOptions options,
    required ErrorInterceptorHandler handler,
    required String newAccessToken,
  }) async {
    _putAccessToken(headers: options.headers, accessToken: newAccessToken);

    try {
      final response = await noneAuthAppServerApiClient.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.next(DioException(requestOptions: options, error: e));
    }
  }
}
