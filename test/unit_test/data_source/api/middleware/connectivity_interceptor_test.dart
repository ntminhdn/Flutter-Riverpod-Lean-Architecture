import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class _MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late ConnectivityInterceptor connectivityInterceptor;
  final _mockRequestInterceptorHandler = _MockRequestInterceptorHandler();

  setUp(() {
    connectivityInterceptor = ConnectivityInterceptor(
      connectivityHelper,
    );
  });

  group('onRequest', () {
    test('when `isNetworkAvailable` is `true`', () async {
      when(() => connectivityHelper.isNetworkAvailable).thenAnswer((_) async => true);

      final options = RequestOptions(path: '/path');
      final handler = RequestInterceptorHandler();

      await connectivityInterceptor.onRequest(options, handler);

      expect(handler.next, isNotNull);
    });

    test('when `isNetworkAvailable` is `false`', () async {
      when(() => connectivityHelper.isNetworkAvailable).thenAnswer((_) async => false);

      final options = RequestOptions(path: '/path');

      await connectivityInterceptor.onRequest(options, _mockRequestInterceptorHandler);

      verify(() => _mockRequestInterceptorHandler.reject(
            any(
              that: isA<DioException>().having(
                (e) =>
                    e.error is RemoteException &&
                    (e.error as RemoteException).kind == RemoteExceptionKind.noInternet,
                'error',
                true,
              ),
            ),
          ));
    });
  });
}
