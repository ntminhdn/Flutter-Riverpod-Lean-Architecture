import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../../common/index.dart';

class _MockNoneAuthAppServerApiClient extends Mock implements NoneAuthAppServerApiClient {}

class _MockRetryOnErrorInterceptorHelper extends Mock implements RetryOnErrorInterceptorHelper {}

class _MockDio extends Mock implements Dio {}

void main() {
  group('createDio', () {
    test('when specifying `connectTimeout`, `receiveTimeout`, `sendTimeout`, `baseUrl`', () async {
      final dio = DioBuilder.createDio(
        options: BaseOptions(
          connectTimeout: 1.seconds,
          receiveTimeout: 2.seconds,
          sendTimeout: 3.seconds,
          baseUrl: 'https://google.com',
        ),
      );

      expect(dio.options.connectTimeout, 1.seconds);
      expect(dio.options.receiveTimeout, 2.seconds);
      expect(dio.options.sendTimeout, 3.seconds);
      expect(dio.options.baseUrl, 'https://google.com');
    });

    test(
      'when not specifying `connectTimeout`, `receiveTimeout`, `sendTimeout`, `baseUrl`',
      () async {
        final dio = DioBuilder.createDio();

        expect(dio.options.connectTimeout, Constant.connectTimeout);
        expect(dio.options.receiveTimeout, Constant.receiveTimeout);
        expect(dio.options.sendTimeout, Constant.sendTimeout);
        expect(dio.options.baseUrl, Constant.appApiBaseUrl);
      },
    );

    test('when `interceptors` is empty', () async {
      final defaultInterceptorLength = Dio().interceptors.length;
      final dio = DioBuilder.createDio(
        interceptors: (dio) => [],
      );

      expect(dio.interceptors.length, defaultInterceptorLength);
    });

    test('when `interceptors` is not empty', () async {
      final defaultInterceptorLength = Dio().interceptors.length;
      final headerInterceptor = HeaderInterceptor(
        packageHelper: packageHelper,
        deviceHelper: deviceHelper,
      );
      final accessTokenInterceptor = AccessTokenInterceptor(appPreferences);
      final basicAuthInterceptor = BasicAuthInterceptor(username: 'username', password: 'password');
      final connectivityInterceptor = ConnectivityInterceptor(connectivityHelper);
      final refreshTokenInterceptor = RefreshTokenInterceptor(
        appPreferences,
        refreshTokenApiService,
        _MockNoneAuthAppServerApiClient(),
      );
      final retryOnErrorInterceptor =
          RetryOnErrorInterceptor(_MockDio(), _MockRetryOnErrorInterceptorHelper());
      final customLogInterceptor = CustomLogInterceptor();
      final dio = DioBuilder.createDio(
        interceptors: (dio) => [
          headerInterceptor,
          accessTokenInterceptor,
          basicAuthInterceptor,
          connectivityInterceptor,
          refreshTokenInterceptor,
          retryOnErrorInterceptor,
          customLogInterceptor,
        ],
      );

      expect(dio.interceptors.length, 7 + defaultInterceptorLength);
      expect(dio.interceptors[dio.interceptors.length - 1], customLogInterceptor); // add last
      expect(dio.interceptors[dio.interceptors.length - 2], headerInterceptor);
      expect(dio.interceptors[dio.interceptors.length - 3], accessTokenInterceptor);
      expect(dio.interceptors[dio.interceptors.length - 4], refreshTokenInterceptor);
      expect(dio.interceptors[dio.interceptors.length - 5], basicAuthInterceptor);
      expect(dio.interceptors[dio.interceptors.length - 6], connectivityInterceptor);
      expect(dio.interceptors[dio.interceptors.length - 7], retryOnErrorInterceptor); // add first
    });
  });
}
