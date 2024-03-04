import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

void main() {
  late AccessTokenInterceptor accessTokenInterceptor;

  setUp(() {
    accessTokenInterceptor = AccessTokenInterceptor(
      appPreferences,
    );
  });

  group('onRequest', () {
    test('when `accessToken` is empty', () async {
      when(() => appPreferences.accessToken).thenAnswer((_) async => '');

      final options = RequestOptions(path: '/path');
      final handler = RequestInterceptorHandler();

      await accessTokenInterceptor.onRequest(options, handler);

      expect(options.headers, {});
    });

    test('when `accessToken` is not empty', () async {
      when(() => appPreferences.accessToken).thenAnswer((_) async => 'token');

      final options = RequestOptions(path: '/path');
      final handler = RequestInterceptorHandler();

      await accessTokenInterceptor.onRequest(options, handler);

      expect(options.headers, {
        Constant.basicAuthorization: '${Constant.bearer} token',
      });
    });
  });
}
