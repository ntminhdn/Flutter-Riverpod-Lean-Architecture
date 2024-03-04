import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

class _MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

class _MockRetryOnErrorInterceptorHelper extends Mock implements RetryOnErrorInterceptorHelper {}

void main() {
  late RetryOnErrorInterceptor retryOnErrorInterceptor;
  late HttpClientAdapter httpClientAdapter;
  late RetryOnErrorInterceptorHelper retryOnErrorInterceptorHelper;
  late Dio dio;

  setUp(() {
    httpClientAdapter = _MockHttpClientAdapter();
    retryOnErrorInterceptorHelper = _MockRetryOnErrorInterceptorHelper();
    dio = Dio(
      BaseOptions(
        connectTimeout: 1.milliseconds,
        receiveTimeout: 1.milliseconds,
        sendTimeout: 1.milliseconds,
      ),
    )..httpClientAdapter = httpClientAdapter;
    retryOnErrorInterceptor = RetryOnErrorInterceptor(dio, retryOnErrorInterceptorHelper);
    dio.interceptors.add(retryOnErrorInterceptor);
  });

  group('onRequest and onError', () {
    test('when API does not throw any error', () async {
      const dummyPath = '/path';
      final dummyOptions = RequestOptions(path: dummyPath);
      const dummyJson = 'json';
      final dummySuccessResponse = ResponseBody.fromString(dummyJson, 200);
      const remainingRetryCount = Constant.maxRetries;

      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.headers[RetryOnErrorInterceptor.retryCountKey] == remainingRetryCount,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenAnswer((_) async => dummySuccessResponse);
      when(() => retryOnErrorInterceptorHelper.getRetryInterval(any())).thenReturn(1.milliseconds);

      final response = await dio.fetch(dummyOptions);
      await Future<dynamic>.delayed(30.milliseconds);

      expect(response.data, dummyJson);
      // first call
      verify(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>()
                  .having(
                    (e) => e.path,
                    'path',
                    dummyPath,
                  )
                  .having(
                    (e) => e.headers[RetryOnErrorInterceptor.retryHeaderKey],
                    'isRetry',
                    null,
                  ),
            ),
            any(),
            any(),
          )).called(1);
    });

    test(
      'when API throw connectionTimeout error and all retry attempts failed',
      () async {
        const dummyPath = '/path';
        final dummyOptions = RequestOptions(path: dummyPath);
        final dummyException =
            DioException.connectionTimeout(timeout: 1.milliseconds, requestOptions: dummyOptions);

        when(() => httpClientAdapter.fetch(any(), null, null)).thenThrow(dummyException);
        when(() => retryOnErrorInterceptorHelper.getRetryInterval(any()))
            .thenReturn(1.milliseconds);

        expect(dio.fetch(dummyOptions), throwsA(dummyException));
        await Future<dynamic>.delayed(30.milliseconds);

        verify(() => httpClientAdapter.fetch(
              any(
                that: isA<RequestOptions>().having(
                  (e) => e.path,
                  'path',
                  dummyPath,
                ),
              ),
              any(),
              any(),
            )).called(Constant.maxRetries + 1);
      },
    );

    test('when API throw sendTimeout error and the first retry attempts success', () async {
      const dummyPath = '/path';
      final dummyOptions = RequestOptions(path: dummyPath);
      final dummyException =
          DioException.sendTimeout(timeout: 1.milliseconds, requestOptions: dummyOptions);
      const dummyJson = 'json';
      final dummySuccessResponse = ResponseBody.fromString(dummyJson, 200);
      const remainingRetryCountWhenRetryingSuccess = Constant.maxRetries - 1;

      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) =>
                    e.headers[RetryOnErrorInterceptor.retryCountKey] !=
                    remainingRetryCountWhenRetryingSuccess,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenThrow(dummyException);
      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) =>
                    e.headers[RetryOnErrorInterceptor.retryCountKey] ==
                    remainingRetryCountWhenRetryingSuccess,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenAnswer((_) async => dummySuccessResponse);
      when(() => retryOnErrorInterceptorHelper.getRetryInterval(any())).thenReturn(1.milliseconds);

      final response = await dio.fetch(dummyOptions);
      await Future<dynamic>.delayed(30.milliseconds);

      expect(response.data, dummyJson);
      verify(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.path,
                'path',
                dummyPath,
              ),
            ),
            any(),
            any(),
          )).called(2);
    });

    test('when API throw receiveTimeout error and the second retry attempts success', () async {
      const dummyPath = '/path';
      final dummyOptions = RequestOptions(path: dummyPath);
      final dummyException =
          DioException.receiveTimeout(timeout: 1.milliseconds, requestOptions: dummyOptions);
      const dummyJson = 'json';
      final dummySuccessResponse = ResponseBody.fromString(dummyJson, 200);
      const remainingRetryCount = Constant.maxRetries - 2;

      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.headers[RetryOnErrorInterceptor.retryCountKey] != remainingRetryCount,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenThrow(dummyException);
      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.headers[RetryOnErrorInterceptor.retryCountKey] == remainingRetryCount,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenAnswer((_) async => dummySuccessResponse);
      when(() => retryOnErrorInterceptorHelper.getRetryInterval(any())).thenReturn(1.milliseconds);

      final response = await dio.fetch(dummyOptions);
      await Future<dynamic>.delayed(30.milliseconds);

      expect(response.data, dummyJson);
      verify(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.path,
                'path',
                dummyPath,
              ),
            ),
            any(),
            any(),
          )).called(3);
    });

    test('when API throw connectionError error and the third retry attempts success', () async {
      const dummyPath = '/path';
      final dummyOptions = RequestOptions(path: dummyPath);
      final dummyException =
          DioException.connectionError(reason: 'Connection error', requestOptions: dummyOptions);
      const dummyJson = 'json';
      final dummySuccessResponse = ResponseBody.fromString(dummyJson, 200);
      const remainingRetryCount = Constant.maxRetries - 3;

      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.headers[RetryOnErrorInterceptor.retryCountKey] != remainingRetryCount,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenThrow(dummyException);
      when(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.headers[RetryOnErrorInterceptor.retryCountKey] == remainingRetryCount,
                'retryCount',
                true,
              ),
            ),
            null,
            null,
          )).thenAnswer((_) async => dummySuccessResponse);
      when(() => retryOnErrorInterceptorHelper.getRetryInterval(any())).thenReturn(1.milliseconds);

      final response = await dio.fetch(dummyOptions);
      await Future<dynamic>.delayed(30.milliseconds);

      expect(response.data, dummyJson);
      verify(() => httpClientAdapter.fetch(
            any(
              that: isA<RequestOptions>().having(
                (e) => e.path,
                'path',
                dummyPath,
              ),
            ),
            any(),
            any(),
          )).called(4);
    });
  });

  group('shouldRetry', () {
    test('when exception is connectionTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/path'),
        type: DioExceptionType.connectionTimeout,
      );
      expect(retryOnErrorInterceptor.shouldRetry(exception), true);
    });

    test('when exception is receiveTimeout', () {
      final exception = DioException.receiveTimeout(
        timeout: 1.milliseconds,
        requestOptions: RequestOptions(path: '/path'),
      );
      expect(retryOnErrorInterceptor.shouldRetry(exception), true);
    });

    test('when exception is connectionError', () {
      final exception = DioException.connectionError(
        reason: 'Connection error',
        requestOptions: RequestOptions(path: '/path'),
      );
      expect(retryOnErrorInterceptor.shouldRetry(exception), true);
    });

    test('when exception is sendTimeout', () {
      final exception = DioException.sendTimeout(
        timeout: 1.milliseconds,
        requestOptions: RequestOptions(path: '/path'),
      );
      expect(retryOnErrorInterceptor.shouldRetry(exception), true);
    });

    test('when exception is unknown error', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/path'),
        error: Exception('Unknown error'),
      );
      expect(retryOnErrorInterceptor.shouldRetry(exception), false);
    });
  });

  group('RetryOnErrorInterceptorHelper', () {
    test('when remainingRetryCount is 0', () {
      final retryHelper = RetryOnErrorInterceptorHelper();
      expect(() => retryHelper.getRetryInterval(0), throwsException);
    });

    test('when remainingRetryCount is 1', () {
      final retryHelper = RetryOnErrorInterceptorHelper();
      expect(retryHelper.getRetryInterval(1), Constant.thirdRetryInterval);
    });

    test('when remainingRetryCount is 2', () {
      final retryHelper = RetryOnErrorInterceptorHelper();
      expect(retryHelper.getRetryInterval(2), Constant.secondRetryInterval);
    });

    test('when remainingRetryCount is 3', () {
      final retryHelper = RetryOnErrorInterceptorHelper();
      expect(retryHelper.getRetryInterval(3), Constant.firstRetryInterval);
    });

    test('when remainingRetryCount is 4', () {
      final retryHelper = RetryOnErrorInterceptorHelper();
      expect(() => retryHelper.getRetryInterval(4), throwsException);
    });
  });
}
