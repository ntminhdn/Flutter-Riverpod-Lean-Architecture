import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  late JsonObjectErrorResponseDecoder jsonObjectErrorResponseDecoder;

  setUp(() {
    jsonObjectErrorResponseDecoder = JsonObjectErrorResponseDecoder();
  });

  group('map', () {
    test('should return correct ServerError when using valid data response', () async {
      // arrange
      final errorResponse = {
        'error': {
          'status_code': 400,
          'error_code': 'invalid_request',
          'message': 'The request is invalid',
        },
      };
      const expected = ServerError(
        generalServerStatusCode: 400,
        generalServerErrorId: 'invalid_request',
        generalMessage: 'The request is invalid',
      );
      // act
      final result = jsonObjectErrorResponseDecoder.map(errorResponse);
      // assert
      expect(result, expected);
    });

    test('should return correct ServerError when some JSON keys are incorrect', () async {
      // arrange
      final errorResponse = {
        'error': {
          'status_code': 400,
          'er_code': 'invalid_request',
          'er_message': 'The request is invalid',
        },
      };
      const expected = ServerError(generalServerStatusCode: 400);
      // act
      final result = jsonObjectErrorResponseDecoder.map(errorResponse);
      // assert
      expect(result, expected);
    });

    test(
      'should return corresponding ServerError when all JSON keys are incorrect',
      () async {
        // arrange
        final errorResponse = {
          'error': {
            'er_code': 400,
            'er_message': 'The request is invalid',
          },
        };
        const expected = ServerError();
        final result = jsonObjectErrorResponseDecoder.map(errorResponse);
        // assert
        expect(result, expected);
      },
    );

    test('should thow RemoteException.decodeError when using invalid data type', () async {
      // arrange
      final errorResponse = {
        'error': {
          'status_code': '400',
          'error_code': true,
          'message': 1,
        },
      };
      // assert
      expect(
        () => jsonObjectErrorResponseDecoder.map(errorResponse),
        throwsA(isA<RemoteException>()),
      );
    });
  });
}
