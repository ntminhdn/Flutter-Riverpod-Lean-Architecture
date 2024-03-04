import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class _MockNoneAuthAppServerApiClient extends Mock implements NoneAuthAppServerApiClient {}

class _MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late RefreshTokenInterceptor refreshTokenInterceptor;
  final noneAuthAppServerApiClient = _MockNoneAuthAppServerApiClient();

  setUp(() {
    refreshTokenInterceptor = RefreshTokenInterceptor(
      appPreferences,
      refreshTokenApiService,
      noneAuthAppServerApiClient,
    );
  });

  group('onError', () {
    test('when API throws error that is not unauthorized', () async {
      final dummyOptions = RequestOptions(path: '/path');
      final dummyError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: 400,
        ),
      );
      final handler = _MockErrorInterceptorHandler();

      // Act
      refreshTokenInterceptor.onError(dummyError, handler);

      verifyNever(() => refreshTokenApiService.refreshToken(any()));
      verifyNever(() => noneAuthAppServerApiClient.fetch(any()));
      verifyNever(() => appPreferences.saveAccessToken(any()));
      verify(() => handler.next(dummyError)).called(1);
    });

    test('when API throws unauthorized error and API refresh token success', () async {
      final dummyOptions = RequestOptions(path: '/path');
      final dummyError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: HttpStatus.unauthorized,
        ),
      );
      final dummyResponse = Response(
        requestOptions: dummyOptions,
        data: 'dummyData',
        statusCode: 200,
      );
      const newAccessToken = 'newToken';
      const refreshToken = 'refreshToken';
      final errorHandler = _MockErrorInterceptorHandler();

      when(() => refreshTokenApiService.refreshToken(any()))
          .thenAnswer((_) async => const DataResponse(
                data: ApiRefreshTokenData(accessToken: newAccessToken),
              ));
      when(() => appPreferences.saveAccessToken(any())).thenAnswer((_) async {});
      when(() => appPreferences.refreshToken).thenAnswer((_) async => refreshToken);
      when(() => noneAuthAppServerApiClient.fetch(any())).thenAnswer((_) async => dummyResponse);

      // Act
      refreshTokenInterceptor.onError(dummyError, errorHandler);
      await Future<dynamic>.delayed(5.milliseconds);

      verify(() => refreshTokenApiService.refreshToken(refreshToken)).called(1);
      verify(() => noneAuthAppServerApiClient.fetch(dummyOptions)).called(1);
      verify(() => appPreferences.saveAccessToken(newAccessToken)).called(1);
      verify(() => errorHandler.resolve(dummyResponse)).called(1);
    });

    test('when API throws unauthorized error and API refresh token failed too', () async {
      final dummyOptions = RequestOptions(path: '/path');
      final dummyError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: HttpStatus.unauthorized,
        ),
      );
      final dummyRefreshTokenError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: 400,
        ),
      );
      final errorHandler = _MockErrorInterceptorHandler();

      when(() => appPreferences.refreshToken).thenAnswer((_) async => 'refreshToken');
      when(() => refreshTokenApiService.refreshToken(any())).thenThrow(dummyRefreshTokenError);

      // Act
      refreshTokenInterceptor.onError(dummyError, errorHandler);
      await Future<dynamic>.delayed(5.milliseconds);

      verify(() => refreshTokenApiService.refreshToken(any())).called(1);
      verifyNever(() => noneAuthAppServerApiClient.fetch(any()));
      verifyNever(() => appPreferences.saveAccessToken(any()));
      verify(() => errorHandler.next(any(
            that: isA<DioException>()
                .having((e) => e.requestOptions, 'requestOptions', dummyOptions)
                .having((e) => e.error, 'error', dummyRefreshTokenError),
          ))).called(1);
    });

    test('when two APIs throw unauthorized error and API refresh token success', () async {
      final dummyOptions = RequestOptions(path: '/path');
      final secondDummyOptions = RequestOptions(path: '/secondPath');
      final dummyError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: HttpStatus.unauthorized,
        ),
      );
      final secondDummyError = DioException(
        requestOptions: secondDummyOptions,
        response: Response(
          requestOptions: secondDummyOptions,
          statusCode: HttpStatus.unauthorized,
        ),
      );
      final dummyResponse = Response(
        requestOptions: dummyOptions,
        data: 'dummyData',
        statusCode: 200,
      );
      final secondDummyResponse = Response(
        requestOptions: secondDummyOptions,
        data: 'secondDummyData',
        statusCode: 200,
      );

      const newAccessToken = 'newToken';
      final errorHandler = _MockErrorInterceptorHandler();
      final secondErrorHandler = _MockErrorInterceptorHandler();

      when(() => refreshTokenApiService.refreshToken(any()))
          .thenAnswer((_) async => const DataResponse(
                data: ApiRefreshTokenData(accessToken: newAccessToken),
              ));
      when(() => appPreferences.saveAccessToken(any())).thenAnswer((_) async {});
      when(() => appPreferences.refreshToken).thenAnswer((_) async => 'refreshToken');
      when(() => noneAuthAppServerApiClient.fetch(dummyOptions))
          .thenAnswer((_) async => dummyResponse);
      when(() => noneAuthAppServerApiClient.fetch(secondDummyOptions))
          .thenAnswer((_) async => secondDummyResponse);

      // Act
      refreshTokenInterceptor.onError(dummyError, errorHandler);
      refreshTokenInterceptor.onError(secondDummyError, secondErrorHandler);
      await Future<dynamic>.delayed(5.milliseconds);

      verify(() => refreshTokenApiService.refreshToken(any())).called(1);
      verify(() => noneAuthAppServerApiClient.fetch(dummyOptions)).called(1);
      verify(() => noneAuthAppServerApiClient.fetch(secondDummyOptions)).called(1);
      verify(() => appPreferences.saveAccessToken(newAccessToken)).called(1);
      verify(() => errorHandler.resolve(dummyResponse)).called(1);
      verify(() => secondErrorHandler.resolve(secondDummyResponse)).called(1);
    });

    test('when two APIs throw unauthorized error and API refresh token failed too', () async {
      final dummyOptions = RequestOptions(path: '/path');
      final secondDummyOptions = RequestOptions(path: '/secondPath');
      final dummyError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: HttpStatus.unauthorized,
        ),
      );
      final secondDummyError = DioException(
        requestOptions: secondDummyOptions,
        response: Response(
          requestOptions: secondDummyOptions,
          statusCode: HttpStatus.unauthorized,
        ),
      );
      final dummyRefreshTokenError = DioException(
        requestOptions: dummyOptions,
        response: Response(
          requestOptions: dummyOptions,
          statusCode: 400,
        ),
      );
      final errorHandler = _MockErrorInterceptorHandler();
      final secondErrorHandler = _MockErrorInterceptorHandler();

      when(() => appPreferences.refreshToken).thenAnswer((_) async => 'refreshToken');
      when(() => refreshTokenApiService.refreshToken(any())).thenThrow(dummyRefreshTokenError);

      // Act
      refreshTokenInterceptor.onError(dummyError, errorHandler);
      refreshTokenInterceptor.onError(secondDummyError, secondErrorHandler);
      await Future<dynamic>.delayed(5.milliseconds);

      verify(() => refreshTokenApiService.refreshToken(any())).called(1);
      verify(() => errorHandler.next(any(
            that: isA<DioException>()
                .having((e) => e.requestOptions, 'requestOptions', dummyOptions)
                .having((e) => e.error, 'error', dummyRefreshTokenError),
          ))).called(1);
      verify(() => secondErrorHandler.next(any(
            that: isA<DioException>()
                .having((e) => e.requestOptions, 'requestOptions', secondDummyOptions)
                .having((e) => e.error, 'error', dummyRefreshTokenError),
          ))).called(1);
      verifyNever(() => noneAuthAppServerApiClient.fetch(any()));
      verifyNever(() => appPreferences.saveAccessToken(any()));
    });
  });
}
