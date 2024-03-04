import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('map', () {
    test(
      'should return correct DataResponse<MockData2> when using valid MockData2 data',
      () async {
        final validResponse = {
          'data': {
            'mock_data': {
              'uid': 1,
              'email': 'a@gmail.com',
            },
          },
        };

        // ignore: variable_type_mismatch
        const expected = DataResponse<MockData2>(
          data: MockData2(
            mockData: MockData(
              id: 1,
              email: 'a@gmail.com',
            ),
          ),
        );

        final result = DataJsonObjectResponseDecoder<MockData2>().map(
          response: validResponse,
          decoder: (json) => MockData2.fromJson(json as Map<String, dynamic>),
        );

        expect(result, expected);
      },
    );

    test('should return correct DataResponse<MockData> when using valid MockData data', () {
      // arrange
      final validResponse = {
        'data': {
          'uid': 1,
          'email': 'a@gmail.com',
        },
      };

      // ignore: variable_type_mismatch
      const expected = DataResponse<MockData>(
        data: MockData(id: 1, email: 'a@gmail.com'),
      );

      final result = DataJsonObjectResponseDecoder<MockData>().map(
        response: validResponse,
        decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
      );

      expect(result, expected);
    });

    test('should return correct DataResponse<String> when using valid String data', () {
      // arrange
      final validResponse = {
        'data': 'a',
      };

      // ignore: variable_type_mismatch
      const expected = DataResponse<String>(
        data: 'a',
      );

      final result = DataJsonObjectResponseDecoder<String>().map(
        response: validResponse,
        decoder: (json) => json as String,
      );

      expect(result, expected);
    });

    test('should return correct DataResponse<int> when using valid int data', () {
      // arrange
      final validResponse = {
        'data': 1,
      };

      // ignore: variable_type_mismatch
      const expected = DataResponse<int>(
        data: 1,
      );

      final result = DataJsonObjectResponseDecoder<int>().map(
        response: validResponse,
        decoder: (json) => json as int,
      );

      expect(result, expected);
    });

    test('should return default DataResponse<MockData> when `data` is null', () {
      // arrange
      final validResponse = {
        'data': null,
      };

      // ignore: variable_type_mismatch
      const expected = DataResponse<MockData>();

      final result = DataJsonObjectResponseDecoder<MockData>().map(
        response: validResponse,
        decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
      );

      expect(result, expected);
    });

    test('should throw AssertionError when response is null', () {
      expect(
        () => DataJsonObjectResponseDecoder<MockData>().map(
          response: null,
          decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
        ),
        throwsAssertionError,
      );
    });

    test(
      'should return default DataResponse<MockData> when response does not have `data` JSON key',
      () async {
        final invalidResponse = {
          'result': {
            'uid': 1,
            'email': 'a@gmail.com',
          },
        };

        // ignore: variable_type_mismatch
        const expected = DataResponse<MockData>();

        final result = DataJsonObjectResponseDecoder<MockData>().map(
          response: invalidResponse,
          decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
        );

        expect(result, expected);
      },
    );

    test('should return default DataResponse<MockData> when all JSON keys are incorrect', () {
      final invalidResponse = {
        'data': {
          'uuid': 1, // incorrect key
          'gmail': 'a@gmail.com', // incorrect key
        },
      };

      // ignore: variable_type_mismatch
      const expected = DataResponse<MockData>(data: MockData());

      final result = DataJsonObjectResponseDecoder<MockData>().map(
        response: invalidResponse,
        decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
      );

      expect(result, expected);
    });

    test(
      'should return correct DataResponse<MockData> when some JSON keys are incorrect',
      () async {
        // arrange
        final validResponse = {
          'data': {
            'uuid': 1, // incorrect key
            'email': 'e@gmail.com', // correct key
          },
        };

        // ignore: variable_type_mismatch
        const expected = DataResponse<MockData>(
          data: MockData(email: 'e@gmail.com'),
        );

        final result = DataJsonObjectResponseDecoder<MockData>().map(
          response: validResponse,
          decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
        );

        expect(result, expected);
      },
    );

    test(
      'should throw RemoteException.decodeError when both type of `uid` and type of `email` are incorrect',
      () async {
        final invalidResponse = {
          'data': {
            'uid': '1', // incorrect type
            'email': 1, // incorrect type
          },
        };

        expect(
          () => DataJsonObjectResponseDecoder<MockData>().map(
            response: invalidResponse,
            decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
          ),
          throwsA(
            isA<RemoteException>().having(
              (e) => e.kind,
              'kind',
              RemoteExceptionKind.decodeError,
            ),
          ),
        );
      },
    );

    test(
      'should throw RemoteException.decodeError when `data` is JSONArray instead of JSONObject',
      () async {
        final invalidResponse = {
          'data': [
            {
              'uid': 1,
              'email': 'a@gmail.com',
            },
          ],
        };

        expect(
          () => DataJsonObjectResponseDecoder<MockData>().map(
            response: invalidResponse,
            decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
          ),
          throwsA(
            isA<RemoteException>().having(
              (e) => e.kind,
              'kind',
              RemoteExceptionKind.decodeError,
            ),
          ),
        );
      },
    );

    test(
      'should return null when using incorrect SuccessResponseDecoderType',
      () async {
        // JSON response type is incorrect
        final invalidResponse = [
          {
            'uid': 1,
            'email': 'ntminh@gmail.com',
          },
        ];

        // act
        final result = DataJsonObjectResponseDecoder<MockData>().map(
          response: invalidResponse,
          decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
        );

        // assert
        expect(result, null);
      },
    );
  });
}
