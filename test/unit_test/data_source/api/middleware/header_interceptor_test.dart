import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

void main() {
  late HeaderInterceptor headerInterceptor;
  group('onRequest', () {
    test('when `headers` is not empty', () async {
      headerInterceptor = HeaderInterceptor(
        packageHelper: packageHelper,
        deviceHelper: deviceHelper,
        headers: {
          'os': 'android',
        },
      );

      final options = RequestOptions(path: '/path');
      final handler = RequestInterceptorHandler();

      when(() => packageHelper.versionCode).thenReturn('1');
      when(() => packageHelper.versionName).thenReturn('1.0.0');
      when(() => deviceHelper.operatingSystem).thenReturn('android');

      await headerInterceptor.onRequest(options, handler);

      expect(options.headers, {
        'User-Agent': 'android - 1.0.0(1)',
        'os': 'android',
      });
    });

    test('when `headers` is empty', () async {
      headerInterceptor = HeaderInterceptor(
        packageHelper: packageHelper,
        deviceHelper: deviceHelper,
      );

      final options = RequestOptions(path: '/path');
      final handler = RequestInterceptorHandler();

      when(() => packageHelper.versionCode).thenReturn('3');
      when(() => packageHelper.versionName).thenReturn('2.2.2');
      when(() => deviceHelper.operatingSystem).thenReturn('ios');

      await headerInterceptor.onRequest(options, handler);

      expect(options.headers, {
        'User-Agent': 'ios - 2.2.2(3)',
      });
    });
  });
}
