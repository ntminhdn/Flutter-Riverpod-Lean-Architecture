import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('onRequest', () {
    test('when username and password are empty', () async {
      final options = RequestOptions(path: '/path');
      final handler = RequestInterceptorHandler();
      final basicAuthInterceptor = BasicAuthInterceptor(
        username: '',
        password: '',
      );

      basicAuthInterceptor.onRequest(options, handler);

      expect(options.headers, {'Authorization': 'Basic Og=='});
    });
  });

  test('when username and password are not empty', () async {
    final options = RequestOptions(path: '/path');
    final handler = RequestInterceptorHandler();
    final basicAuthInterceptor = BasicAuthInterceptor(
      username: 'username',
      password: 'password',
    );

    basicAuthInterceptor.onRequest(options, handler);

    expect(options.headers, {'Authorization': 'Basic dXNlcm5hbWU6cGFzc3dvcmQ='});
  });
}
